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

async function generateDailyQuiz() {
  const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
  if (!GEMINI_API_KEY) {
    console.error('Missing GEMINI_API_KEY');
    process.exit(1);
  }

  // 1. Fetch recent questions to avoid repetition
  const pastQuizzesSnapshot = await db.collection('daily_quizzes')
    .orderBy('timestamp', 'desc')
    .limit(30)
    .get();

  let pastQuestions = [];
  pastQuizzesSnapshot.forEach(doc => {
    const data = doc.data();
    if (data.question) {
      const correctAnswer = data.options && data.options[data.correctIndex] ? data.options[data.correctIndex] : "Unknown";
      pastQuestions.push({
        topic: data.title,
        question: data.question,
        answer: correctAnswer
      });
    }
  });

  console.log(`Fetched ${pastQuestions.length} recent questions.`);

  // 2. Prepare Prompt
  const pastQuestionsText = pastQuestions.length > 0
    ? `AVOID these previous topics, questions, and answers to ensure uniqueness:\n` + pastQuestions.map((q, i) => `${i + 1}. Topic: "${q.topic}" | Question: "${q.question}" | Answer: "${q.answer}"`).join('\n')
    : "This is the first question, so you have full creative freedom!";

  const today = new Date().toLocaleDateString('en-CA', { timeZone: 'Asia/Kolkata' });

  const prompt = `
Today's date is ${today}.

You have access to Google Search. Before generating the quiz question, search the web for the latest financial news and current affairs from the past 7 days. Look for: recent central bank decisions, stock market movements, major corporate earnings, economic policy changes, cryptocurrency news, or any significant global financial events.

Use what you find to generate ONE unique, timely financial quiz question that an average person can answer. The question should be grounded in a real current event or recent development in finance.

The question must not be longer than 30 words and the options must not be longer than 10 words each.
Do not use any markdown formatting like bold or italics. Give the output in plain text only.

${pastQuestionsText}

IMPORTANT: Do not set the title or the subtitle such that they give the answer for free. They should indicate the topic without spoiling the correct option.

Return the output in EXACTLY this JSON format:
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

Ensure the explanations are thorough (at least 2-3 sentences).
`;

  // 3. Call Gemini Flash with Google Search grounding
  try {
    const response = await axios.post(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}`,
      {
        contents: [
          {
            role: 'user',
            parts: [{ text: prompt }]
          }
        ],
        tools: [
          {
            googleSearch: {}
          }
        ]
      },
      {
        headers: {
          'Content-Type': 'application/json'
        }
      }
    );

    const candidates = response.data.candidates;
    if (!candidates || candidates.length === 0) {
      throw new Error('No candidates returned from Gemini');
    }

    // Gemini with search grounding may return multiple parts — find the text one
    const parts = candidates[0].content.parts;
    const textPart = parts.find(p => p.text);
    if (!textPart) {
      throw new Error('No text part found in Gemini response');
    }

    const content = textPart.text;
    console.log('Raw Gemini Response:', content);

    // Extract JSON from potential markdown code block
    const jsonMatch = content.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      console.error('Full response text:', content);
      throw new Error('No JSON found in response');
    }

    console.log('Extracted JSON string:', jsonMatch[0]);
    const quizData = JSON.parse(jsonMatch[0]);
    console.log('Successfully parsed quiz data for topic:', quizData.title);

    // 4. Save to Firestore
    const quizId = `daily_${today}`;

    await db.collection('daily_quizzes').doc(quizId).set({
      ...quizData,
      id: quizId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      dateString: today,
      requiredLevel: 1
    });

    console.log(`Saved quiz for ${today}`);

  } catch (error) {
    console.error('Error in quiz generation:', error.response ? JSON.stringify(error.response.data, null, 2) : error.message);
    process.exit(1);
  }
}

generateDailyQuiz();
