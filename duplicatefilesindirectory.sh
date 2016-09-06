#!/bin/bash
>output.tmp.txt; find $1 -type f -print0 | while IFS= read -r -d '' file; do  echo "`md5sum $file`" >> output.tmp.txt; done ;
cat  output.tmp.txt | sort > output.txt ; rm -rf output.tmp.txt;
cat output.txt | awk '{print $1}' |uniq -D | uniq > duplicates.txt
>duplicatefiles.txt; IFS=$'\n'; for j in `cat duplicates.txt`;  do cat output.txt | grep $j | awk '{print $2}' >> duplicatefiles.txt ; done; rm -rf duplicates.txt; cat duplicatefiles.txt;
