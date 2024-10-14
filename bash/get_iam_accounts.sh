#!/bin/bash

# Function to print usage
usage() {
    echo "Usage: $0 -t <token> [-j | -c]"
    echo "  -t <token>   Bearer token for authentication"
    echo "  -j           Save output as JSON"
    echo "  -c           Save output as CSV"
    exit 1
}

# Initialize variables
TOKEN=""
SAVE_JSON=false
SAVE_CSV=false
URL_BASE="https://api.xdr.trendmicro.com"
URL_PATH="/v3.0/iam/accounts"
TOP=50

# Parse command-line arguments
while getopts "t:jc" opt; do
    case $opt in
        t) TOKEN="$OPTARG" ;;
        j) SAVE_JSON=true ;;
        c) SAVE_CSV=true ;;
        *) usage ;;
    esac
done

# Ensure a token is provided and either -j or -c is specified
if [[ -z "$TOKEN" || ( "$SAVE_JSON" == false && "$SAVE_CSV" == false ) ]]; then
    usage
fi

# ANSI escape codes for colors
GREEN="\033[92m"
YELLOW="\033[93m"
RESET="\033[0m"

# Initialize variables for pagination
ACCOUNTS=()
NEXT_URL="${URL_BASE}${URL_PATH}?top=${TOP}"

# Loop to fetch all accounts
while [[ -n "$NEXT_URL" ]]; do
    # Make the GET request
    RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" "$NEXT_URL")
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" "$NEXT_URL")

    # Check the status of the request
    if [[ "$STATUS_CODE" -eq 200 ]]; then
        echo -e "${GREEN}Request successful. Status: 200 OK${RESET}"
        
        # Parse and append accounts
        BATCH=$(echo "$RESPONSE" | jq -c '.items[]')
        if [[ -n "$BATCH" ]]; then
            while IFS= read -r account; do
                ACCOUNTS+=("$account")
            done <<< "$BATCH"
            echo -e "${YELLOW}Accounts retrieved in this batch: $(echo "$BATCH" | wc -l)${RESET}"
            echo -e "${YELLOW}Total accounts retrieved so far: ${#ACCOUNTS[@]}${RESET}"
        else
            echo -e "${YELLOW}No more accounts in this batch.${RESET}"
        fi

        # Check for nextLink in the response
        NEXT_URL=$(echo "$RESPONSE" | jq -r '.nextLink // .["@odata.nextLink"] // empty')
        if [[ -z "$NEXT_URL" ]]; then
            echo -e "${YELLOW}No more pages to retrieve.${RESET}"
            NEXT_URL=""
        fi
    else
        echo -e "${YELLOW}Error fetching data: $STATUS_CODE${RESET}"
        exit 1
    fi
done

# Log the total accounts retrieved
echo -e "${YELLOW}Total accounts retrieved: ${#ACCOUNTS[@]}${RESET}"

# Save the output based on the provided flag
if [[ "$SAVE_JSON" == true ]]; then
    JSON_FILE="accounts.json"
    printf '%s\n' "${ACCOUNTS[@]}" | jq -s '.' > "$JSON_FILE"
    echo -e "${GREEN}JSON file saved at: $(realpath "$JSON_FILE")${RESET}"
fi

if [[ "$SAVE_CSV" == true ]]; then
    if [[ ${#ACCOUNTS[@]} -gt 0 ]]; then
        CSV_FILE="accounts.csv"
        # Get keys from the first JSON object
        KEYS=$(echo "${ACCOUNTS[0]}" | jq -r 'keys | @csv' | tr -d '"')
        # Write CSV header
        echo "$KEYS" > "$CSV_FILE"
        # Write each account as a CSV row
        for account in "${ACCOUNTS[@]}"; do
            echo "$account" | jq -r '[.[]] | @csv' >> "$CSV_FILE"
        done
        echo -e "${GREEN}CSV file saved at: $(realpath "$CSV_FILE")${RESET}"
    else
        echo -e "${YELLOW}No accounts were retrieved that can be exported to CSV.${RESET}"
    fi
fi


