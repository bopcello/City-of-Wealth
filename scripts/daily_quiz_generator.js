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

  // 1. Fetch recent hashes to avoid repetition
  const metadataDoc = await db.collection('daily_quizzes_metadata').doc('recent_hashes').get();
  let recentHashes = [];
  if (metadataDoc.exists) {
    recentHashes = metadataDoc.data().hashes || [];
  }

  console.log(`Fetched ${recentHashes.length} recent hashes.`);

  // 2. Prepare Prompt
  const hashConstraint = recentHashes.length > 0 
    ? `AVOID topics related to these hashes to ensure uniqueness: ${recentHashes.join(', ')}` 
    : "This is the first question, so you have full creative freedom!";

  const prompt = `
Generate ONE unique financial quiz question which is very difficult to answer for the average person.
The question should be related to current affairs or general knowledge in the finance world.

${hashConstraint}

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
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}`,
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

    // 4. Generate Hash (Topic-based to avoid repetition)
    // We hash the lowercase title to use as a deduplication key.
    const topicHash = crypto.createHash('md5').update(quizData.title.toLowerCase()).digest('hex').substring(0, 15);
    
    // 5. Save to Firestore (using IST date to match daily cron)
    const today = new Date().toLocaleDateString('en-CA', { timeZone: 'Asia/Kolkata' }); // YYYY-MM-DD
    const quizId = `daily_${today}`;

    await db.collection('daily_quizzes').doc(quizId).set({
      ...quizData,
      id: quizId,
      hash: topicHash,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      dateString: today,
      requiredLevel: 1 // Daily quizzes available to everyone
    });

    console.log(`Saved quiz for ${today} with hash ${topicHash}`);

    // 6. Update Metadata
    recentHashes.unshift(topicHash);
    if (recentHashes.length > 30) recentHashes.pop();

    await db.collection('daily_quizzes_metadata').doc('recent_hashes').set({
      hashes: recentHashes,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log('Updated recent hashes metadata.');

  } catch (error) {
    console.error('Error in quiz generation:', error.response ? JSON.stringify(error.response.data, null, 2) : error.message);
    process.exit(1);
  }
}

generateDailyQuiz();
