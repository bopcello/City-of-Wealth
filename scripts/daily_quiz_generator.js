const axios = require('axios');
const admin = require('firebase-admin');
const crypto = require('crypto');

// Initialize Firebase
if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
} else {
  // Local development fallback
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

  const prompt = `
Generate ONE unique financial quiz question which can be answered by the average person.
The question should be related to current affairs or general knowledge in the finance world.
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

  // 3. Call Gemini AI
  try {
    const response = await axios.post(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${GEMINI_API_KEY}`,
      {
        contents: [{ parts: [{ text: prompt }] }]
      }
    );

    const content = response.data.candidates[0].content.parts[0].text;
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

    // 4. Save to Firestore (using IST date to match daily cron)
    const today = new Date().toLocaleDateString('en-CA', { timeZone: 'Asia/Kolkata' }); // YYYY-MM-DD
    const quizId = `daily_${today}`;

    await db.collection('daily_quizzes').doc(quizId).set({
      ...quizData,
      id: quizId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      dateString: today,
      requiredLevel: 1 // Daily quizzes available to everyone
    });

    console.log(`Saved quiz for ${today}`);

  } catch (error) {
    console.error('Error in quiz generation:', error.response ? JSON.stringify(error.response.data, null, 2) : error.message);
    process.exit(1);
  }
}

generateDailyQuiz();
