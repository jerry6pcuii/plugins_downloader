#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
rg --no-heading "unzip_file\(" -C 4 "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
