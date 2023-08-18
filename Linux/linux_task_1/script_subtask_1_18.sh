
#!/bin/bash
mkdir /home/vagrant/test_1_18

for i in {1..5}
do FILE=$(cat /dev/urandom | tr -cd 'a-z0-9' | head -c 7)

     head -c ${i}MB /dev/urandom > $FILE;
    # head -c ${i}MB /dev/urandom > $FILE
    #{ ${FILE} readlink -f ${FILE} ; echo "/home/vagrant/test" ; } >> list
    readlink -f $FILE >> list
    mkdir -p /home/vagrant/link_dir/link{1..5} && cd "$_"
    pwd >> list
    cd /home/vagrant/task_1_18
done
