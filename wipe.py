#!/usr/bin/python3
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


def overwrite_file(src_file_path, byte_chunk_size):
    '''
    nadpisuje zawartosc pliku przez random bytes
    :param path: sciezka pliku
    :param chunk_size: wielkosc bloku do nadpisania [w bajtach]
    :return: void
    '''
    counter = 0
    file_offset = 0

    with open(src_file_path, 'r+b') as file:
        # TODO co zrobic jak size = 0
        # a.k.a getfilesize (ale bez nalgowkow) + pointer wraca na poczatek
        file.seek(0, os.SEEK_END)
        size = float(file.tell())
        file.seek(0, os.SEEK_SET)
        # end

        chunks = math.ceil(size / byte_chunk_size)
        if chunks == 0:
            byte_chunk_size = size
            chunks = 1

        while counter <= chunks:
            if file.tell() + byte_chunk_size > size:
                byte_chunk_size = int(size - file.tell())

            mess = bytearray(random.getrandbits(8)
                             for i in range(int(byte_chunk_size)))

            file.write(mess)
            file.seek(file_offset, os.SEEK_SET)

            file_offset += byte_chunk_size
            counter += 1


def randomize_name(src_file_path):
    '''
    zmienia nazwe pliku na random
    :param path: sciezka do pliku
    :return: sciezke do nowego pliku
    '''
    random_name = ''.join(random.choice(
        string.ascii_uppercase + string.digits) for _ in range(5))

    directory = os.path.dirname(src_file_path)
    if directory is '':
        new_path = random_name
    else:
        new_path = directory + '/' + random_name

    os.rename(src_file_path, new_path)
    return new_path


if __name__ == "__main__":
    # TODO dodac argumenty zeby mozna bylo ilosc iteracji sterowac i wielkoscia bloku
    # TODO **ACHTUNG** Using python3 was not tested, but code was ported

    parser = argparse.ArgumentParser()
    parser.add_argument('-f', '--file', help="File path", required=True)
    args = parser.parse_args()
    file_path = args.file

    ROUNDS = 5
    chunk_size = float(1024)  # bytes

    if os.path.isfile(file_path):
        for i in range(ROUNDS):
            print(md5(file_path))
            overwrite_file(file_path, chunk_size)
            path = randomize_name(file_path)

        os.remove(path)
    else:
        print(f"Error: podana sciezka {file_path} nie istnieje")
