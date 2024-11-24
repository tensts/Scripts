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
            # dropping and saving extension (all after last . occurence)
            ext = f[f[::-1].find('.')*-1-1:]
            name = f[:len(f)-f[::-1].find('.')-1]
            # removing forbidden
            try:
                name = name.decode('ascii')
            except UnicodeDecodeError:
                name = name.decode('utf-8')

                for _ in forbidden_letters.items():
                    name = name.replace(_, forbidden_letters[_])
                    name = name.replace(
                        _.upper(), forbidden_letters[_].upper())

            name = name.replace(' ', '-')
            name = re.sub('[^a-zA-Z0-9_-]', '', name)

            if check_extension:
                out, _ = Popen(['file', '-bi', f], stdout=PIPE).communicate()
                mime = out.split(';', 1)[0].lower().strip()
                ext = mimetypes.guess_extension(mime, strict=False)
                if ext is None:
                    ext = os.path.extsep + 'undef'

            name = root + '/' + name + ext
            path_p = root + '/' + f.decode('utf8')
            print(f"{path_p} become {name}")
            os.rename(root + '/' + f.decode('utf8'), name)


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
