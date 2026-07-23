const axios = require('axios');
const admin = require('firebase-admin');

if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
} else {
  admin.initializeApp();
}

const db = admin.firestore();

const FALLBACK_FINANCE_QUOTES = [
  { quote: "Rule No.1: Never lose money. Rule No.2: Never forget rule No.1.", author: "Warren Buffett" },
  { quote: "An investment in knowledge pays the best interest.", author: "Benjamin Franklin" },
  { quote: "Financial freedom is available to those who learn about it and work for it.", author: "Robert Kiyosaki" },
  { quote: "Do not save what is left after spending, but spend what is left after saving.", author: "Warren Buffett" },
  { quote: "It’s not how much money you make, but how much money you keep.", author: "Robert Kiyosaki" },
  { quote: "Money is a terrible master but an excellent servant.", author: "P.T. Barnum" },
  { quote: "The stock market is filled with individuals who know the price of everything, but the value of nothing.", author: "Philip Fisher" },
  { quote: "Beware of little expenses. A small leak will sink a great ship.", author: "Benjamin Franklin" },
  { quote: "Wealth consists not in having great possessions, but in having few wants.", author: "Epictetus" },
  { quote: "Formal education will make you a living; self-education will make you a fortune.", author: "Jim Rohn" },
  { quote: "The best way to measure your financial success is not by whether you're beating the market, but by whether you've put in place a financial plan.", author: "Benjamin Graham" },
  { quote: "Every time you borrow money, you're robbing your future self.", author: "Nathan W. Morris" },
  { quote: "A budget is telling your money where to go instead of wondering where it went.", author: "Dave Ramsey" },
  { quote: "Opportunity is missed by most people because it is dressed in overalls and looks like work.", author: "Thomas Edison" },
  { quote: "Wealth is the ability to fully experience life.", author: "Henry David Thoreau" },
  { quote: "Investing should be more like watching paint dry or watching grass grow. If you want excitement, take $800 and go to Las Vegas.", author: "Paul Samuelson" },
  { quote: "Compound interest is the eighth wonder of the world. He who understands it, earns it; he who doesn't, pays it.", author: "Albert Einstein" },
  { quote: "Money is only a tool. It will take you wherever you wish, but it will not replace you as the driver.", author: "Ayn Rand" },
  { quote: "Never depend on single income. Make investment to create a second source.", author: "Warren Buffett" },
  { quote: "Rich people have small TVs and big libraries, and poor people have small libraries and big TVs.", author: "Zig Ziglar" },
  { quote: "The goal isn't more money. The goal is living life on your terms.", author: "Chris Brogan" },
  { quote: "Buy when everyone else is selling and hold until everyone else is buying.", author: "J. Paul Getty" },
  { quote: "Financial peace isn't the acquisition of stuff. It's learning to live on less than you make.", author: "Dave Ramsey" },
  { quote: "Too many people spend money they haven't earned to buy things they don't want to impress people they don't like.", author: "Will Rogers" }
];

async function buildQuoteCache() {
  console.log('Building financial quote cache...');
  let quotes = [];

  try {
    const response = await axios.get('https://zenquotes.io/api/quotes', { timeout: 10000 });
    if (Array.isArray(response.data)) {
      const financeKeywords = ['money', 'wealth', 'rich', 'invest', 'business', 'work', 'success', 'value', 'price', 'economy', 'earn', 'spend', 'buy', 'gold', 'opportunity', 'fortune'];
      const fetchedQuotes = response.data.map(q => ({
        quote: q.q,
        author: q.a
      })).filter(q => {
        const text = (q.quote + ' ' + q.author).toLowerCase();
        return financeKeywords.some(kw => text.includes(kw));
      });
      quotes = fetchedQuotes;
    }
  } catch (err) {
    console.warn('ZenQuotes API fetch notice:', err.message);
  }

  // Merge with fallback quotes to guarantee a rich cache of finance quotes
  const quoteMap = new Map();
  FALLBACK_FINANCE_QUOTES.forEach(q => quoteMap.set(q.quote, q));
  quotes.forEach(q => quoteMap.set(q.quote, q));

  const finalQuotes = Array.from(quoteMap.values());
  console.log(`Saving ${finalQuotes.length} quotes to Firestore daily_quotes/cache...`);

  await db.collection('daily_quotes').doc('cache').set({
    quotes: finalQuotes,
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  });

  console.log('✅ Quote cache built and saved successfully!');
}

buildQuoteCache().then(() => process.exit(0)).catch(err => {
  console.error('❌ Error building quote cache:', err);
  process.exit(1);
});
