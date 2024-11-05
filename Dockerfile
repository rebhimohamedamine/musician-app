# Use official Node.js image
FROM node:18-alpine as builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install --production --verbose

# Copy app source and install
COPY . .

# Expose the app on port 3000
EXPOSE 3000

CMD ["npm", "start"]

