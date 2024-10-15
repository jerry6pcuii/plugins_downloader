#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Run ripgrep and save results to report.txt
rg --glob '*.php' --no-ignore-vcs '\b(eval|exec|system|shell_exec|wp_set_auth_cookie|unlink|wp_delete_file|filesystem->delete|copy|move_uploaded_file|file_put_contents|put_contents|unzip_file|wp_handle_upload|add_option|update_option|add_user_meta|update_user_meta|wp_insert_user|wp_update_user|wp_set_password|reset_password|add_role|set_role)\s*\(' "$DIRECTORY" > report.txt

# Notify user that the report is generated
echo "Results have been saved to report.txt"
