#!/bin/bash

# Check if the file argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

FILE=$1
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Use git filter-repo to remove the file from all commits
git filter-repo --path "$FILE" --force

echo "File '$FILE' has been removed from all commits in branch '$CURRENT_BRANCH'."