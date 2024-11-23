#!/bin/bash

for i in "$@"; do
    case $i in
    -h=* | --host=*)
        DOMAIN="${i#*=}"
        shift
        ;;
    -o=* | --output=*)
        SOURCE="${i#*=}"
        shift
        ;;
    *)
        # unknown option
        ;;
    esac
done
mkdir $SOURCE
cd $SOURCE
wget --recursive \ 
--no-clobber \
    --page-requisites \
    --html-extension \
    --convert-links \
    --restrict-file-names=windows \
    --domains $DOMAIN \
    --no-parent $DOMAIN
