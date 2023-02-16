#!/bin/bash
#Creat files.txt in '~/task_1_35/test_txt' directory
if [[ -d ./test_txt ]]
    then
        echo "such directory is existed"
        exit 1
else
mkdir ./test_txt && cd "$_"
    for i in {1..5}
        do touch file_"${i}".txt
        head -c "${i}"MB /dev/urandom > file_"${i}".txt
    done
fi
cd ..
#Creat files.jpeg in '~/task_1_35/test_jpeg' directory
if [[ -d ./test_jpeg ]]
    then
        echo "such directory is existed"
        exit 1
else
mkdir test_jpeg && cd "$_"
    for x in {1..7}
        do touch file_"${x}".jpeg
        head -c "${x}"MB /dev/urandom > file_"${x}".jpeg
    done
fi
cd ..



