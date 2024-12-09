#!/bin/bash

# Check if an argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_source_dir>"
    exit 1
fi

SOURCE_DIR="$1"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Variable to the directory where the script is run
TARGET_DIR=$(pwd)

# Recursively search the directory for symbolic links
find "$TARGET_DIR" -type l | while read -r link; do
    # Check if a symbolic link points to a nonexistent source
    target=$(readlink "$link")

    if [ ! -e "$target" ]; then
        # Check if the link points to a source that is in the source directory
        if [[ "$target" == "$SOURCE_DIR"* ]]; then
            # Replace the old source with the new one
            new_target="${target/$SOURCE_DIR/$(realpath "$SOURCE_DIR")}"
            echo "Improving link: $link -> $new_target"
            ln -sf "$new_target" "$link" || {
                echo "Error creating link: $link"
                exit 1
            }
        fi
    fi
done

echo "[+] Fixed the links."
