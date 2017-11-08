#!/usr/bin/python
'''
portable secure wipe (testowane na Win7, Deb8)
'''

import argparse
import os
import random
import math
import hashlib
import string


def md5(fname):
    '''
    liczy md5 z pliku
    do testow czy wipe dziala
    :param fname:
    :return:
    '''
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


def overwrite_file(path, chunk_size):
    '''
    nadpisuje zawartosc pliku przez random bytes
    :param path: sciezka pliku
    :param chunk_size: wielkosc bloku do nadpisania [w bajtach]
    :return: void
    '''
    counter = 0
    file_offset = 0

    with open(path, 'rwb+') as file:
        # todo co zrobic jak size = 0
        '''
        a.k.a getfilesize (ale bez nalgowkow) + pointer wraca na poczatek
        '''
        file.seek(0, os.SEEK_END)
        size = float(file.tell())
        file.seek(0, os.SEEK_SET)
        '''
        end
        '''

        chunks = math.ceil(size / chunk_size)
        if chunks == 0:
            chunk_size = size
            chunks = 1

        while counter <= chunks:
            if file.tell() + chunk_size > size:
                chunk_size = int(size - file.tell())

            mess = bytearray(random.getrandbits(8) for i in range(int(chunk_size)))

            file.write(mess)
            file.seek(file_offset, os.SEEK_SET)

            file_offset += chunk_size
            counter += 1


def randomize_name(path):
    '''
    zmienia nazwe pliku na random
    :param path: sciezka do pliku
    :return: sciezke do nowego pliku
    '''
    random_name = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(5))

    directory = os.path.dirname(path)
    if directory is '':
        new_path = random_name
    else:
        new_path = directory + '/' + random_name

    os.rename(path, new_path)
    return new_path


if __name__ == "__main__":
    # TODO dodac argumenty zeby mozna bylo ilosc iteracji sterowac i wielkoscia bloku

    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--file', help="File path", required=True)
    args = parser.parse_args()
    path = args.file

    rounds = 5
    chunk_size = float(1024)  # bytes

    if os.path.isfile(path):
        for i in range(rounds):
            print md5(path)
            overwrite_file(path, chunk_size)
            path = randomize_name(path)

        os.remove(path)
    else:
        print "Error: podana sciezka '%s' nie istnieje" % path
