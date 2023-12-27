FROM node:21-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .

CMD [ "npm", "run", "start" ]

ENV PORT=3000
EXPOSE 3000
