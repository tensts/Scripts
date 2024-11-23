#!/usr/bin/python
# encoding: UTF-8

import os
import re
import mimetypes
from subprocess import Popen, PIPE
import sys

forbidden_letters = {
    u"ą": "a",
    u"ć": 'c',
    u"ę": 'e',
    u"ł": "l",
    u"ó": "o",
    u"ź": 'z',
    u"ż": "z"
}


def rename_files_in_path(path, check_extension=False):
    for root, dirs, files in os.walk(path):
        for f in files:
            # dropping and saving extension (all after last . occurence)
            ext = f[f[::-1].find('.')*-1-1:]
            name = f[:len(f)-f[::-1].find('.')-1]
            # removing forbidden
            try:
                name.decode('ascii')
            except UnicodeDecodeError:
                name = unicode(name, 'utf8')
                for _ in forbidden_letters.iterkeys():
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
            print "%s become %s" % (root + '/' + unicode(f, 'utf8'), name)
            os.rename(root + '/' + unicode(f, 'utf8'), name)


def usage():
    print '''
    Usage:

    ./rename path [rename_extension<True|False>]
    '''


if __name__ == '__main__':
    rename_ext = False

    if len(sys.argv) == 1:
        print("you did not provide path")
        usage()
        sys.exit(1)

    path = sys.argv[1]
    print path
    if len(sys.argv) == 3:
        if sys.argv[2].strip().lower() == 'true':
            rename_ext = True

    rename_files_in_path(path, rename_ext)
