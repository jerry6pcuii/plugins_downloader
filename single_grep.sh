#!/bin/bash

# Define the directory to scan
DIRECTORY="extracted_plugins"

# Define the file containing the patterns
PATTERN_FILE="pattern_grep.txt"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist. Exiting..."
    exit 1
fi

# Check if the pattern file exists
if [ ! -f "$PATTERN_FILE" ]; then
    echo "Pattern file $PATTERN_FILE does not exist. Exiting..."
    exit 1
fi

# Ask the user for the line number of the pattern to use
read -p "Enter the line number of the pattern to use: " LINE_NUMBER

# Validate that the input is a positive integer
if ! [[ "$LINE_NUMBER" =~ ^[0-9]+$ ]] || [ "$LINE_NUMBER" -le 0 ]; then
    echo "Invalid line number. Please enter a positive integer."
    exit 1
fi

# Get the pattern from the specified line
pattern_grep=$(sed -n "${LINE_NUMBER}p" "$PATTERN_FILE")

# Check if the pattern exists
if [ -z "$pattern_grep" ]; then
    echo "No pattern found on line $LINE_NUMBER. Exiting..."
    exit 1
fi

# Define the output file name
OUTPUT_FILE="report_line_${LINE_NUMBER}.txt"

# Run ripgrep and save results to the output file
{
    echo "Pattern used (line $LINE_NUMBER): $pattern_grep"
    rg --glob '*.php' --no-ignore-vcs "$pattern_grep" -C 10 "$DIRECTORY"
} > "$OUTPUT_FILE"

# Notify user that the report is generated
echo "Results have been saved to $OUTPUT_FILE"
