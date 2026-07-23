import 'dart:math';

const List<Map<String, String>> localFinancialQuotes = [
  {
    "quote": "Rule No.1: Never lose money. Rule No.2: Never forget rule No.1.",
    "author": "Warren Buffett",
  },
  {
    "quote": "An investment in knowledge pays the best interest.",
    "author": "Benjamin Franklin",
  },
  {
    "quote": "Financial freedom is available to those who learn about it and work for it.",
    "author": "Robert Kiyosaki",
  },
  {
    "quote": "Do not save what is left after spending, but spend what is left after saving.",
    "author": "Warren Buffett",
  },
  {
    "quote": "It's not how much money you make, but how much money you keep.",
    "author": "Robert Kiyosaki",
  },
  {
    "quote": "Money is a terrible master but an excellent servant.",
    "author": "P.T. Barnum",
  },
  {
    "quote": "The stock market is filled with individuals who know the price of everything, but the value of nothing.",
    "author": "Philip Fisher",
  },
  {
    "quote": "Beware of little expenses. A small leak will sink a great ship.",
    "author": "Benjamin Franklin",
  },
  {
    "quote": "Wealth consists not in having great possessions, but in having few wants.",
    "author": "Epictetus",
  },
  {
    "quote": "Formal education will make you a living; self-education will make you a fortune.",
    "author": "Jim Rohn",
  },
  {
    "quote": "Every time you borrow money, you're robbing your future self.",
    "author": "Nathan W. Morris",
  },
  {
    "quote": "A budget is telling your money where to go instead of wondering where it went.",
    "author": "Dave Ramsey",
  },
  {
    "quote": "Wealth is the ability to fully experience life.",
    "author": "Henry David Thoreau",
  },
  {
    "quote": "Investing should be more like watching paint dry or watching grass grow.",
    "author": "Paul Samuelson",
  },
  {
    "quote": "Compound interest is the eighth wonder of the world. He who understands it, earns it; he who doesn't, pays it.",
    "author": "Albert Einstein",
  },
  {
    "quote": "Money is only a tool. It will take you wherever you wish, but it will not replace you as the driver.",
    "author": "Ayn Rand",
  },
  {
    "quote": "Never depend on single income. Make investment to create a second source.",
    "author": "Warren Buffett",
  },
  {
    "quote": "Rich people have small TVs and big libraries, and poor people have small libraries and big TVs.",
    "author": "Zig Ziglar",
  },
  {
    "quote": "Buy when everyone else is selling and hold until everyone else is buying.",
    "author": "J. Paul Getty",
  },
  {
    "quote": "Financial peace isn't the acquisition of stuff. It's learning to live on less than you make.",
    "author": "Dave Ramsey",
  },
];

Map<String, String> getRandomLocalQuote() {
  final random = Random();
  return localFinancialQuotes[random.nextInt(localFinancialQuotes.length)];
}
