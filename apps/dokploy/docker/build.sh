#!/bin/bash

# Determine the type of build based on the first script argument
BUILD_TYPE=${1:-production}

if [ "$BUILD_TYPE" == "canary" ]; then
    TAG="canary"
else
    VERSION=$(node -p "require('./package.json').version")
    TAG="$VERSION"
fi

# Detect host architecture
ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    PLATFORM="linux/amd64"
elif [ "$ARCH" == "aarch64" ]; then
    PLATFORM="linux/arm64"
else
    PLATFORM="linux/amd64" # Fallback
fi

echo "Building locally for platform: $PLATFORM"

BUILDER=$(docker buildx create --use)

docker buildx build --platform "$PLATFORM" --pull --rm --load -t "guptatarun/dokploy:${TAG}" -f 'Dockerfile' .

docker buildx rm $BUILDER
