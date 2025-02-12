#!/bin/bash

DOWNLOAD_DIR="tgz-packages"
mkdir -p "$DOWNLOAD_DIR"

echo "📦 Finding all installed npm packages (including transitive dependencies)..."

# Get a list of all installed package paths
PACKAGE_PATHS=$(npm list -a -p)

# Create an associative array to track unique package names
declare -A PACKAGES

# Extract package names from paths
while IFS= read -r path; do
    # Skip empty lines
    [[ -z "$path" ]] && continue

    # Extract package name from path
    package_name=$(basename "$path")

    # Skip root project path (first line)
    if [[ "$package_name" == "node_modules" || "$package_name" == "$(basename "$(pwd)")" ]]; then
        continue
    fi

    # Add to associative array to prevent duplicates
    PACKAGES["$package_name"]=1
done <<< "$PACKAGE_PATHS"

# Pack each unique package
for package in "${!PACKAGES[@]}"; do
    echo "📦 Packing: $package"
    npm pack "$package" --pack-destination "$DOWNLOAD_DIR"
done

echo "✅ All packages (including dependencies) saved in $DOWNLOAD_DIR/"

