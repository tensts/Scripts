#!/usr/bin/python3
import os
import re
import mimetypes
from subprocess import Popen, PIPE
import sys

forbidden_letters = {
    "ą": "a",
    "ć": 'c',
    "ę": 'e',
    "ł": "l",
    "ó": "o",
    "ź": 'z',
    "ż": "z"
}


def rename_files_in_path(root_path, check_extension=False):
    for root, _, files in os.walk(root_path):
        for f in files:
            # Dropping and saving extension (all after last . occurrence)
            ext = f[f[::-1].find('.')*-1-1:]
            name = f[:len(f)-f[::-1].find('.')-1]

            # Trim whitespace from filename
            name = name.strip()

            # Removing forbidden characters
            try:
                name = name.encode('utf-8').decode('ascii', errors='ignore')
            except UnicodeDecodeError:
                name = name.decode('utf-8')

                for _ in forbidden_letters.items():
                    name = name.replace(_, forbidden_letters[_])
                    name = name.replace(
                        _.upper(), forbidden_letters[_].upper())

            name = name.replace(' ', '-')
            name = re.sub('[^a-zA-Z0-9_-]', '', name)

            if check_extension:
                out, _ = Popen(
                    ['file', '-bi', os.path.join(root, f)], stdout=PIPE).communicate()
                mime = out.split(';', 1)[0].lower().strip()
                ext = mimetypes.guess_extension(mime, strict=False)
                if ext is None:
                    ext = os.path.extsep + 'undef'

            new_name = name + ext
            old_path = os.path.join(root, f)
            new_path = os.path.join(root, new_name)

            if old_path != new_name:
                print(f"{old_path} become {new_path}")
                try:
                    os.rename(old_path, new_path)
                except Exception:
                    pass
                continue

            print(f"{old_path} same path, skipping...")


def usage():
    print('''
    Usage:

    **ACHTUNG** Using python3 was not tested, but code was ported
    ./rename path [rename_extension<True|False>]
    ''')


if __name__ == '__main__':
    RENAME_EXT = False

    if len(sys.argv) == 1:
        print("you did not provide path")
        usage()
        sys.exit(1)

    path = sys.argv[1]
    print(path)
    if len(sys.argv) == 3:
        if sys.argv[2].strip().lower() == 'true':
            RENAME_EXT = True

    rename_files_in_path(path, RENAME_EXT)
