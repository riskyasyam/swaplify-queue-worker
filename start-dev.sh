#!/bin/bash

# Create logs directory
mkdir -p /app/logs

# Start both services with PM2 in development mode
echo "🚀 Starting NestJS app and Queue Worker in development mode with PM2..."
pm2 start /app/ecosystem.dev.config.js

# Keep the container running by following PM2 logs
pm2 logs --raw
