# geedit

This program decode informations from [FreeBSD GELI](https://www.freebsd.org/cgi/man.cgi?geli(8))
metadata file and display it. (v1 or higer).

## Usage
```
$ make
$ ./geedit <file>
>opening: <file>
>     magic: GEOM::ELI
>   version: 7
>     flags: 0x0
>     ealgo: 22
>    keylen: 128
>     aalgo: (null)
>  provsize: 144115188091117786
>sectorsize: 3607166976
>      keys: 0x7f
```

## TODO
* decode codes to values
* edit&save metadata file
