#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
rg --no-heading "echo.*\\\$_POST" | grep "\.php:" | grep -v -e "(\$_GET" -e "( \$_GET" -e "esc_" -e "admin_url" -e "(int)" -e "htmlentities" -e "sanitize_" -e "wp_nonce_field" -e "wp_kses" -e "sanitize_text_field" -e "sanitize_email" -e "sanitize_url" -e "esc_attr" -e "esc_html" -e "wp_kses_post" -e "esc_js"
 -C 10 "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
