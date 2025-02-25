#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default values
IMAGE_NAME="mcp/python-uv"
PYTHON_VERSION="3.11"
TAG="latest"

# Function to display usage
show_usage() {
    echo -e "${BLUE}Usage: $0 [OPTIONS]${NC}"
    echo ""
    echo -e "${BLUE}Options:${NC}"
    echo "  -t, --tag TAG          Specify image tag (default: latest)"
    echo "  -p, --python VERSION   Specify Python version (default: 3.11)"
    echo "  -h, --help             Show this help message"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tag)
            TAG="$2"
            shift 2
            ;;
        -p|--python)
            PYTHON_VERSION="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Building Python-UV base image...${NC}"
echo -e "${BLUE}Python Version: ${PYTHON_VERSION}${NC}"
echo -e "${BLUE}Tag: ${TAG}${NC}"

echo -e "${BLUE}Cleaning up old images...${NC}"
docker rmi -f "${IMAGE_NAME}:${TAG}" 2>/dev/null || true
if [ "$TAG" = "latest" ]; then
    docker rmi -f "${IMAGE_NAME}:${PYTHON_VERSION}" 2>/dev/null || true
fi

# Build the image
if docker build \
    --build-arg PYTHON_VERSION="${PYTHON_VERSION}" \
    -t "${IMAGE_NAME}:${TAG}" \
    .; then
    
    echo -e "${GREEN}Build successful!${NC}"
    
    # If building latest, also tag with Python version
    if [ "$TAG" = "latest" ]; then
        docker tag "${IMAGE_NAME}:${TAG}" "${IMAGE_NAME}:${PYTHON_VERSION}"
        echo -e "${GREEN}Tagged image with Python version: ${IMAGE_NAME}:${PYTHON_VERSION}${NC}"
    fi
    
    # Get image size
    IMAGE_SIZE=$(docker image inspect "${IMAGE_NAME}:${TAG}" --format='{{.Size}}')
    IMAGE_SIZE_MB=$((IMAGE_SIZE/1024/1024))
    echo -e "\n${BLUE}Built: ${IMAGE_NAME}:${TAG} (${IMAGE_SIZE_MB}MB)${NC}"
    
    # Show the built image
    echo -e "\n${BLUE}Built image details:${NC}"
    docker images "${IMAGE_NAME}"
else
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi 