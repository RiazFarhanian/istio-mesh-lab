#!/bin/bash

set -e

SERVICE_NAME="service-b-v1"
IMAGE_TAG="quarkus-${SERVICE_NAME}:1.0.0"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Building Quarkus service: $SERVICE_NAME..."

cd "$PROJECT_DIR"

# Step 1: Clean and build Quarkus app (JVM mode)
echo "🔧 Running Maven package for Quarkus (JVM mode)..."
./mvnw clean package

# Step 2: Build Docker image using Dockerfile.jvm
echo "🐳 Building Docker image using Dockerfile.jvm..."
docker build -f src/main/docker/Dockerfile.jvm -t "$IMAGE_TAG" .

echo "✅ Docker image [$IMAGE_TAG] built successfully for $SERVICE_NAME!"