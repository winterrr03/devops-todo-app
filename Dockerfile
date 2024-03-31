FROM node:20.11-alpine
WORKDIR app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run test
EXPOSE 8000
CMD ["node", "app.js"]