const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');

if (!process.env.FIREBASE_KEY) throw new Error('FIREBASE_KEY is required');

function loadTemplates() {
  const sourcePath = path.resolve(__dirname, '../lib/data/notification_data.dart');
  const source = fs.readFileSync(sourcePath, 'utf8');
  const match = source.match(/friendActivityNotificationTemplatesJson\s*=\s*r'''([\s\S]*?)''';/);
  if (!match) throw new Error('Friend activity notification templates were not found.');
  return JSON.parse(match[1]);
}

admin.initializeApp({ credential: admin.credential.cert(JSON.parse(process.env.FIREBASE_KEY)) });

const db = admin.firestore();
const messaging = admin.messaging();
const publicCities = db.collection('public_cities');
const players = db.collection('players');
const friendships = db.collection('friendships');
const templates = loadTemplates();
const snapshots = new Map();
const channelId = 'friend_city_activity';
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
  const options = templates[change.type];
  const [titleTemplate, bodyTemplate] = options[Math.floor(Math.random() * options.length)];
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
