#!/bin/bash
# Update README.md with a random quote from fortune file

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# File paths
FORTUNE_FILE="$SCRIPT_DIR/.fortune_mission"
README_FILE="$SCRIPT_DIR/README.md"

# Check if files exist
if [[ ! -f "$FORTUNE_FILE" ]]; then
    echo "Error: Fortune file not found at $FORTUNE_FILE"
    exit 1
fi

if [[ ! -f "$README_FILE" ]]; then
    echo "Error: README file not found at $README_FILE"
    exit 1
fi

# Count total number of quotes (number of % separators)
total_quotes=$(grep -c '^%$' "$FORTUNE_FILE")

if [[ $total_quotes -eq 0 ]]; then
    echo "Error: No quotes found in fortune file"
    exit 1
fi

# Generate random number between 1 and total_quotes
random_index=$((RANDOM % total_quotes + 1))

# Extract the random quote
quote=$(awk -v n="$random_index" '
    BEGIN { RS="%"; ORS="" }
    NR == n {
        # Remove leading/trailing whitespace
        gsub(/^[[:space:]]+|[[:space:]]+$/, "")
        print
    }
' "$FORTUNE_FILE")

# Check if quote was extracted
if [[ -z "$quote" ]]; then
    echo "Error: Failed to extract quote"
    exit 1
fi

# Format quote as markdown blockquote (add > prefix to each line)
formatted_quote=$(echo "$quote" | sed 's/^/> /')

# Get current date in ISO format
current_date=$(date -u +"%Y-%m-%d")

# Create temporary file for the new README content
temp_file=$(mktemp)

# Use awk to replace content between markers
awk -v quote="$formatted_quote" -v date="$current_date" '
BEGIN {
    in_quote = 0
    in_date = 0
}
/<!-- QUOTE:START -->/ {
    print
    print quote
    in_quote = 1
    next
}
/<!-- QUOTE:END -->/ {
    in_quote = 0
    print
    next
}
/^\*Last updated:/ {
    print "*Last updated: " date "*"
    next
}
!in_quote {
    print
}
' "$README_FILE" > "$temp_file"

# Replace original file with updated content
mv "$temp_file" "$README_FILE"

echo "README updated successfully with a new quote!"
echo "Date updated to: $current_date"
