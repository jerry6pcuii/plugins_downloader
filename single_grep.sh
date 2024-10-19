#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
rg -r 'move_uploaded_file' "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
