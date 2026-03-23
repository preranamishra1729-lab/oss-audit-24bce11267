#!/bin/bash
# =============================================================================
# Script 4: Log File Analyzer
# Course  : Open Source Software (OSS NGMC)
# Purpose : Read a log file line-by-line, count occurrences of a keyword,
#           and display the last 5 matching lines. Includes a retry loop if
#           the file is empty.
# Usage   : ./script4_log_analyzer.sh <logfile> [keyword]
#           Example: ./script4_log_analyzer.sh /var/log/syslog error
#           Example: ./script4_log_analyzer.sh /var/log/auth.log WARNING
# Concepts: while-read loop, if-then-else, counter variables, $1/$2 arguments,
#           exit codes, do-while style retry, tail + grep.
# =============================================================================

# --- Read command-line arguments ---
LOGFILE=$1                  # First argument: path to the log file
KEYWORD=${2:-"error"}       # Second argument: keyword to search (default: 'error')

# --- Initialise the match counter ---
COUNT=0

# --- Validate: a log file path must be provided ---
if [ -z "$LOGFILE" ]; then
    echo "Usage: $0 <logfile> [keyword]"
    echo "Example: $0 /var/log/syslog error"
    exit 1
fi

echo "========================================================"
echo "       Log File Analyzer — OSS Audit Tool              "
echo "========================================================"
echo "  Log file : $LOGFILE"
echo "  Keyword  : '$KEYWORD'  (case-insensitive search)"
echo "--------------------------------------------------------"

# --- Do-while style retry: keep prompting until a non-empty file is given ---
# This demonstrates the while-condition pattern used as a retry mechanism.
MAX_RETRIES=3     # Maximum number of retry attempts
ATTEMPT=1         # Track current attempt number

while true; do
    # Check: does the file exist at all?
    if [ ! -f "$LOGFILE" ]; then
        echo "  ERROR: File '$LOGFILE' not found. (Attempt $ATTEMPT of $MAX_RETRIES)"

        # If we have retries left, ask the user for a new path
        if [ $ATTEMPT -lt $MAX_RETRIES ]; then
            read -p "  Enter a valid log file path (or press Enter to skip): " LOGFILE
            # If user pressed Enter without input, bail out
            [ -z "$LOGFILE" ] && echo "  No file provided. Exiting." && exit 1
            ATTEMPT=$((ATTEMPT + 1))
            continue   # Restart the while loop with the new path
        else
            echo "  Maximum retries reached. Exiting."
            exit 1
        fi
    fi

    # Check: is the file empty?
    if [ ! -s "$LOGFILE" ]; then
        echo "  WARNING: '$LOGFILE' exists but is empty. (Attempt $ATTEMPT of $MAX_RETRIES)"

        if [ $ATTEMPT -lt $MAX_RETRIES ]; then
            read -p "  Enter a different log file path (or press Enter to skip): " LOGFILE
            [ -z "$LOGFILE" ] && echo "  Skipping retry. Exiting." && exit 1
            ATTEMPT=$((ATTEMPT + 1))
            continue
        else
            echo "  Maximum retries reached. Exiting."
            exit 1
        fi
    fi

    # File exists and is non-empty — break out of the retry loop
    break
done

echo "  File found and non-empty. Starting analysis..."
echo ""

# --- Main analysis: read the log file line by line ---
# IFS= preserves leading/trailing whitespace on each line
# -r flag prevents backslash interpretation
while IFS= read -r LINE; do
    # grep -i = case-insensitive match; -q = quiet (no output, just exit code)
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))   # Increment counter each time keyword is found
    fi
done < "$LOGFILE"   # Feed the file into the while loop via input redirection

# --- Summary output ---
echo "  -------------------------------------------------------"
echo "  RESULT : Keyword '$KEYWORD' found $COUNT time(s)"
echo "           in $(wc -l < "$LOGFILE") total lines."
echo "  -------------------------------------------------------"
echo ""

# --- Show the last 5 matching lines for context ---
if [ $COUNT -gt 0 ]; then
    echo "  Last 5 lines containing '$KEYWORD':"
    echo "  (most recent matches appear last)"
    echo ""
    # grep -i = case-insensitive; pipe to tail to get the final 5 matches
    grep -i "$KEYWORD" "$LOGFILE" | tail -5 | while IFS= read -r MATCH_LINE; do
        echo "    >> $MATCH_LINE"
    done
else
    echo "  No lines matched '$KEYWORD' — the log appears clean for this keyword."
fi

echo ""
echo "========================================================"
echo "  Analysis complete."
echo "========================================================"
