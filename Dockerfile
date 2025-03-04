# Dockerfile for package.json

# Use the official Node.js 14 image.
# https://hub.docker.com/_/node
FROM node:14 AS build

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./

# Install production dependencies.
RUN npm install --only=production

# Copy local code to the container image.
COPY . .

# Generate a build of the application.
RUN npm run build

# Use the official Nginx image to serve the built files.
FROM nginx:alpine

# Copy the build files to the Nginx HTML directory.
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Expose port 80 to the outside world.
EXPOSE 80

# Start Nginx server.
CMD ["nginx", "-g", "daemon off;"]