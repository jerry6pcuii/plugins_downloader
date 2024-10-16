#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
rg --glob '*.php' --no-ignore-vcs -e '\$_GET' -e '\$_POST' -e '\$_REQUEST' -e '\$_SERVER\['\''REQUEST_URI'\''\]' -e '\$_SERVER\['\''PHP_SELF'\''\]' -e '\$_SERVER\['\''HTTP_REFERER'\''\]' -e '\$_COOKIE' -e 'add_query_arg\(' -e 'remove_query_arg\(' -e '\.\s*\$([a-z])\w+/g' "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
