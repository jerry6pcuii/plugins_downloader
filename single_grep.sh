#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
rg --glob '*.php' --no-ignore-vcs -e '\b($_GET|$_POST|$_REQUEST|$_SERVER['REQUEST_URI']|$_SERVER['PHP_SELF']|$_SERVER['HTTP_REFERER']|$_COOKIE|add_query_arg|remove_query_arg|$_SERVER['HTTP_X_FORWARDED_FOR']|$_FILES|$content|shortcode_atts|add_shortcode)\s*\(' -e '\.\s*\$([a-z])\w+/g' "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
