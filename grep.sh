#!/bin/bash

# File containing the keywords
keyword_file="keywords.txt"

# Directory to search
search_dir="extracted_plugins/"

# Directory to save output files
output_dir="output_results/"
mkdir -p "$output_dir"  # Create the directory if it doesn't exist

# Iterate through each keyword in the file
while IFS= read -r keyword
do
    # Skip empty lines
    if [[ -z "$keyword" ]]; then
        continue
    fi

    # Replace any non-alphanumeric characters in the keyword to make it safe for file names
    safe_keyword=$(echo "$keyword" | tr -cd '[:alnum:]_-')

    # Search for the keyword and save the results to a file named after the keyword
    grep "$keyword" -rni --include='*.php' "$search_dir" > "${output_dir}${safe_keyword}.txt"
    
    echo "Results for '$keyword' saved to ${output_dir}${safe_keyword}.txt"
done < "$keyword_file"
