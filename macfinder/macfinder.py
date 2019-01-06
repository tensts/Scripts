#!/usr/bin/python

import csv
import sys
import os

DB_NAME=os.path.join(os.path.dirname(os.path.realpath(__file__)),"macaddress.io-db.csv")

if len(sys.argv) != 2:
    sys.exit("usage ./macfinder MACADDRESS")

if len(sys.argv[1]) < 6:
    sys.exit("len error: Invalid MACADDRESS")

macaddress = sys.argv[1].replace(":",'').replace("-","").strip().upper()

with open(DB_NAME) as f:
    reader = csv.DictReader(f)
    try:
        for row in reader:
            vendorAddress = row['oui'].replace(":","").strip().upper()

            if macaddress.startswith(vendorAddress):
                print "[+] FOUND: %s" % row
    except csv.Error as e:
        print("[!] Cant process db line %d: %s" % (reader.line_num, e))

sys.exit("[+] DONE")

