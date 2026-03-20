const admin = require("firebase-admin");
const axios = require("axios");

const serviceAccount = JSON.parse(
  process.env.FIREBASE_SERVICE_ACCOUNT
);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function run() {
  const today = new Date().toISOString().split("T")[0];

  // Prevent overwrite if already exists
  const existing = await db.collection("finance_daily_questions").doc(today).get();
  if (existing.exists) {
    console.log("Question already exists for today.");
    return;
  }

  // Get last 30 questions
  const snapshot = await db
    .collection("finance_daily_questions")
    .orderBy("createdAt", "desc")
    .limit(30)
    .get();

  const pastQuestions = snapshot.docs.map(d => d.data().question).join("\n");

  const prompt = `
You are an expert financial examiner.

Generate ONE challenging multiple-choice question on deep and obscure topics in finance which can be related with recent affairs in finance.

STRICT RULES:

1) The question must be conceptually deep and non-trivial.
2) Avoid repeating or rephrasing any of the following previous questions:
${pastQuestions}
3) Return ONLY valid JSON.
4) Do NOT include markdown.
5) Do NOT include backticks.
6) Do NOT include commentary.
7) Output must be pure JSON only.
8) Ensure options are plausible and intellectually competitive.

Required JSON format:

{
  "question": "string",
  "options": [
    "A. ...",
    "B. ...",
    "C. ...",
    "D. ..."
  ],
  "correctIndex": "A",
  "correctExplanation": "Clear explanation of why the correct answer is correct.",
  "wrongExplanation": "Clear explanation of why the other options are incorrect."
}
`;

  const response = await axios.post(
    `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${process.env.GEMINI_API_KEY}`,
    {
      contents: [{
        parts: [{ text: prompt }]
      }],
      generationConfig: {
        temperature: 0.7
      }
    }
  );

  const rawText =
    response.data.candidates[0].content.parts[0].text.trim();

  let parsed;

  try {
    parsed = JSON.parse(rawText);
  } catch (e) {
    console.error("Model did not return valid JSON.");
    console.log(rawText);
    return;
  }

  await db.collection("finance_daily_questions").doc(today).set({
    ...parsed,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  });

  // Keep only last 30
  const allDocs = await db
    .collection("finance_daily_questions")
    .orderBy("createdAt", "desc")
    .get();

  if (allDocs.size > 30) {
    const batch = db.batch();
    allDocs.docs.slice(30).forEach(doc => batch.delete(doc.ref));
    await batch.commit();
  }

  console.log("Finance question generated successfully.");
}

run();
