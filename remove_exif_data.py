#!/usr/bin/python3

import sys
from PIL import Image
import os

if __name__ == '__main__':
    '''
    simple tool that remove exif header from image
    '''
    if len(sys.argv) != 2 or os.path.isfile(sys.argv[1]) is False:
        sys.exit("usage: ./remove_exif_data path/to/file")

    img_file = open(sys.argv[1], 'rb')
    img = Image.open(img_file)
    data = list(img.getdata())
    new_img = Image.new(img.mode, img.size)
    new_img.putdata(data)

    new_img.save(sys.argv[1])

    print("[+] removed exif data from file: %s" % sys.argv[1])
