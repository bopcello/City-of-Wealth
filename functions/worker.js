const admin = require('firebase-admin');

if (!process.env.FIREBASE_KEY) throw new Error('FIREBASE_KEY is required');

admin.initializeApp({
  credential: admin.credential.cert(JSON.parse(process.env.FIREBASE_KEY)),
});

const db = admin.firestore();
const messaging = admin.messaging();
const publicCities = db.collection('public_cities');
const players = db.collection('players');
const friendships = db.collection('friendships');
const snapshots = new Map();
const channelId = 'friend_city_activity';

const templates = {
  level_up: [
    ['{name} leveled up!', '{name} reached {level}.'],
    ['A new level for {name}', '{name} is now {level}.'],
    ['{name} moved up', 'Level {level} is officially unlocked.'],
    ['Level-up alert', '{name} advanced to {level}.'],
    ['{name} is climbing', 'They just reached {level}.'],
  ],
  building_built: [
    ['{name} is expanding', '{name} built {buildings}.'],
    ['New construction in {name}\'s city', '{buildings} just joined the skyline.'],
    ['{name} built something new', '{buildings} is now part of the city.'],
    ['City growth alert', '{name} added {buildings}.'],
    ['{name} is building wealth', 'New build: {buildings}.'],
  ],
  building_destroyed: [
    ['A building fell in {name}\'s city', '{name} lost {buildings}.'],
    ['{name}\'s skyline changed', '{buildings} was destroyed.'],
    ['Setback for {name}', '{buildings} is gone from the city.'],
    ['Demolition alert', '{name} lost {buildings}.'],
    ['{name} is rebuilding', '{buildings} was removed from the city.'],
  ],
  kp_gained: [
    ['{name} gained KP', '+{kp} KP for {name}.'],
    ['Knowledge pays off', '{name} earned {kp} KP.'],
    ['KP boost for {name}', 'They are up {kp} KP.'],
    ['{name} is getting sharper', '+{kp} KP added to their total.'],
    ['More KP in the bank', '{name} gained {kp} KP.'],
  ],
  kp_lost: [
    ['{name} lost KP', '-{kp} KP from their total.'],
    ['KP setback for {name}', 'They are down {kp} KP.'],
    ['{name} took a knowledge hit', '{kp} KP was lost.'],
    ['A dip in KP', '{name} lost {kp} KP.'],
    ['{name} needs a comeback', '-{kp} KP recorded.'],
  ],
  streak_continued: [
    ['{name} kept the streak alive', 'Their streak is now {streak} days.'],
    ['Streak continued!', '{name} reached {streak} days.'],
    ['{name} stayed consistent', '{streak} days and counting.'],
    ['Another day, another streak', '{name} is at {streak} days.'],
    ['{name} is on a roll', 'Their streak grew to {streak} days.'],
  ],
  streak_lost: [
    ['{name}\'s streak reset', 'Their {previousStreak}-day streak is over.'],
    ['Streak lost for {name}', 'They dropped from {previousStreak} days to {streak}.'],
    ['Consistency slipped', '{name}\'s {previousStreak}-day streak was broken.'],
    ['{name} lost the streak', '{previousStreak} days reset to {streak}.'],
    ['A reset for {name}', 'Their streak fell from {previousStreak} to {streak}.'],
  ],
  bankruptcy: [
    ['{name} declared bankruptcy', 'Their city has reset to level 1.'],
    ['Fresh start for {name}', 'Bankruptcy reset their city to level 1.'],
    ['{name} is starting over', 'Their city has been reset to level 1.'],
    ['Bankruptcy declared', '{name} is back at level 1.'],
    ['A full reset for {name}', 'Their city returned to level 1.'],
  ],
};

const toNumber = (value) => (typeof value === 'number' ? value : Number(value) || 0);

function buildingCounts(city) {
  const counts = new Map();
  for (const building of Array.isArray(city.buildings) ? city.buildings : []) {
    const name = building?.name || building?.type;
    if (name) counts.set(name, (counts.get(name) || 0) + 1);
  }
  return counts;
}

function buildingChanges(before, after) {
  const previous = buildingCounts(before);
  const current = buildingCounts(after);
  const added = [];
  const removed = [];
  for (const [name, count] of current) {
    const difference = count - (previous.get(name) || 0);
    if (difference > 0) added.push(...Array(difference).fill(name));
  }
  for (const [name, count] of previous) {
    const difference = count - (current.get(name) || 0);
    if (difference > 0) removed.push(...Array(difference).fill(name));
  }
  return { added, removed };
}

function changesFor(before, after) {
  const changes = [];
  const previousLevel = toNumber(before.level);
  const level = toNumber(after.level);
  const previousStreak = toNumber(before.streak);
  const streak = toNumber(after.streak);
  const kpChange = toNumber(after.kp) - toNumber(before.kp);
  const { added, removed } = buildingChanges(before, after);
  const bankruptcy = toNumber(after.bankruptcyCount) > toNumber(before.bankruptcyCount) ||
    (previousLevel > 1 && level === 1);

  if (bankruptcy) changes.push({ type: 'bankruptcy', level: 1 });
  else if (level > previousLevel) changes.push({ type: 'level_up', level: after.title || `level ${level}` });
  if (added.length) changes.push({ type: 'building_built', buildings: added });
  if (removed.length) changes.push({ type: 'building_destroyed', buildings: removed });
  if (kpChange > 0) changes.push({ type: 'kp_gained', kp: kpChange });
  if (kpChange < 0) changes.push({ type: 'kp_lost', kp: Math.abs(kpChange) });
  if (streak > previousStreak) changes.push({ type: 'streak_continued', streak });
  if (streak < previousStreak) changes.push({ type: 'streak_lost', streak, previousStreak });
  return changes;
}

function activityPayload(change) {
  const payload = { events: [change.type] };
  if (change.level) payload.newLevel = change.level;
  if (change.buildings) {
    if (change.type === 'building_built') payload.newBuildings = change.buildings;
    else payload.destroyedBuildings = change.buildings;
  }
  if (change.kp) payload.kpChange = change.type === 'kp_lost' ? -change.kp : change.kp;
  if (change.streak !== undefined) payload.streak = change.streak;
  if (change.previousStreak !== undefined) payload.previousStreak = change.previousStreak;
  return payload;
}

function notificationFor(name, change) {
  const [titleTemplate, bodyTemplate] = templates[change.type][Math.floor(Math.random() * 5)];
  const values = {
    name,
    level: String(change.level || 'a new level'),
    buildings: change.buildings?.length === 1 ? change.buildings[0] : `${change.buildings?.length || 0} buildings`,
    kp: String(change.kp || 0),
    streak: String(change.streak ?? 0),
    previousStreak: String(change.previousStreak ?? 0),
  };
  const format = (template) => template.replace(/\{(\w+)\}/g, (_, key) => values[key] || '');
  return { title: format(titleTemplate), body: format(bodyTemplate) };
}

async function friendsOf(playerId) {
  const [asPlayerA, asPlayerB] = await Promise.all([
    friendships.where('playerA', '==', playerId).where('status', '==', 'accepted').get(),
    friendships.where('playerB', '==', playerId).where('status', '==', 'accepted').get(),
  ]);
  return [...asPlayerA.docs, ...asPlayerB.docs].map((doc) => {
    const friendship = doc.data();
    const id = friendship.playerA === playerId ? friendship.playerB : friendship.playerA;
    return { id, muted: Array.isArray(friendship.mutedBy) && friendship.mutedBy.includes(id) };
  });
}

async function recordActivity(playerId, name, recipientIds, change) {
  const payload = activityPayload(change);
  for (let index = 0; index < recipientIds.length; index += 500) {
    const batch = db.batch();
    for (const recipientId of recipientIds.slice(index, index + 500)) {
      batch.set(players.doc(recipientId).collection('activity_feed').doc(), {
        sourcePlayerId: playerId,
        sourcePlayerName: name,
        targetPlayerId: recipientId,
        type: 'session_summary',
        payload,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        seen: false,
      });
    }
    await batch.commit();
  }
  return payload;
}

async function sendPushes(playerId, name, payload, recipients, change) {
  const notification = notificationFor(name, change);
  const message = {
    notification,
    data: {
      kind: 'friend_activity',
      friendPlayerId: playerId,
      friendName: name,
      eventType: change.type,
      activityPayload: JSON.stringify(payload),
    },
    android: { priority: 'high', notification: { channelId } },
    apns: { payload: { aps: { sound: 'default' } } },
  };
  for (let index = 0; index < recipients.length; index += 500) {
    const recipientsBatch = recipients.slice(index, index + 500);
    const result = await messaging.sendEachForMulticast({
      ...message,
      tokens: recipientsBatch.map((recipient) => recipient.fcmToken),
    });
    result.responses.forEach((response, responseIndex) => {
      if (!response.success) console.error(`Push failed for ${recipientsBatch[responseIndex].id}:`, response.error);
    });
  }
}

async function notifyFriends(playerId, city, changes) {
  const friends = await friendsOf(playerId);
  if (!friends.length) return;

  const playerDocs = await db.getAll(...friends.map((friend) => players.doc(friend.id)));
  const playerData = new Map(playerDocs.filter((doc) => doc.exists).map((doc) => [doc.id, doc.data()]));
  const name = city.playerName || 'A friend';
  const recipientIds = friends.map((friend) => friend.id);
  const pushRecipients = friends
    .filter((friend) => !friend.muted)
    .map((friend) => ({ id: friend.id, ...playerData.get(friend.id) }))
    .filter((friend) => friend.friendActivityNotificationsEnabled !== false && friend.fcmToken);

  for (const change of changes) {
    const payload = await recordActivity(playerId, name, recipientIds, change);
    if (pushRecipients.length) await sendPushes(playerId, name, payload, pushRecipients, change);
  }
}

async function handleChange(change) {
  const playerId = change.doc.id;
  const city = change.doc.data();
  if (change.type === 'added') snapshots.set(playerId, city);
  else if (change.type === 'removed') snapshots.delete(playerId);
  else {
    const previous = snapshots.get(playerId);
    snapshots.set(playerId, city);
    if (!previous) return;
    const changes = changesFor(previous, city);
    if (changes.length) await notifyFriends(playerId, city, changes);
  }
}

let queue = Promise.resolve();
console.log('Starting public_cities listener.');
publicCities.onSnapshot(
  (snapshot) => {
    queue = queue
      .then(() => snapshot.docChanges().reduce(
        (current, change) => current.then(() => handleChange(change)),
        Promise.resolve(),
      ))
      .catch((error) => console.error('Unable to process public city changes:', error));
  },
  (error) => console.error('Public city listener failed:', error),
);
