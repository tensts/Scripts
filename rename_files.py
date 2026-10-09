#!/usr/bin/python3

import os
import re
import mimetypes
from subprocess import Popen, PIPE
import sys


class ForbiddenCharacters:
    def __init__(self):
        self.mapping = {
            "ą": "a",
            "ć": 'c',
            "ę": 'e',
            "ł": "l",
            "ó": "o",
            "ź": 'z',
            "ż": "z"
        }

    def replace(self, text):
        for key, value in self.mapping.items():
            text = text.replace(key, value).replace(key.upper(), value.upper())
        return text


class FileNameCleaner:
    @staticmethod
    def clean(name):
        name = name.strip()
        return re.sub('[^a-zA-Z0-9_-]', '', name)


class FileRenamer:
    def __init__(self, root_path, check_extension=False):
        self.root_path = root_path
        self.check_extension = check_extension
        self.forbidden_chars = ForbiddenCharacters()

    def get_file_details(self, f):
        ext = f[f[::-1].find('.')*-1-1:]
        name = f[:len(f)-f[::-1].find('.')-1]
        return name, ext

    def rename_file(self, old_path, new_name):
        if old_path != new_name:
            print(f"{old_path} become {new_name}")
            try:
                os.rename(old_path, new_name)
            except Exception as e:
                print(e)

    def get_mime_type(self, file_path):
        out, _ = Popen(['file', '-bi', file_path], stdout=PIPE).communicate()
        mime = out.split(';', 1)[0].lower().strip()
        return mimetypes.guess_extension(mime, strict=False) or 'undef'

    def rename_files_in_path(self):
        for root, _, files in os.walk(self.root_path):
            for f in files:
                name, ext = self.get_file_details(f)
                new_name = self.forbidden_chars.replace(name)
                new_name = FileNameCleaner.clean(new_name).replace(' ', '-')
                if self.check_extension:
                    ext = self.get_mime_type(os.path.join(root, f))
                new_name += ext
                old_path = os.path.join(root, f)
                self.rename_file(old_path, os.path.join(root, new_name))


class Usage:
    @staticmethod
    def print_usage():
        print('''
    Usage:

    **ACHTUNG** Using python3 was not tested, but code was ported
    ./rename path [rename_extension<True|False>]
    ''')


if __name__ == '__main__':
    RENAME_EXT = False

    if len(sys.argv) == 1:
        print("you did not provide path")
        Usage.print_usage()
        sys.exit(1)

    path = sys.argv[1]

    if len(sys.argv) == 3:
        if sys.argv[2].strip().lower() == 'true':
            RENAME_EXT = True

    renamer = FileRenamer(path, RENAME_EXT)
    renamer.rename_files_in_path()
