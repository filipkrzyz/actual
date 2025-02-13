# Use official Node.js runtime as base image
FROM node:18-bullseye

# Set working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y openssl

# Copy package.json and yarn.lock first for dependency installation
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy all project files
COPY . .

# Build the Actual Budget server
RUN yarn workspace @actual-app/server build

# Expose port 5006 for the Actual Budget web app
EXPOSE 5006

# Start the Actual Budget server
CMD ["yarn", "workspace", "@actual-app/server", "start"]
