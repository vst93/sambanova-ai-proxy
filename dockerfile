# Use the official Node.js image based on Alpine 3.20
FROM node:alpine3.20

# Set the working directory inside the container
WORKDIR /app

# Copy the server code to the container
COPY server.js .

# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set the user to the non-root user
USER appuser

# Expose the port that your Node.js server listens on
EXPOSE 11435

# Define the command to run the server
CMD ["node", "server.js"]
