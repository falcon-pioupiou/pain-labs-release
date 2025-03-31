#!/bin/bash

# Pain Lab Auto-Installer
# Downloads the correct binary for your OS and architecture

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BASE_URL="https://github.com/falcon-pioupiou/pain-labs-release/raw/refs/heads/main/latest"
OUTPUT_DIR="."
BINARY_NAME="pain-labs"

print_header() {
  echo -e "${BLUE}=============================================${NC}"
  echo -e "${BLUE}     Pain Lab Auto-Installer${NC}"
  echo -e "${BLUE}=============================================${NC}"
  echo
}

print_usage() {
  echo -e "Usage: $0 [OPTIONS]"
  echo
  echo -e "Options:"
  echo -e "  -o, --output DIR    Directory to save the binary (default: current directory)"
  echo -e "  -h, --help          Display this help message"
  echo
}

# Process command line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -o|--output) OUTPUT_DIR="$2"; shift ;;
    -h|--help) print_header; print_usage; exit 0 ;;
    *) echo -e "${RED}Unknown parameter: $1${NC}"; print_usage; exit 1 ;;
  esac
  shift
done

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="darwin"
  echo -e "${GREEN}Detected macOS${NC}"
elif [[ "$OSTYPE" == "linux"* ]]; then
  OS="linux"
  echo -e "${GREEN}Detected Linux${NC}"
else
  echo -e "${RED}Unsupported operating system: $OSTYPE${NC}"
  echo -e "${YELLOW}This installer supports only macOS and Linux${NC}"
  exit 1
fi

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
  echo -e "${GREEN}Detected amd64 architecture${NC}"
elif [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
  echo -e "${GREEN}Detected arm64 architecture${NC}"
else
  echo -e "${RED}Unsupported architecture: $ARCH${NC}"
  echo -e "${YELLOW}This installer supports only amd64 and arm64 architectures${NC}"
  exit 1
fi

# Construct binary name and URL
BINARY_URL="$BASE_URL/pain-lab-$OS-$ARCH"
OUTPUT_PATH="$OUTPUT_DIR/$BINARY_NAME"

echo -e "${BLUE}Downloading Pain Lab for $OS/$ARCH...${NC}"
echo -e "From: $BINARY_URL"
echo -e "To: $OUTPUT_PATH"

# Download the binary with curl
if command -v curl &>/dev/null; then
  curl -L --progress-bar "$BINARY_URL" -o "$OUTPUT_PATH"
elif command -v wget &>/dev/null; then
  wget --show-progress -q "$BINARY_URL" -O "$OUTPUT_PATH"
else
  echo -e "${RED}Error: Neither curl nor wget found. Please install one of them and try again.${NC}"
  exit 1
fi

# Check if download was successful
if [ $? -eq 0 ] && [ -f "$OUTPUT_PATH" ]; then
  # Make the binary executable
  chmod +x "$OUTPUT_PATH"
  echo -e "${GREEN}Download complete! Pain Lab has been installed to $OUTPUT_PATH${NC}"
  
  # Add execution instructions
  echo
  echo -e "${YELLOW}To run Pain Lab:${NC}"
  if [[ "$OUTPUT_DIR" == "." ]]; then
    echo -e "  ./$BINARY_NAME"
  else
    echo -e "  $OUTPUT_PATH"
  fi
else
  echo -e "${RED}Download failed. Please check your internet connection and try again.${NC}"
  exit 1
fi

# Add the binary location to PATH suggestion
if [[ "$OUTPUT_DIR" != "/usr/local/bin" && "$OUTPUT_DIR" != "/usr/bin" ]]; then
  echo
  echo -e "${YELLOW}Pro tip:${NC} To use Pain Lab from anywhere, move it to a directory in your PATH:"
  echo -e "  sudo mv $OUTPUT_PATH /usr/local/bin/$BINARY_NAME"
fi

