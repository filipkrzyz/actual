# Use official Node.js runtime as base image
FROM node:18-bullseye

# Set working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y openssl

# Enable Corepack and set the correct Yarn version
RUN corepack enable && corepack prepare yarn@4.3.1 --activate

# Verify Yarn version (useful for debugging)
RUN yarn --version

# Copy package.json and yarn.lock first for dependency installation
COPY package.json yarn.lock ./

# Set the correct Yarn version explicitly
RUN yarn set version stable

# Install dependencies properly
RUN yarn install --immutable --check-cache || yarn install --immutable

# Copy all project files after installing dependencies
COPY . .

# Build the Actual Budget server
RUN yarn workspace @actual-app/server build

# Expose port 5006 for the Actual Budget web app
EXPOSE 5006

# Start the Actual Budget server
CMD ["yarn", "workspace", "@actual-app/server", "start"]
