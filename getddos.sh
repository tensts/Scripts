#!/bin/bash

if ! [[ $1 =~ '^[0-9]+$' ]]; then
	tail -n $1 /var/log/apache2/access.log | awk -f dos.awk | sort -nrk3 | less | less
else
	echo "musisz podac liczbe wierszy jaka chcesz sprawdzic"
	exit 1
fi
