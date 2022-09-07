# MongoDB2XLSX

This program copies data from MongoDB database collections to MS Excel >2007 file format.

All collections are created in separate spreadsheets.

Instalation:
```
> pip3 install -r requirments.txt
```

Usage:
```
$ mongo2xlsx --host localhost --port 27800 --db base1 --out document.xlsx
```