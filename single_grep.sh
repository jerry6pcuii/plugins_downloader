#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
grep -rnw './' -e 'add_query_arg(' | grep -v 'esc_url' | grep -v 'esc_html' -C 4 "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
