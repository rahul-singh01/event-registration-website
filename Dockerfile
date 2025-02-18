# Dockerfile for package.json
# This Dockerfile uses multi-stage builds to optimize the image size

# Stage 1: Build the React application
FROM node:18 AS builder

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install

# Build the React application
COPY . .
RUN npm run build

# Stage 2: Serve the React application using a lightweight web server
FROM nginx:alpine

# Copy the build output from the builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]