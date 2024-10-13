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
    # Strip any hidden or non-printable characters from PLUGIN_NAME
    PLUGIN_NAME=$(echo "$PLUGIN_NAME" | tr -cd '[:print:]')

    # Fetch plugin information from the WordPress API
    PLUGIN_INFO=$(curl -s "https://api.wordpress.org/plugins/info/1.0/$PLUGIN_NAME.json")
    
    # Check if the plugin info was retrieved successfully
    if [[ $? -ne 0 ]]; then
        echo "Failed to fetch info for $PLUGIN_NAME"
        continue
    fi

    # Extract the number of active installations from the JSON response
    INSTALLS=$(echo "$PLUGIN_INFO" | jq -r '.active_installs // "0"')

    # Check if the number of installs is greater than 1000
    if (( INSTALLS > 1000 )); then
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
    else
        echo "$PLUGIN_NAME has only $INSTALLS installs, skipping download."
    fi
done <<< "$PLUGIN_NAMES"
