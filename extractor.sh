#!/bin/bash

# Check if the plugin.txt file exists
if [[ ! -f "plugin.txt" ]]; then
    echo "File plugin.txt not found!"
    exit 1
fi

# Create the extracted_plugins directory if it doesn't exist
mkdir -p "extracted_plugins"

# Navigate to the extracted_plugins directory
cd "extracted_plugins" || exit

# Extract 3000 random plugin names from plugin.txt
PLUGIN_NAMES=$(shuf -n 3000 "../plugin.txt")

# Read each plugin name
while IFS= read -r PLUGIN_NAME; do
    # Set the SVN URL for the plugin
    SVN_URL="https://plugins.svn.wordpress.org/$PLUGIN_NAME/trunk/"

    # Create a directory for the plugin if it doesn't exist
    mkdir -p "$PLUGIN_NAME"

    # Navigate to the plugin directory
    cd "$PLUGIN_NAME" || exit

    # Checkout the latest version from the SVN repository
    svn checkout "$SVN_URL" .

    echo "Downloaded the latest version of $PLUGIN_NAME to $(pwd)"
    
    # Navigate back to the extracted_plugins directory
    cd ..

done <<< "$PLUGIN_NAMES"
