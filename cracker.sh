#!/bin/bash

# Check if the correct number of arguments is given
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <hash_type> <hash_file>"
    echo "Supported hash types: nt, lm, sha256"
    exit 1
fi

HASH_TYPE="$1"
HASH_FILE="$2"

# Validate hash type
if [[ "$HASH_TYPE" != "nt" && "$HASH_TYPE" != "lm" && "$HASH_TYPE" != "sha256" ]]; then
    echo "Invalid hash type. Supported types are: nt, lm, sha256"
    exit 1
fi

# Check if the file exists and is readable
if [ ! -f "$HASH_FILE" ]; then
    echo "File $HASH_FILE does not exist."
    exit 1
fi

# Counters for statistics
total_hashes=0
cracked_hashes=0
not_found_hashes=0

# Function to lookup a single hash
lookup_single() {
    local hash=$1
    result=$(curl -s "https://ntlm.pw/api/lookup/$HASH_TYPE/$hash")

    if [ "$result" == "" ]; then
        echo "$hash: [not found]"
        ((not_found_hashes++))
    else
        echo "$hash: $result"
        ((cracked_hashes++))
    fi
    ((total_hashes++))
}

# Use bulk lookup if there are more than 10 hashes; else, use single lookup
hash_count=$(wc -l < "$HASH_FILE")

if [ "$hash_count" -le 10 ]; then
    echo "Performing single lookup for each hash..."
    while IFS= read -r hash; do
        lookup_single "$hash"
    done < "$HASH_FILE"
else
    echo "Performing bulk lookup..."
    response=$(curl -s -X POST -H "Content-Type: text/plain" --data-binary "@$HASH_FILE" "https://ntlm.pw/api/lookup?hashtype=$HASH_TYPE")

    if [ "$response" == "" ]; then
        echo "No results found for the hashes in bulk lookup."
    else
        echo "Results from bulk lookup:"
        # Read response line by line
        while IFS= read -r line; do
            # Check if line contains a [not found] indicator
            if [[ "$line" == *"[not found]"* ]]; then
                echo "$line"
                ((not_found_hashes++))
            else
                echo "$line"
                ((cracked_hashes++))
            fi
            ((total_hashes++))
        done <<< "$response"
    fi
fi

# Display statistics
echo -e "\n--- Summary ---"
echo "Total hashes processed: $total_hashes"
echo "Hashes cracked: $cracked_hashes"
echo "Hashes not found: $not_found_hashes"

