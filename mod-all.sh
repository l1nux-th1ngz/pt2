#!/bin/bash

# Iterate over all .sh files in the current directory
for file in *.sh; do
    # Check if the file exists (in case there are no .sh files)
    if [ -e "$file" ]; then
        chmod +x "$file"
        echo "Made $file executable"
    fi
done

echo "All .sh files in the directory have been made executable."
