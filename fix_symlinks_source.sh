#!/bin/bash

# Function to fix broken symlinks
fix_symlinks() {
    local source_dir="$1"
    local target_dir="$2"

    # Find all symbolic links in the current directory and subdirectories
    find . -type l | while read -r link; do
        local target
        target=$(readlink "$link")

        # If the target link is invalid and points to the old source path
        if [[ "$target" == "$source_dir"* ]]; then
            local new_target="${target/$source_dir/$target_dir}"

            # If the target exists, update the symlink
            if [[ -e "$new_target" ]]; then
                echo "Fixing symlink: $link -> $new_target"
                ln -sf "$new_target" "$link"
            else
                echo "Warning: Target $new_target for symlink $link does not exist. Skipping."
            fi
        fi
    done
}

# Main function to process arguments and execute symlink fix
main() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 <old_source_path> <new_source_path>"
        exit 1
    fi

    local old_source="$1"
    local new_source="$2"

    if [[ ! -d "$new_source" ]]; then
        echo "Error: New source directory '$new_source' does not exist."
        exit 1
    fi

    # Call function to fix symlinks
    fix_symlinks "$old_source" "$new_source"

    echo "[+] Symlinks updated successfully."
}

# Execute the main function
main "$@"
