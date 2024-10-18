#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
 rg --glob '*.php' --no-ignore-vcs -e '\$_GET' "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
