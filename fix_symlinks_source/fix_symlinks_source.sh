#!/bin/bash

# Function to fix broken symlinks
fix_symlinks() {
    local source_dir="$1"

    # Find all symbolic links in the current directory and subdirectories
    find . -type l | while read -r link; do
        local target
        target=$(readlink "$link")

        # target src doesnt exists
        if [ -e "$target" ]; then
            #check if link points to file in source
            if [[ "$target" == "$source_dir"* ]]; then
                new_target="${target/$source_dir/$(realpath "$source_dir")}"
                echo "[+] Fixing link $link -> $new_target"
                ln -sf "$new_target" "$link" || {
                    echo "Error creating link: $link"
                    exit 1
                }
            fi
        fi
    done
}

# Main function to process arguments and execute symlink fix
main() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: $0 <new_source_path>"
        exit 1
    fi

    local new_source="$1"

    if [[ ! -d "$new_source" ]]; then
        echo "Error: New source directory '$new_source' does not exist."
        exit 1
    fi

    # Call function to fix symlinks
    fix_symlinks "$new_source"

    echo "[+] Symlinks updated successfully."
}

# Execute the main function
main "$@"
