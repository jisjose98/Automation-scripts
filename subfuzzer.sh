#!/bin/bash
#create a bash script that will ask me for a domain and then use subfinder , amass, httpx, waybackurls one by one and make a folder to seperately save the file
# Function to gather subdomains using subfinder
get_subdomains_subfinder() {
    subfinder -d "$1" -o "$2/subdomains_subfinder.txt"
}

# Function to gather subdomains using amass
get_subdomains_amass() {
    amass enum -d "$1" -o "$2/subdomains_amass.txt"
}

# Function to get live hosts using httpx
get_live_hosts() {
    cat "$1" | httpx -o "$2/live_hosts.txt"
}

# Function to get URLs using waybackurls
get_wayback_urls() {
    cat "$1" | waybackurls > "$2/wayback_urls.txt"
}

# Check if required tools are installed
if ! command -v subfinder &> /dev/null || ! command -v amass &> /dev/null || ! command -v httpx &> /dev/null || ! command -v waybackurls &> /dev/null; then
    echo "Error: Please install subfinder, amass, httpx, and waybackurls before running this script."
    exit 1
fi

# Prompt user for the domain
read -p "Enter the domain: " domain

# Create a folder for the results
output_folder="${domain}_scan_results"
mkdir -p "$output_folder"

# Run subfinder and save results
get_subdomains_subfinder "$domain" "$output_folder"

# Run amass and save results
get_subdomains_amass "$domain" "$output_folder"

# Combine subdomains from both tools
cat "$output_folder/subdomains_subfinder.txt" "$output_folder/subdomains_amass.txt" | sort -u > "$output_folder/all_subdomains.txt"

# Get live hosts using httpx
get_live_hosts "$output_folder/all_subdomains.txt" "$output_folder"

# Get URLs using waybackurls
get_wayback_urls "$output_folder/live_hosts.txt" "$output_folder"

echo "Scan completed. Results saved in the folder: $output_folder"
