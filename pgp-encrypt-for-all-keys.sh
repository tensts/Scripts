#!/usr/bin/bash
# shellcheck disable=SC2086

# error handling
set -eu

usage() {
cat <<EOF
Script encrypts file for all GPG recipients from user's keyring.
Expired public keys are automatically removed.

Usage:
  $0 /path/to/file

EOF
}

# [ "$#" -ne 1 ] && usage
if [ "$#" -ne 1 ]; then
    usage;
    exit 1;
fi


if [ ! -f "$1" ]; then
    echo "[-] File does not exist: $1" >&2;
    exit 1;
fi

TARGET_FILE="$1"

TARGET_DIR=$(cd "$(dirname "$TARGET_FILE")" && pwd)
TARGET_NAME=$(basename "$TARGET_FILE")
OUTPUT_FILE="$TARGET_DIR/$TARGET_NAME.gpg"
OUTPUT_FILE_ABS="$TARGET_DIR/$TARGET_NAME"

NOW_EPOCH=$(date +%s)

RECIPIENTS=$(gpg --list-keys --with-colons 2>/dev/null \
    | awk -F: -v now="$NOW_EPOCH" '
        $1=="pub" {
            expired = ($7 != "" && $7 < now)
        }
        $1=="uid" && !expired && $10 ~ /<[^>]+>/ {
            match($10, /<[^>]+>/)
            mail = substr($10, RSTART+1, RLENGTH-2)
            print mail
        }
    ')

if [ -z "$RECIPIENTS" ]; then
    echo "[-] No valid (non-expired) GPG recipients found" >&2
    exit 1
fi

GPG_READY_REC_PARAMS=""
while IFS= read -r email; do
    GPG_READY_REC_PARAMS="$GPG_READY_REC_PARAMS -r \"$email\""
done <<< "$RECIPIENTS"
# echo $GPG_READY_REC_PARAMS

echo "[+] Using recipients:"
echo "$RECIPIENTS" | sed 's/^/  /'

# So many ways to plenty to do. ;)
# while IFS= read -r ...
# printf "  %s\n" "$RECIPIENTS"
# awk -v rec=$RECIPIENTS 'NR%2==0 {print $0}'

echo "[+] Encrypting file..."
echo "  Target file: $OUTPUT_FILE_ABS"
echo "  Output file: $OUTPUT_FILE"

echo "[ ] Press Enter to continue..."
read -r

gpg --output "$OUTPUT_FILE" \
--encrypt $GPG_READY_REC_PARAMS \
"$OUTPUT_FILE_ABS"

echo "[+] DONE"
