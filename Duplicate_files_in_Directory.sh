#!/bin/bash

find $1 -type f | xargs -I{} md5sum {} | sort > filelist.txt
cat filelist.txt | awk '{print $1}' | uniq -d | xargs -I{} grep {} filelist.txt | awk '{print $2}'
rm -rf filelist.txt