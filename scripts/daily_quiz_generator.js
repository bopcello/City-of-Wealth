const axios = require('axios');
const admin = require('firebase-admin');

// ---------------------------------------------------------------------------
// Firebase setup
// ---------------------------------------------------------------------------

if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
} else {
  admin.initializeApp();
}

const db = admin.firestore();

// ---------------------------------------------------------------------------
// Model cascade configuration
//
// Attempts are made in order down this list. Each entry gets its own fresh
// prompt (reset from the base prompt) on its first attempt; if a model fails
// validation, the error is fed back into the prompt for its next attempt.
// After the whole cascade is exhausted, generation falls back to
// `openrouter/free` for up to FINAL_FALLBACK_MAX_ATTEMPTS tries. If that
// also fails, generateQuizWithRetries throws and the workflow exits.
// ---------------------------------------------------------------------------

const MODEL_CASCADE = [
  { model: 'nvidia/nemotron-3-ultra-550b-a55b:free', attempts: 2 },
  { model: 'gpt-oss-120b:free', attempts: 2 },
  { model: 'nvidia/nemotron-3-super-120b-a12b:free', attempts: 2 },
  { model: 'google/gemma-4-31b-it:free', attempts: 2 }
];

const FINAL_FALLBACK_MODEL = 'openrouter/free';
const FINAL_FALLBACK_MAX_ATTEMPTS = 10;

// ---------------------------------------------------------------------------
// Firestore helpers
// ---------------------------------------------------------------------------

/**
 * Fetches the last 10 daily quizzes from Firestore to avoid repeated topics or questions.
 * @returns {Promise<Array<{topic: string, question: string, answer: string}>>}
 */
async function fetchRecentQuestions() {
  console.log('Fetching the last 10 daily quizzes from Firestore...');

  const pastQuizzesSnapshot = await db.collection('daily_quizzes')
    .orderBy('timestamp', 'desc')
    .limit(10)
    .get();

  const pastQuestions = [];
  pastQuizzesSnapshot.forEach(doc => {
    const data = doc.data();
    if (!data.question) return;

    const correctAnswer = data.options && data.options[data.correctIndex] !== undefined
      ? data.options[data.correctIndex]
      : 'Unknown';

    pastQuestions.push({
      topic: data.title || 'Unknown',
      question: data.question,
      answer: correctAnswer
    });
  });

  console.log(`Successfully fetched ${pastQuestions.length} recent questions.`);
  return pastQuestions;
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

// ---------------------------------------------------------------------------
// News fetching / summarizing
// ---------------------------------------------------------------------------

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

  const query = `
    (
      earnings OR IPO OR merger OR acquisition OR
      "Federal Reserve" OR ECB OR RBI OR
      inflation OR recession OR
      Bitcoin OR Ethereum OR
      Nasdaq OR "S&P 500"
    )
    NOT sports
    NOT football
    NOT cricket
    NOT Taylor
    NOT wedding
    NOT entertainment
  `;

  const domains = 'reuters.com,bloomberg.com,cnbc.com,ft.com,wsj.com,apnews.com,bbc.com,fortune.com,businessinsider.com,finance.yahoo.com,marketwatch.com';

  console.log(`Fetching finance/business news since ${fromDate} from NewsAPI...`);

  const response = await axios.get('https://newsapi.org/v2/everything', {
    params: {
      qInTitle: query,
      domains,
      from: fromDate,
      sortBy: 'publishedAt',
      pageSize: 15,
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
 * Normalizes and converts news articles into a clean summary of up to 10 unique headlines.
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

    if (uniqueHeadlines.has(normalized)) continue;

    uniqueHeadlines.add(normalized);
    bulletPoints.push(`• ${trimmedTitle}`);

    if (bulletPoints.length >= 10) break;
  }

  if (bulletPoints.length === 0) {
    return '';
  }

  return `Recent finance news:\n\n${bulletPoints.join('\n')}`;
}

// ---------------------------------------------------------------------------
// Prompt building
// ---------------------------------------------------------------------------

/**
 * Builds the base prompt message sent to the LLM.
 * @param {string} today
 * @param {string} newsSummary
 * @param {string} pastQuestionsText
 * @returns {string}
 */
function buildPrompt(today, newsSummary, pastQuestionsText) {
  const newsInstruction = newsSummary
    ? 'Use the provided recent news summary from the last 7 days to generate ONE current finance quiz question. If the news summary is empty, irrelevant, or not provided, fallback to generating a timeless finance question instead.'
    : 'Generate a timeless finance question instead.';

  return `Generate ONE finance quiz document.

STRICT INSTRUCTIONS:
1. Output MUST be in EXACTLY this JSON format (no surrounding text or markdown blocks, no bold/italics/backticks in values):
{
  "title": "Topic Title (Short, no spoilers)",
  "subtitle": "Short descriptive subtitle",
  "difficulty": "easy" | "medium" | "hard",
  "question": "The question text (MUST NOT exceed 30 words)",
  "options": ["Option A", "Option B", "Option C", "Option D"], // Exactly 4 options, each MUST NOT exceed 10 words
  "correctIndex": 0, // Integer between 0 and 3
  "correctExplanation": "Thorough explanation of why correct (exactly 2-3 sentences)",
  "wrongExplanation": "General explanation of common misconceptions (exactly 2-3 sentences)"
}
2. ${newsInstruction}
3. The question and topic MUST be unique. AVOID repeating the topics, questions, or answers listed in the previous questions section.
4. The question must not be longer than 30 words and the options must not be longer than 10 words each. Do not use any markdown formatting like bold or italics. Give the output in plain text only. Ensure the explanations are thorough (at least 2-3 sentences).
5. IMPORTANT: Do not set the title or the subtitle such that they give the answer for free. They should indicate the topic without spoiling the correct option.

CONTEXT:
- Today's Date: ${today}
- ${newsSummary ? `${newsSummary}` : 'No recent news available.'}
- ${pastQuestionsText}
`;
}

/**
 * Appends a correction notice to the base prompt after a failed attempt.
 * @param {string} basePrompt
 * @param {Error} error
 * @returns {string}
 */
function buildRetryPrompt(basePrompt, error) {
  return `${basePrompt}\n\nIMPORTANT: The previous response was invalid and failed validation with error: "${error.message}". Return ONLY valid JSON matching the schema exactly. Do not include any surrounding explanations or markdown code blocks outside of the JSON object itself.`;
}

// ---------------------------------------------------------------------------
// OpenRouter call + JSON extraction/validation
// ---------------------------------------------------------------------------

/**
 * Calls OpenRouter to generate the quiz content using the specified model.
 * @param {string} prompt
 * @param {string} model
 * @returns {Promise<string>}
 */
async function callOpenRouter(prompt, model) {
  const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
  if (!OPENROUTER_API_KEY) {
    throw new Error('OPENROUTER_API_KEY environment variable is missing.');
  }

  console.log(`Sending prompt to OpenRouter using model: ${model}...`);

  const response = await axios.post(
    'https://openrouter.ai/api/v1/chat/completions',
    {
      model,
      messages: [{ role: 'user', content: prompt }]
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

  const requiredStringFields = ['title', 'subtitle', 'difficulty', 'question', 'correctExplanation', 'wrongExplanation'];
  for (const field of requiredStringFields) {
    if (typeof quizData[field] !== 'string' || quizData[field].trim() === '') {
      throw new Error(`Field "${field}" must be a non-empty string.`);
    }
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
 * Makes a single generation attempt: calls the model, extracts JSON, and validates it.
 * @param {string} prompt
 * @param {string} model
 * @returns {Promise<object>}
 */
async function attemptGeneration(prompt, model) {
  const responseText = await callOpenRouter(prompt, model);
  console.log('--- Raw Response from LLM ---');
  console.log(responseText);
  console.log('-----------------------------');

  const parsedData = extractAndParseJSON(responseText);
  validateQuiz(parsedData);
  return parsedData;
}

// ---------------------------------------------------------------------------
// Retry orchestration across the model cascade
// ---------------------------------------------------------------------------

/**
 * Walks through MODEL_CASCADE in order, then retries FINAL_FALLBACK_MODEL
 * indefinitely until a valid quiz is generated.
 * @param {string} basePrompt
 * @returns {Promise<object>}
 */
async function generateQuizWithRetries(basePrompt) {
  // Fixed cascade: a limited number of attempts per named model.
  for (const { model, attempts } of MODEL_CASCADE) {
    let currentPrompt = basePrompt;

    for (let attempt = 1; attempt <= attempts; attempt++) {
      console.log(`LLM Generation: ${model} (attempt ${attempt}/${attempts})...`);

      try {
        return await attemptGeneration(currentPrompt, model);
      } catch (error) {
        console.error(`${model} attempt ${attempt} failed: ${error.message}`);
        currentPrompt = buildRetryPrompt(basePrompt, error);
      }
    }
  }

  // Final fallback: retry openrouter/free up to FINAL_FALLBACK_MAX_ATTEMPTS times.
  console.warn(`All cascade models failed. Falling back to "${FINAL_FALLBACK_MODEL}" for up to ${FINAL_FALLBACK_MAX_ATTEMPTS} attempts.`);

  let currentPrompt = basePrompt;
  let lastError = null;

  for (let attempt = 1; attempt <= FINAL_FALLBACK_MAX_ATTEMPTS; attempt++) {
    console.log(`LLM Generation: ${FINAL_FALLBACK_MODEL} (fallback attempt ${attempt}/${FINAL_FALLBACK_MAX_ATTEMPTS})...`);

    try {
      return await attemptGeneration(currentPrompt, FINAL_FALLBACK_MODEL);
    } catch (error) {
      lastError = error;
      console.error(`${FINAL_FALLBACK_MODEL} fallback attempt ${attempt} failed: ${error.message}`);
      currentPrompt = buildRetryPrompt(basePrompt, error);
    }
  }

  throw new Error(`All generation attempts (including ${FINAL_FALLBACK_MAX_ATTEMPTS} "${FINAL_FALLBACK_MODEL}" fallback attempts) failed. Last error: ${lastError.message}`);
}

// ---------------------------------------------------------------------------
// Main workflow
// ---------------------------------------------------------------------------

/**
 * Main coordinator function that executes the quiz generation workflow.
 */
async function generateDailyQuiz() {
  try {
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

    // 2. Fetch recent finance/business news from the last 7 days
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
      } else {
        console.log('--- News Summary Generated from NewsAPI ---');
        console.log(newsSummary);
        console.log('-------------------------------------------');
      }
    } else {
      console.warn('Warning: Generating quiz without current news because no articles were fetched.');
    }

    // 4. Build the base prompt
    const pastQuestionsText = pastQuestions.length > 0
      ? 'AVOID these previous topics, questions, and answers to ensure uniqueness:\n' +
        pastQuestions.map((q, i) => `${i + 1}. Topic: "${q.topic}" | Question: "${q.question}" | Answer: "${q.answer}"`).join('\n')
      : 'This is the first question, so you have full creative freedom!';

    const today = new Date().toLocaleDateString('en-CA', { timeZone: 'Asia/Kolkata' });
    const basePrompt = buildPrompt(today, newsSummary, pastQuestionsText);

    console.log('--- Full Base Prompt Sent to LLM ---');
    console.log(basePrompt);
    console.log('-------------------------------------');

    // 5. Run the model cascade (with infinite final fallback) until success
    const finalQuizData = await generateQuizWithRetries(basePrompt);

    // 6. Write the final validated quiz to Firestore
    const quizId = `daily_${today}`;
    await saveQuiz(quizId, finalQuizData, today);
    console.log(`Successfully generated and saved daily quiz for ${today}.`);

  } catch (error) {
    console.error('Fatal error in quiz generation workflow:', error.message);
    process.exit(1);
  }
}

// Execute the workflow
generateDailyQuiz();
