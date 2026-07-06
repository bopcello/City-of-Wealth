const axios = require('axios');
const admin = require('firebase-admin');

// Initialize Firebase
if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
} else {
  admin.initializeApp();
}

const db = admin.firestore();

/**
 * Fetches the last 30 daily quizzes from Firestore to avoid repeated topics or questions.
 * @returns {Promise<Array<{topic: string, question: string, answer: string}>>}
 */
async function fetchRecentQuestions() {
  console.log('Fetching the last 30 daily quizzes from Firestore...');
  const pastQuizzesSnapshot = await db.collection('daily_quizzes')
    .orderBy('timestamp', 'desc')
    .limit(30)
    .get();

  const pastQuestions = [];
  pastQuizzesSnapshot.forEach(doc => {
    const data = doc.data();
    if (data.question) {
      const correctAnswer = data.options && data.options[data.correctIndex] !== undefined
        ? data.options[data.correctIndex]
        : 'Unknown';
      pastQuestions.push({
        topic: data.title || 'Unknown',
        question: data.question,
        answer: correctAnswer
      });
    }
  });

  console.log(`Successfully fetched ${pastQuestions.length} recent questions.`);
  return pastQuestions;
}

/**
 * Fetches recent finance/business news from the last 7 days using NewsAPI.
 * @returns {Promise<Array<object>>}
 */
async function fetchFinanceNews() {
  const NEWS_API_KEY = process.env.NEWS_API_KEY;
  if (!NEWS_API_KEY) {
    throw new Error('NEWS_API_KEY environment variable is missing.');
  }

  const sevenDaysAgo = new Date();
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
  const fromDate = sevenDaysAgo.toISOString().split('T')[0];

  const query = 'finance OR economy OR "stock market" OR inflation OR "interest rates" OR "central bank" OR "Federal Reserve" OR ECB OR RBI OR earnings OR IPO OR mergers OR acquisitions OR cryptocurrency OR bitcoin OR "AI companies" OR recession';
  const domains = 'reuters.com,bloomberg.com,cnbc.com,ft.com,wsj.com,apnews.com,bbc.com,fortune.com,businessinsider.com,finance.yahoo.com,marketwatch.com';

  console.log(`Fetching finance/business news since ${fromDate} from NewsAPI...`);
  
  const response = await axios.get('https://newsapi.org/v2/everything', {
    params: {
      q: query,
      domains: domains,
      from: fromDate,
      sortBy: 'publishedAt',
      pageSize: 40,
      language: 'en',
      apiKey: NEWS_API_KEY
    },
    timeout: 15000
  });

  if (response.data && response.data.status !== 'ok') {
    throw new Error(`NewsAPI status is not OK: ${response.data.status || 'Unknown status'}`);
  }

  const articles = (response.data && response.data.articles) || [];
  console.log(`Fetched ${articles.length} raw articles from NewsAPI.`);
  return articles;
}

/**
 * Normalizes and converts news articles to a clean summary of up to 15-20 unique headlines.
 * @param {Array<object>} articles 
 * @returns {string}
 */
function summarizeNews(articles) {
  if (!articles || articles.length === 0) {
    return '';
  }

  const uniqueHeadlines = new Set();
  const bulletPoints = [];

  for (const article of articles) {
    if (!article.title) continue;
    
    if (article.title.toLowerCase().includes('[removed]')) continue;

    const trimmedTitle = article.title.trim();
    const normalized = trimmedTitle.toLowerCase();

    if (!uniqueHeadlines.has(normalized)) {
      uniqueHeadlines.add(normalized);
      bulletPoints.push(`• ${trimmedTitle}`);
      
      if (bulletPoints.length >= 20) {
        break;
      }
    }
  }

  if (bulletPoints.length === 0) {
    return '';
  }

  return `Recent finance news:\n\n${bulletPoints.join('\n')}`;
}

/**
 * Builds the prompt message for OpenRouter.
 * @param {string} today 
 * @param {string} newsSummary 
 * @param {string} pastQuestionsText 
 * @returns {string}
 */
function buildPrompt(today, newsSummary, pastQuestionsText) {
  const newsSection = newsSummary
    ? `Below is a compact summary of recent finance news from the last 7 days. Use this news to generate ONE current finance quiz question about a real current event or recent development:\n\n${newsSummary}\n\nIf the news summary is empty or does not contain relevant financial topics, fallback to generating a timeless finance question instead.`
    : 'No relevant recent news was found. Generate a timeless finance question instead.';

  return `Today's date is ${today}.

${newsSection}

${pastQuestionsText}

Generate ONE finance quiz document.

Ensure the following constraints are strictly satisfied:
1. The question MUST NOT exceed 30 words.
2. Each option MUST NOT exceed 10 words.
3. No markdown formatting (like bold, italics, or backticks) inside any JSON field or value.
4. The explanations (both correctExplanation and wrongExplanation) MUST consist of exactly 2 to 3 sentences.
5. The title and subtitle MUST NOT give away the answer (no spoilers). They should introduce the topic neutrally.
6. The question and topic MUST be unique and avoid repeating the topics, questions, or answers listed in the previous questions section.

Return the output in EXACTLY this JSON format with no additional text:
{
  "title": "Topic Title (Short)",
  "subtitle": "Short descriptive subtitle",
  "difficulty": "easy" | "medium" | "hard",
  "question": "The question text",
  "options": ["Option A", "Option B", "Option C", "Option D"],
  "correctIndex": 0,
  "correctExplanation": "Explanation of why the correct answer is right.",
  "wrongExplanation": "General explanation of common misconceptions related to this topic."
}
`;
}

/**
 * Calls OpenRouter to generate the quiz content using the specified model.
 * @param {string} prompt 
 * @returns {Promise<string>}
 */
async function callOpenRouter(prompt) {
  const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
  if (!OPENROUTER_API_KEY) {
    throw new Error('OPENROUTER_API_KEY environment variable is missing.');
  }

  const MODEL = process.env.OPENROUTER_MODEL || 'openrouter/free';
  console.log(`Sending prompt to OpenRouter using model: ${MODEL}...`);

  const response = await axios.post(
    'https://openrouter.ai/api/v1/chat/completions',
    {
      model: MODEL,
      messages: [
        {
          role: 'user',
          content: prompt
        }
      ]
    },
    {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENROUTER_API_KEY}`
      },
      timeout: 30000
    }
  );

  const choices = response.data && response.data.choices;
  if (!choices || choices.length === 0 || !choices[0].message) {
    throw new Error('Invalid or empty response structure from OpenRouter.');
  }

  return choices[0].message.content;
}

/**
 * Robustly extracts the first JSON object from a string and parses it.
 * @param {string} text 
 * @returns {object}
 */
function extractAndParseJSON(text) {
  if (!text) {
    throw new Error('Input text is empty.');
  }

  const firstBraceIndex = text.indexOf('{');
  if (firstBraceIndex === -1) {
    throw new Error('Could not find opening brace "{" of JSON object.');
  }

  let braceCount = 0;
  let inString = false;
  let escapeNext = false;
  let lastBraceIndex = -1;

  for (let i = firstBraceIndex; i < text.length; i++) {
    const char = text[i];

    if (escapeNext) {
      escapeNext = false;
      continue;
    }

    if (char === '\\') {
      escapeNext = true;
      continue;
    }

    if (char === '"') {
      inString = !inString;
      continue;
    }

    if (!inString) {
      if (char === '{') {
        braceCount++;
      } else if (char === '}') {
        braceCount--;
        if (braceCount === 0) {
          lastBraceIndex = i;
          break;
        }
      }
    }
  }

  if (lastBraceIndex === -1) {
    throw new Error('Could not find matching closing brace "}" for the JSON object.');
  }

  const jsonString = text.substring(firstBraceIndex, lastBraceIndex + 1);

  try {
    return JSON.parse(jsonString);
  } catch (parseError) {
    console.error('Failed to parse extracted JSON content. JSON string was:', jsonString);
    throw parseError;
  }
}

/**
 * Validates the generated quiz object against required schema constraints.
 * @param {object} quizData 
 */
function validateQuiz(quizData) {
  if (!quizData || typeof quizData !== 'object') {
    throw new Error('Quiz data is not a valid object.');
  }

  const requiredFields = [
    'title',
    'subtitle',
    'difficulty',
    'question',
    'options',
    'correctIndex',
    'correctExplanation',
    'wrongExplanation'
  ];

  for (const field of requiredFields) {
    if (quizData[field] === undefined || quizData[field] === null) {
      throw new Error(`Missing required field: "${field}"`);
    }
  }

  if (typeof quizData.title !== 'string' || quizData.title.trim() === '') {
    throw new Error('Field "title" must be a non-empty string.');
  }
  if (typeof quizData.subtitle !== 'string' || quizData.subtitle.trim() === '') {
    throw new Error('Field "subtitle" must be a non-empty string.');
  }
  if (typeof quizData.difficulty !== 'string' || quizData.difficulty.trim() === '') {
    throw new Error('Field "difficulty" must be a non-empty string.');
  }
  if (typeof quizData.question !== 'string' || quizData.question.trim() === '') {
    throw new Error('Field "question" must be a non-empty string.');
  }
  if (typeof quizData.correctExplanation !== 'string' || quizData.correctExplanation.trim() === '') {
    throw new Error('Field "correctExplanation" must be a non-empty string.');
  }
  if (typeof quizData.wrongExplanation !== 'string' || quizData.wrongExplanation.trim() === '') {
    throw new Error('Field "wrongExplanation" must be a non-empty string.');
  }

  if (!Array.isArray(quizData.options)) {
    throw new Error('Field "options" must be an array.');
  }
  if (quizData.options.length !== 4) {
    throw new Error(`Field "options" must contain exactly 4 items, but has ${quizData.options.length}.`);
  }
  for (let i = 0; i < 4; i++) {
    if (typeof quizData.options[i] !== 'string' || quizData.options[i].trim() === '') {
      throw new Error(`Option at index ${i} must be a non-empty string.`);
    }
  }

  const correctIndex = Number(quizData.correctIndex);
  if (!Number.isInteger(correctIndex) || correctIndex < 0 || correctIndex > 3) {
    throw new Error(`Field "correctIndex" must be an integer between 0 and 3 (got: ${quizData.correctIndex}).`);
  }

  quizData.correctIndex = correctIndex;
}

/**
 * Saves the daily quiz to Firestore.
 * @param {string} quizId 
 * @param {object} quizData 
 * @param {string} today 
 */
async function saveQuiz(quizId, quizData, today) {
  console.log(`Writing daily quiz to Firestore document: ${quizId}...`);
  await db.collection('daily_quizzes').doc(quizId).set({
    title: quizData.title,
    subtitle: quizData.subtitle,
    difficulty: quizData.difficulty,
    question: quizData.question,
    options: quizData.options,
    correctIndex: quizData.correctIndex,
    correctExplanation: quizData.correctExplanation,
    wrongExplanation: quizData.wrongExplanation,
    id: quizId,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    dateString: today,
    requiredLevel: 1
  });
  console.log(`Successfully saved daily quiz to document ${quizId}.`);
}

/**
 * Main coordinator function that executes the quiz generation workflow.
 */
async function generateDailyQuiz() {
  try {
    // Verify required API keys are configured in the environment
    const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
    if (!OPENROUTER_API_KEY) {
      console.error('Error: Missing OPENROUTER_API_KEY in environment variables.');
      process.exit(1);
    }

    const NEWS_API_KEY = process.env.NEWS_API_KEY;
    if (!NEWS_API_KEY) {
      console.error('Error: Missing NEWS_API_KEY in environment variables.');
      process.exit(1);
    }

    // 1. Fetch recent questions to prevent repetitions
    let pastQuestions = [];
    try {
      pastQuestions = await fetchRecentQuestions();
    } catch (error) {
      console.error('Error fetching recent questions from Firestore:', error.message);
      process.exit(1);
    }

    // 2. Fetch recent finance/business news from the last 7 days using NewsAPI
    let articles = [];
    try {
      articles = await fetchFinanceNews();
    } catch (error) {
      console.warn('Warning: Failed to fetch finance news from NewsAPI:', error.message);
    }

    // 3. Summarize news articles to compact bullet points
    let newsSummary = '';
    if (articles.length > 0) {
      newsSummary = summarizeNews(articles);
      if (!newsSummary) {
        console.warn('Warning: No unique news headlines remaining after filtering.');
      }
    } else {
      console.warn('Warning: Generating quiz without current news because no articles were fetched.');
    }

    // 4. Formulate instructions and context for OpenRouter
    const pastQuestionsText = pastQuestions.length > 0
      ? 'AVOID these previous topics, questions, and answers to ensure uniqueness:\n' +
        pastQuestions.map((q, i) => `${i + 1}. Topic: "${q.topic}" | Question: "${q.question}" | Answer: "${q.answer}"`).join('\n')
      : 'This is the first question, so you have full creative freedom!';

    const today = new Date().toLocaleDateString('en-CA', { timeZone: 'Asia/Kolkata' });
    const basePrompt = buildPrompt(today, newsSummary, pastQuestionsText);

    // 5. Retry loop for LLM completion call, extraction, parsing, and validation
    let finalQuizData = null;
    let currentPrompt = basePrompt;

    for (let attempt = 1; attempt <= 2; attempt++) {
      console.log(`LLM Generation Attempt ${attempt} of 2...`);
      try {
        const responseText = await callOpenRouter(currentPrompt);
        const parsedData = extractAndParseJSON(responseText);
        validateQuiz(parsedData);
        finalQuizData = parsedData;
        break;
      } catch (error) {
        console.error(`Attempt ${attempt} failed: ${error.message}`);
        if (attempt === 1) {
          console.log('Retrying with a corrective feedback prompt...');
          currentPrompt = `${basePrompt}\n\nIMPORTANT: The previous response was invalid and failed validation with error: "${error.message}". Return ONLY valid JSON matching the schema exactly. Do not include any surrounding explanations or markdown code blocks outside of the JSON object itself.`;
        } else {
          console.error('All validation and generation attempts failed.');
          process.exit(1);
        }
      }
    }

    // 6. Write the final validated quiz to Firestore
    if (finalQuizData) {
      const quizId = `daily_${today}`;
      await saveQuiz(quizId, finalQuizData, today);
      console.log(`Successfully generated and saved daily quiz for ${today}.`);
    } else {
      console.error('Unexpected error: finalQuizData is null despite successful loop completion.');
      process.exit(1);
    }

  } catch (error) {
    console.error('Fatal error in quiz generation workflow:', error.message);
    process.exit(1);
  }
}

// Execute the workflow
generateDailyQuiz();
