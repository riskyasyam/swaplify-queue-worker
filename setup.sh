#!/bin/bash

# Make shell scripts executable
chmod +x start.sh
chmod +x start-dev.sh

echo "✅ Setup complete! Shell scripts are now executable."
echo ""
echo "Next steps:"
echo "1. Build Docker image: docker build -t swaplify-app ."
echo "2. Run with Docker Compose: docker-compose up -d"
echo "3. View logs: docker-compose logs -f app"
