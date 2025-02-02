#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
IMAGE_NAME="mcp/python-uv"
PYTHON_VERSION="3.11"
TAG="latest"

# Function to display usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -t, --tag TAG          Specify image tag (default: latest)"
    echo "  -p, --python VERSION   Specify Python version (default: 3.11)"
    echo "  -h, --help            Show this help message"
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
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Building Python-UV base image...${NC}"
echo -e "${BLUE}Python Version: ${PYTHON_VERSION}${NC}"
echo -e "${BLUE}Tag: ${TAG}${NC}"

# Build the image
docker build \
    --build-arg PYTHON_VERSION="${PYTHON_VERSION}" \
    -t "${IMAGE_NAME}:${TAG}" \
    .

# If building latest, also tag with Python version
if [ "$TAG" = "latest" ]; then
    docker tag "${IMAGE_NAME}:${TAG}" "${IMAGE_NAME}:${PYTHON_VERSION}"
    echo -e "${GREEN}Tagged image with Python version: ${IMAGE_NAME}:${PYTHON_VERSION}${NC}"
fi

echo -e "${GREEN}Successfully built ${IMAGE_NAME}:${TAG}${NC}"

# Show the built image
echo -e "\n${BLUE}Built image details:${NC}"
docker images "${IMAGE_NAME}" 