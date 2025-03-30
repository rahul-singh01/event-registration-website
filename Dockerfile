# Dockerfile for package.json
# Stage 1: Build the React application
FROM node:18-alpine AS builder
WORKDIR /app
# Copy package files first to leverage Docker cache
COPY package*.json ./
# Install all dependencies including devDependencies
RUN npm ci
# Copy source files
COPY . .
# Build the React application with production settings
RUN npm run build

# Stage 2: Production environment
FROM node:18-alpine
WORKDIR /app
# Copy package files again for production dependencies
COPY package*.json ./
# Install production dependencies only
RUN npm ci --omit=dev
# Copy built assets from builder stage
COPY --from=builder /app/build ./build
# Copy server files
COPY server.js .
COPY config ./config
COPY controller ./controller
COPY routes ./routes

# Expose the port the app runs on
EXPOSE 3000
# Start the Node.js server
CMD ["node", "server.js"]