# Dockerfile for a React application with Node.js backend
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React application
RUN npm run build

# Use a smaller image for the production environment
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/build ./build
COPY --from=builder /app/server.js ./
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./

# Install production dependencies
RUN npm install --production

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]