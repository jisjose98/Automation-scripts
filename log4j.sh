#!/bin/bash

#./find_log4j.sh /path/to/webapp

# Function to check for log4j-related files
find_log4j_files() {
    local webapp_path="$1"
    
    # Check for log4j configuration files
    log4j_files=$(find "$webapp_path" -type f -name "log4j*.xml" -o -name "log4j*.properties" 2>/dev/null)

    if [ -n "$log4j_files" ]; then
        echo "Log4j configuration files found:"
        echo "$log4j_files"
        echo "Potential log4j vulnerability may exist."
    else
        echo "No log4j configuration files found in the web application."
    fi
}

# Check if user provided a web application path
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <webapp_path>"
    exit 1
fi

webapp_path="$1"

# Check if the provided path exists
if [ ! -d "$webapp_path" ]; then
    echo "Error: The specified web application path does not exist."
    exit 1
fi

# Check for log4j-related files in the web application directory
find_log4j_files "$webapp_path"
