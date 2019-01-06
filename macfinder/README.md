# MACfinder

Simple tool to get vendor info from mac address

## Usage
```
./macfinder <macaddress>

$ ./macfinder.py b8:ca:3a:c5:ef:a4
[+] FOUND: {'oui': 'B8:CA:3A', 'countryCode': 'US', 'companyName': 'Dell Inc', 'companyAddress': 'One Dell Way Round Rock  TX  78682 US', 'dateCreated': '2013-01-09', 'assignmentBlockSize': 'MA-L', 'isPrivate': '0', 'dateUpdated': '2015-10-25'}
[+] DONE
```
Mac address should be atleast 24bits long. Accepted format: `XX:XX:XX`,`XX-XX-XX`, `XXXXXX`


Mac address database source [macaddress.io](https://macaddress.io/database-download/csv)
