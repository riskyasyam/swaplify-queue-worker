#!/bin/bash

# Create logs directory
mkdir -p /app/logs

# Start both services with PM2
echo "🚀 Starting NestJS app and Queue Worker with PM2..."
pm2 start /app/ecosystem.config.js

# Keep the container running by following PM2 logs
pm2 logs --raw
