#!/bin/bash

# Q3. Write a program to take input name and age of 10 persons and print it in reverse sorted order of age.
# Note:
# a) Please avoid using the library for sorting
# b) If you are using shell script, please avoid using sort command.

arraylength=10
declare -A name_age

for (( i = 0; i < $arraylength; i++ ))
do
    read -r name_age[$i,0] name_age[$i,1]
done


for (( i = 0; i <= $arraylength ; i++ ))
do
	for (( j = $i; j <= $arraylength; j++ ))
	do
		if [[ ${name_age[$i,1]} -lt ${name_age[$j,1]} ]]; then
           t=${name_age[$i,1]}
           name_age[$i,1]=${name_age[$j,1]}
           name_age[$j,1]=$t
           t=${name_age[$i,0]}
           name_age[$i,0]=${name_age[$j,0]}
           name_age[$j,0]=$t           
		fi
	done
done


for (( i = 0; i < $arraylength; i++ ))
do
  echo ${name_age[$i,0]}"   "${name_age[$i,1]}
done
