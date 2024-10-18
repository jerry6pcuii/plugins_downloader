#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
rg --no-heading "echo.*\\\$_GET" | grep "\.php:" | grep -v -e "(\$_GET" -e "( \$_GET" -e "esc_" -e "admin_url" -e "(int)" -e htmlentities -e sanitize_text_field "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
