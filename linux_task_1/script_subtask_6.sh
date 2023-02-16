#!/bin/bash
#Create 5 files with random names and sizes to 5 MB

mkdir test

for i in {1..5}
do FILE=$( < /dev/urandom tr -cd 'a-z0-9' | head -c 7)

     head -c "${i}"MB /dev/urandom > "$FILE"

done

#Find all files in current directory and subdirectory, copy them

find . -type f | xargs -I{} cp {} /home/vagrant/playground/task_6/test

#Create 5 files with random names and sizes to 5 MB one more times

for x in {1..5}
   do FILE1=$( < /dev/urandom tr -cd 'a-z0-9' | head -c 7)

     head -c "${x}"MB /dev/urandom > "$FILE1"
   done
