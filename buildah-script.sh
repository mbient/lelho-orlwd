#!/usr/bin/env bash

#Setting up some colors for helping read the demo output
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

#set -x

# Check if buildah is installed
if ! command -v buildah &> /dev/null; then
    echo "Buildah is not installed. Please install it first."
    exit 1
fi

IMAGE_NAME=helloc

TEMP_DIR=$(mktemp -d)
echo -e "${cyan}Create a temporary directory ${TEMP_DIR}${reset}"
BUILD_DIR="$TEMP_DIR/app"

# Create directory for the builder
mkdir -p "$BUILD_DIR/src"
cp ./src/hello.c "$BUILD_DIR/src/"

echo -e "${bold}Build image with Buildah.${reset}"
BUILDER_CONTAINER=$(buildah from gcc:latest)

# Set working-directory in the builder-container
buildah run "$BUILDER_CONTAINER" -- mkdir -p /app/src
buildah copy "$BUILDER_CONTAINER" "$BUILD_DIR/src/hello.c" /app/src/

# Compile c-file
buildah run "$BUILDER_CONTAINER" -- gcc -o /app/src/Hello /app/src/hello.c

# Create final image
FINAL_CONTAINER=$(buildah from alpine:latest)

# Install the required library
buildah run "$FINAL_CONTAINER" -- apk add --no-cache libc6-compat

# Mount file-system of the builder-containers
BUILDER_MOUNT=$(buildah mount "$BUILDER_CONTAINER")

# Copy the executable file from the builder container to the final image
cp "$BUILDER_MOUNT/app/src/Hello" /tmp/Hello

# Unmount builder-container
buildah umount "$BUILDER_CONTAINER"

# Copy the executable file to the final image
buildah copy "$FINAL_CONTAINER" /tmp/Hello /app/Hello

# Set permissions
buildah run "$FINAL_CONTAINER" -- chmod +x /app/Hello

# Set command
buildah config --cmd '["/app/Hello"]' "$FINAL_CONTAINER"

# Build final image
buildah commit "$FINAL_CONTAINER" "$IMAGE_NAME"

# Clean up temporary files
rm -rf "$TEMP_DIR"

# Remove final- and builder-container
buildah rm "$FINAL_CONTAINER" "$BUILDER_CONTAINER"

echo -e "${green}Image successfully created.${reset}"

# Run image and delete after use
podman run --rm "$IMAGE_NAME" 
