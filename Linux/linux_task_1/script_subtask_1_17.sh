#!/bin/bash
#Created files in directory test, symblink for them and file "new file"
#"new file is neded for reasigned symblink to it"
mkdir test
for i in {1..5}

do FILE=$(cat /dev/urandom | tr -cd 'a-z0-9' | head -c 7)

     head -c ${i}MB /dev/urandom > $FILE
     ln -s ~/task_1_17/$FILE /home/vagrant/task_1_17/test/
done

echo "This is new file" > new_file
