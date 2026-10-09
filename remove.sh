#!/bin/bash

# Save the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Get the SHA of the first commit that includes changes to s.txt or w.xls
FIRST_COMMIT_WITH_FILES=$(git log --reverse --oneline --follow rename_files.py | awk '{print $1}')

# Reset the branch to the first commit that includes changes to s.txt or w.xls
git reset "$(git rev-list -n 1 "${FIRST_COMMIT_WITH_FILES}"^)"

echo "Branch '$CURRENT_BRANCH' has been reset to include only commits that modify specified file"