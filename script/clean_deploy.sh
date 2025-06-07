#!/bin/bash
# Kill any process using port 8080 (Jetty default)
pids=$(lsof -ti :8080)
if [ -n "$pids" ]; then
  echo "Killing processes on port 8080: $pids"
  kill -9 $pids
fi

# Build the project
cd "$(dirname "$0")/.." || exit 1
mvn clean
mvn package || { echo 'Maven build failed'; exit 1; }

# Run the app using Jetty 11 Maven Plugin
mvn jetty:run