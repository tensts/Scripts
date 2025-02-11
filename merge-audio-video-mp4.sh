#!/bin/bash

function usage() {
    printf "Usage:\n %s path/to/directory\n" "$0"
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

dir="$1"
if [[ ! -d "$dir" ]]; then
    echo "[-] Path not exists: $dir"
    usage
fi

while IFS= read -r -d '' video; do
    base_name=$(basename "$video" | sed -E 's/ \(.*\)\.mp4//')

    audio="$dir/${base_name}-audio.mp4"
    output="$dir/${base_name}-merged.mp4"

    if [[ -f "$audio" ]]; then
        echo "Merging: $video + $audio -> $output"
        ffmpeg -i "$video" -i "$audio" -c:v copy -c:a copy "$output" </dev/null
    else
        echo "No audio file for $video" >> ffmpeg-merge.log
    fi
done < <(find "$dir" -maxdepth 1 -type f -name "*.mp4" -not -name "*-audio.mp4" -print0)
