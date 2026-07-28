FROM node:20-slim

WORKDIR /app

COPY functions/package.json ./functions/package.json
RUN npm --prefix functions install --omit=dev

COPY functions ./functions
COPY lib/data/notification_data.dart ./lib/data/notification_data.dart

CMD ["npm", "--prefix", "functions", "start"]
