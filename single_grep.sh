#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
rg 'file_put_contents\(' --iglob '*.php' -C 3 "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
