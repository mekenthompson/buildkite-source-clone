#!/bin/bash

PACKAGE_FILE="package-list.txt"

if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Error: $PACKAGE_FILE not found!"
    exit 1
fi

echo "Packages to install:"
cat "$PACKAGE_FILE"
echo ""

while IFS= read -r package || [[ -n "$package" ]]; do
    if npm list -g --depth=0 | grep -q "$package@"; then
        echo "$package is already installed."
    else
        echo "Installing $package..."
        npm install -g "$package"
    fi
done < "$PACKAGE_FILE"

echo "Installation complete."
