#!/bin/bash

# Script to fetch daily inspirational quote from ZenQuotes API
# Runs on boot, checks if it's a new day, fetches if needed

CONFIG_DIR="$HOME/.config/veneer/eww/widgets/QuoteWidget"
QUOTE_FILE="$CONFIG_DIR/quotes/quote.txt"
AUTHOR_FILE="$CONFIG_DIR/quotes/author.txt"
DATE_FILE="$CONFIG_DIR/quotes/last_fetch_date.txt"

# Ensure config and quote directories exist
mkdir -p "$CONFIG_DIR/quotes"

# Get today's date in YYYY-MM-DD format
TODAY=$(date +%Y-%m-%d)

# Check if we already fetched today
if [ -f "$DATE_FILE" ] && [ "$(cat "$DATE_FILE")" = "$TODAY" ]; then
    echo "Quote already fetched today. Skipping."
    exit 0
fi

# Fetch quote from API
RESPONSE=$(curl -s --connect-timeout 10 "https://zenquotes.io/api/random")

# Check if response is valid JSON array
if echo "$RESPONSE" | jq -e '.[0] | has("q") and has("a")' >/dev/null 2>&1; then
    QUOTE=$(echo "$RESPONSE" | jq -r '.[0].q')
    AUTHOR=$(echo "$RESPONSE" | jq -r '.[0].a')

    # Write to quote file
    echo "\"$QUOTE\"" > "$QUOTE_FILE"
    echo "$AUTHOR" > "$AUTHOR_FILE"

    # Update date file
    echo "$TODAY" > "$DATE_FILE"

    echo "Fetched new quote: $QUOTE - $AUTHOR"
else
    echo "Failed to fetch quote or invalid response. Keeping previous quote."
fi
