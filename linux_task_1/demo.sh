#!/bin/bash
#Function for hard link
function hard_link () {
     mkdir "$1"
     cd /home/vagrant/playground/"$1"
     mkdir test
     #Creating file and its hardlinks
     head -c 4MB /dev/urandom > file1
     ln file1 /home/vagrant/playground/"$1"/test/hardlink
     ln file1 /home/vagrant/playground/"$1"/test/
}
#subtask_№1
if [ "$1" = "task_1" ]
    then
        mkdir task_1
        TASK_1=$(cat /etc/login.defs | grep SYS_UID)
        TASK_1_2=$(cat /etc/group | grep -oP '\w+:x:[2-9]\d\d' | cut -d ":" -f 1,3 >> task_1/sysgroupid)
        echo -e "\nTask Description:\n
Find all system groups and get only their unique names and IDs. Save it to file"
        echo -e "\nCommand:\n\ncat /etc/login.defs | grep SYS_UID\n\nOutput:\n\n""$TASK_1"
        echo -e "\nCommand:\n\ncat /etc/group | grep -oP '\w+:x:[2-9]\d\d' |
cut -d ":" -f 1,3 >> task_1/sysgroupid\nOutput of the task_1/sysgroupid file::\n"
        eval "$TASK_1_2"
        cat task_1/sysgroupid
        rm -r task_1
fi
#subtask_№2
if [ "$1" = "task_2" ]
    then
        mkdir task_2
        echo -e "\nTask Description:\nFind all files and directories that have permissions
to access the corresponding user and group"
        echo -e "\nCommand:\n\n sudo find / -type "f" -group vagrant -perm -755"
        echo -e "\nCommand:\n\n sudo find / -type "f" -user vagrant -perm -644"
        echo -e "\nOutput:"
        sudo find ~/ -type "f" -group vagrant -perm -755
        echo -e "\nOutput:"
        sudo find ~/ -type "f" -user vagrant -perm -644
        rm -r task_2
fi
#subtask_№3
if [ "$1" = "task_3" ]
    then
        mkdir task_3
        echo -e "\nTask Description:\nFind all scripts in the specified directory and its subdirectories"
        echo -e "\nCommand:\n\n find . -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) -exec grep -l 'bash' {} \;"
        echo -e "\nOutput:"
        find . -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) -exec grep -l 'bash' {} \;
        echo -e "\nCommand:\n\n find . -type f | xargs -exec file {} \; | grep "Bourne-Again shell script" | cut -d ":" -f1"
        find . -type f | xargs -exec file {} \; | grep "Bourne-Again shell script" | cut -d ":" -f1
        rm -r task_3
fi
#subtask_№4
if [ "$1" = "task_4" ]
    then
        echo -e "\nTask Description:\nSearch for script files under a specific user."
        echo -e "\nCommand:\n\nsudo -u task_4 find /home/task_4/ -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) -exec grep -l 'bash' {} \;"
        echo -e "\nOutput:"
        sudo -u task_4 find /home/task_4/ -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) -exec grep -l 'bash' {} \;
fi
#subtask№5
if [ "$1" = "task_5" ]
    then
        echo -e "\nTask Description:\nPerform a recursive search for words or a phrase for a specific file type.\n"
        echo -e "Command:\ngrep --include=\*.{sh,zh} -r '/home/vagrant' -e \"random\""
        echo -e "\nOutput:"
        sudo grep --include=\*.{sh,zh} -r '/home/' -le "script"
fi
#subtask№6
if [ "$1" = "task_6" ]
    then
        mkdir task_6
        cp task_6.sh /home/vagrant/playground/task_6/
        cd /home/vagrant/playground/task_6
        sh ./task_6.sh
    echo -e "\nTask Description:\nFind duplicate files in specific directories.\n"
    echo -e "Command:\nfind . -type f -exec sha224sum {} + | sort | uniq -w32 -dD\n"
    echo -e "Output:"
    find . -type f -exec sha224sum {} + | sort | uniq -w32 -dD
    echo -e "\nCommand:\nfind . -type f -printf '%s %f\n' | sort -n | uniq -dD"
    echo -e "\nOutput:"
    find . -type f -printf '%s %f\n' | sort -n | uniq -dD
        rm -r ../task_6
fi
#subtask№7
if [ "$1" = "task_7" ]
    then
        mkdir task_7
        cp task_7.sh /home/vagrant/playground/task_7/
        cd /home/vagrant/playground/task_7
        sh ./task_7.sh
    echo -e "\nTask Description:\nFind all symbolic links to file.\n"
    echo -e "Command:\nfind / -type l -exec ls -al {} \\; | grep -i "name searched file"\n"
    echo -e "Output:"
    find . -type l -exec ls -al {} \; | grep -i "file1"
    rm -r ../task_7
fi
#subtask№8
if [ "$1" = "task_8" ]
    then
        hard_link "$1"
    echo -e "\nTask Description:\nFind all links to file.\n"
    ls -li . test/
    echo -e "Command:\nfind . -samefile ~/playground/task_8/file1\n"
    echo -e "Output:"
    find . -samefile ~/playground/"$1"/file1
    rm -r ../task_8
fi
#subtask№9
if [ "$1" = "task_9" ]
    then
        hard_link "$1"
    INODE=$(ls -li file1 | cut -d " " -f 1)
    echo -e "\nTask Description:\nFind files belong to a spesific inode number\n"
    ls -li . test/
    echo -e "Command:\nfind -inum $INODE\n"
    echo -e "Output:"
    find -inum $INODE
    rm -r ../task_9
fi
#subtask№10
#
#subtask№11
if [ "$1" = "task_11" ]
    then
        hard_link "$1"
        ln -s ~/playground/"$1"/file1 /home/vagrant/playground/"$1"/test/symlink
        ln -s ~/playground/"$1"/file1 /home/vagrant/playground/"$1"/test/file1_symlink
        ln -s file1 /home/vagrant/playground/"$1"/symlink
        ln -s file1 /home/vagrant/playground/"$1"/file1_symlink
        touch file{1..4}
    echo -e "\nTask Description:\nDelete the file which has a hard and symb links\n"
    tree
    echo -e "Command:\nfind -L . -samefile ~/playground/task_11/file1 | xargs -exec rm\n"
    echo -e "Output:"
    find -L . -samefile ~/playground/task_11/file1 | xargs -exec rm
    tree
    rm -r ../"$1"
fi
#subtask№12
if [ "$1" = "task_12" ]
    then
        mkdir "$1"
        touch ~/playground/"$1"/file{1..5}
        find ./"$1" -type f -print0 | xargs -0 chmod 600
        ls -l "$1"
    echo -e "\nTask Description:\nChange permmission recursivly in a specific directory.\n"
    echo -e "Command:\nfind ./test -type f -print0 | xargs -0 chmod 644\n"
    echo -e "Output:"
    find ./"$1" -type f -print0 | xargs -0 chmod 664
    ls -l "$1"
    rm -r ./"$1"
fi
#subtask№13
#
#subtask№14
if [ "$1" = "task_14" ]
    then

    echo -e "\nTask Description:\nGet network interfases MAC-addresses.\n"
    echo -e "Command:\narp -a | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'\n"
    echo -e "Output:\n"
    arp -a | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
    echo -e "Command:\nifconfig | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'\n
cat /sys/class/net/*/address"
    echo -e "Output:\n"
    ifconfig | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
    cat /sys/class/net/*/address
fi
#subtask№15
if [ "$1" = "task_15" ]
    then

    echo -e "\nTask Description:\nDisplay list of the current logged in users\n"
    echo -e "who | cut -d ' ' -f1 | sort | uniq\n"
    echo -e "Output:\n"
    who | cut -d ' ' -f1 | sort | uniq
fi
#subtask№16
if [ "$1" = "task_16" ]
    then

    echo -e "\nTask Description:\nDisplaying all active Internet connections\n"
    echo -e "Command:\nnetstat -natp\n"
    echo -e "Output:\n"
    netstat -natp
    echo -e "Command:\nss\n"
    echo -e "Output:\n"
    ss
fi
#subtask№17
if [ "$1" = "task_17" ]
    then
        mkdir "$1"
        cd "$1"
            mkdir test
            head -c 4MB /dev/urandom > file1
            head -c 4MB /dev/urandom > file2
            ln -s ~/playground/"$1"/file1 /home/vagrant/playground/"$1"/test/symlink
            ln -s ~/playground/"$1"/file1 /home/vagrant/playground/"$1"/test/file1_symlink
        tree
    echo -e "\nTask Description:\nReasign existing symbolic link\n"
    echo -e "Command:\nln -sfn ~/playground/"$1"/file2 ~/playground/"$1"/test/file1_symlink \n"
    echo -e "Output:\n"
    ln -sfn ~/playground/"$1"/file2 ~/playground/"$1"/test/file1_symlink
    tree
    rm -r ../"$1"
fi
#subtask№18
if [ "$1" = "task_18" ]
    then
        mkdir "$1"
        cp list18 ./"$1"/
        cd "$1"
            mkdir dir dir_link
            for i in {1..5}
                do
                   head -c "$i"MB /dev/urandom > ./dir/file"$i"
                done
    echo -e "\nTask Description:\nThere is a list of files with a relative path and a path to the directory in which
a symbolic link to the file is stored. Create symbolic links to these files.\n"
    cat ./list18
    echo -e "Command:\nln -s -r \$(cut list18 -d: -f 1 | head -1| tail -1) \$(cut list18 -d: -f 2 | head -1| tail -1)\n"
    echo -e "Output:\n"
    for x in {1..5}
        do
            ln -s -r $(cut list18 -d " " -f 1 | head -"$x"| tail -1) $(cut list18 -d " " -f 2 | head -"$x"| tail -1)
        done
    tree
    rm -r ../"$1"
fi
#subtask№19
if [ "$1" = "task_19" ]
    then
        mkdir "$1"
        cd "$1"
            mkdir source_dir destination
            for i in {1..5}
                do
                   head -c "$i"MB /dev/urandom > ./file"$i"
                   ln -s ~/playground/"$1"/file"$i" ~/playground/"$1"/source_dir/symblink"$i"
                done
        cd source_dir
            for x in {1..5}
                do
                   ln -s ../file"$x" ~/playground/"$1"/source_dir/relative_symblink"$x"
                done
        cd ..
        echo -e "\nTask Description:\nCopy a directory, where are located both relative and direct symbolic links. Do it without rsync.\n"
        tree
    echo -e "Command:\ncp -R source_dir ./destination/\n"
    echo -e "Output:\n"
        cp -R source_dir ./destination/
        tree
        rm -r ../"$1"
fi
#subtask№20
if [ "$1" = "task_20" ]
    then
        mkdir "$1"
        cd "$1"
            mkdir source_dir destination
            for i in {1..5}
                do
                   head -c "$i"MB /dev/urandom > ./file"$i"
                   ln -s ~/playground/"$1"/file"$i" ~/playground/"$1"/source_dir/symblink"$i"
                done
        cd source_dir
            for x in {1..5}
                do
                   ln -s ../file"$x" ~/playground/"$1"/source_dir/relative_symblink"$x"
                done
        cd ..
        echo -e "\nTask Description:\nCopy with rsynk directory, where are located both relative and direct symbolic links.\n"
        tree
         echo -e "Command:\nrsync -avhK ./sour ./dest\n"
        rsync -avhK ./source_dir ./destination
        tree
        rm -r ../"$1"
fi
#subtask№21
if [ "$1" = "task_21" ]
    then
        mkdir "$1"
        cd "$1"
            mkdir source_dir destination
            for i in {1..5}
                do
                   head -c "$i"MB /dev/urandom > ./source_dir/file"$i"
                done
        echo -e "\nTask Description:\nCopy all files and directories from the specified directory to a new location with preservation of attributes and rights.\n"
        ls -l ./source_dir
        echo -e "Command:\ncp -Rp\n"
        cp -R ./source_dir/. ./destination
        ls -l ./destination
        rm -r ../"$1"
fi
#subtask№22
if [ "$1" = "task_22" ]
    then
        mkdir "$1"
        cd "$1"
            mkdir dir_link files_dir
            for i in {1..5}
                do
                   head -c "$i"MB /dev/urandom > ./files_dir/file"$i"
                   ln -s -r ./files_dir/file"$i" ./dir_link/relative_symblink"$i"
                done
        echo -e "\nTask Description:\nIn the current directory transfer all relative links to direct links.\n"
        tree
    echo -e "Command:\nfind ./ -type l -execdir bash -c 'ln -sfn \"\$(readlink -f \"\$0\")\" \"\$0\"' {} \;\n"
    echo -e "Output:\n"
        find ./ -type l -execdir bash -c 'ln -sfn "$(readlink -f "$0")" "$0"' {} \;
        tree
        rm -r ../"$1"
fi
#subtask№23
if [ "$1" = "task_23" ]
    then
        mkdir "$1"
        cd "$1"
            mkdir dir_link files_dir
            for i in {1..5}
                do
                   head -c "$i"MB /dev/urandom > ./files_dir/file"$i"
                   ln -s ~/playground/"$1"/files_dir/file"$i" ~/playground/"$1"/dir_link/symblink"$i"
                done
        echo -e "\nTask Description:\nfind . -type l -exec bash -c  'ln -sfr {} \$(dirname {})/' \;\n"
        tree
        echo -e "Command:\\n"
        find . -type l -exec bash -c  'ln -sfr {} $(dirname {})/' \;
        tree
        rm -r ../"$1"
fi
#subtask№24
if [ "$1" = "task_24" ]
    then
        mkdir "$1"
        cd "$1"
            mkdir dir_link files_dir
            for i in {1..5}
                do
                   head -c "$i"MB /dev/urandom > ./files_dir/file"$i"
                   ln -s ~/playground/"$1"/file"$i" ~/playground/"$1"/dir_link/symblink"$i"
                done
        echo -e "\nTask Description:\nFind all broken links and remove them\n"
        tree
        echo -e "Command:\nfind . -type l -exec sh -c 'for x; do [ -e \"\$x\" ] || rm \"\$x\"; done' _ {} +\n"
        find . -type l -exec sh -c 'for x; do [ -e "$x" ] || rm "$x"; done' _ {} +
        tree
        rm -r ../"$1"
fi
#subtask№25
if [ "$1" = "task_25" ]
    then
        mkdir "$1"
        cd "$1"
            mkdir  files \
                   archives \
                   unpacked \
                   unpacked/archive_tar \
                   unpacked/archive_gz \
                   unpacked/archive_bzip2 \
                   unpacked/archive_lzma \
                   unpacked/archive_xz \
                   unpacked/archive_zip
            cd files
                for i in {1..5}
                    do
                        head -c "$i"MB /dev/urandom > ./file"$i"
                    done
    echo -e "\nTask Description:\nUnpack from a tar, gz, bz2, lzma, xz, zip archives specify files or directory
    to the specified directory.\n"
        echo -e "Command:
           tar -cf ../archives/archive.tar .
           tar -xvf ../archives/archive.tar -C ../unpacked/archive_tar/ ./file2
           tar -czf ../archives/archive.tar.gz .
           tar -xzf ../archives/archive.tar.gz -C ../unpacked/archive_gz ./file2
           tar -cjf ../archives/archive.tar.bz2 .
           tar -xjf ../archives/archive.tar.bz2 -C ../unpacked/archive_bzip2 ./file2
           tar -caf ../archives/archive.tar.lzma .
           tar -xaf ../archives/archive.tar.lzma -C ../unpacked/archive_lzma ./file2
           tar -cJf ../archives/archive.tar.xz .
           tar -xJf ../archives/archive.tar.xz -C ../unpacked/archive_xz ./file2
           zip -jr ../archives/archive.zip .
           unzip -j ../archives/archive.zip file2 -d ../unpacked/archive_zip\n"
           tar -cf ../archives/archive.tar .
           tar -xf ../archives/archive.tar -C ../unpacked/archive_tar/ ./file2
           tar -czf ../archives/archive.tar.gz .
           tar -xzf ../archives/archive.tar.gz -C ../unpacked/archive_gz ./file2
           tar -cjf ../archives/archive.tar.bz2 .
           tar -xjf ../archives/archive.tar.bz2 -C ../unpacked/archive_bzip2 ./file2
           tar -caf ../archives/archive.tar.lzma .
           tar -xaf ../archives/archive.tar.lzma -C ../unpacked/archive_lzma ./file2
           tar -cJf ../archives/archive.tar.xz .
           tar -xJf ../archives/archive.tar.xz -C ../unpacked/archive_xz ./file2
           zip -jr ../archives/archive.zip .
           unzip -j ../archives/archive.zip file2 -d ../unpacked/archive_zip
        cd ..
        tree
        rm -r ../task_25
fi
#subtask№26
if [ "$1" = "task_26" ]
    then
    echo -e "\nTask Description:Preserve permissions and attributes  while compressing a directories.\n"
    echo -e "\nConten of the /home/user_task26/task_26/ directory:\n"
        sudo ls -l /home/user_task26/task_26
        mkdir "$1"
        cd "$1"
        echo -e "\nArchiving and extract files by commands:\n"
            echo -e "Command:
            sudo tar -cf task_26.tar /home/user_task26/task_26 --same-owner
            sudo tar -xf task_26.tar --same-owner"
            sudo tar -cf task_26.tar /home/user_task26/task_26 --same-owner
            sudo tar -xf task_26.tar --same-owner
   echo -e "\nExtracted files with the same attributes:\n"
            ls -l home/user_task26/task_26
        sudo rm -r ../"$1"
fi
#subtask№27
if [ "$1" = "task_27" ]
    then
        mkdir "$1" && cd $_
        mkdir main_directory && cd $_
    echo -e "\nTask Description:\nRecursively copy the directory structure (without contents) from the specified directory.\n"
        for i in {1..5}
            do
            mkdir dir"$i"
                for x in {1..5}
                    do
                        head -c "$x"MB /dev/urandom > ./dir"$i"/file"$x"
                    done
            done
        cd ..
    echo -e "Command:\nfind . -type d | xargs -I{} mkdir -p \"./copied_dir/{}\"\n"
        find . -type d | xargs -I{} mkdir -p "./copied_dir/{}"
        echo -e "Output:\n"
        tree
        rm -r ../"$1"
fi
#subtask№28
if [ "$1" = "task_28" ]
    then
        mkdir "$1" && cd $_
    echo -e "\nTask Description:\nDisplay all users (names only) in alphabetical order\n"
    echo -e "Command:\ncut -d \":\" -f1 /etc/passwd | sort\n"
    echo -e "Output:\n"
    cut -d ":" -f1 /etc/passwd | sort
    rm -r ../"$1"
fi
#subtask№29
if [ "$1" = "task_29" ]
    then
        mkdir "$1" && cd $_
    echo -e "\nTask Description:\nDisplay a list of all system users of the system sorted by id, in the format: "login ID", sorted by ID.\n"
    echo -e "Command:\ncat /etc/passwd | grep -oP '\w+:x:[2-9]\d\d' | cut -d \":\" -f 1,3 | sort -t \":\" -k2.1\n"
    echo -e "Output:\n"
    cat /etc/passwd | grep -oP '\w+:x:[2-9]\d\d' | cut -d ":" -f 1,3 | sort -t ":" -k2.1
    rm -r ../"$1"
fi
#subtask№30
if [ "$1" = "task_30" ]
    then
        mkdir "$1" && cd $_
    echo -e "\nTask Description:\Display a list of all system users of the system sorted by ID in reverse order.\n"
    echo -e "Command:\ncat /etc/passwd | grep -oP '\w+:x:[2-9]\d\d' | cut -d \":\" -f 1,3 | sort -r -t \":\" -k2.1 | cut -d ":" -f1\n"
    echo -e "Output:\n"
    cat /etc/passwd | grep -oP '\w+:x:[2-9]\d\d' | cut -d ":" -f 1,3 | sort -rt ":" -k2.1 | cut -d ":" -f1
    rm -r ../"$1"
fi
#subtask№31
if [ "$1" = "task_31" ]
    then
        mkdir "$1" && cd $_
    echo -e "\nTask Description:\nDisplay all users who do not have the rights to log in the system.\n"
    echo -e "Command:\nsudo cat /etc/shadow | grep -E \"\w+:\*|!\"\n"
    echo -e "Output:\n"
    sudo cat /etc/shadow | grep -E "\w+:\*|!" | cut -d ":" -f1
    rm -r ../"$1"
fi
#subtask№32
if [ "$1" = "task_33" ]
    then
        mkdir "$1" && cd $_
    echo -e "\nTask Description:\nList all users who have or doesn't have a terminal (bash, sh, zsh and etc).\n"
    echo -e "Command:\ncat /etc/passwd | grep -e '/bash' -e '/zsh' -e '/usr/bin/sh' | cut -d \":\" -f1
cat /etc/passwd | grep -v -e '/bash' -e '/zsh' -e '/usr/bin/sh' | cut -d \":\" -f1\n"
    echo -e "Output:\n"
    cat /etc/passwd | grep -e '/bash' -e '/zsh' -e '/usr/bin/sh' | cut -d: -f 1
    echo "================================================================================"
    cat /etc/passwd | grep -v -e '/bash' -e '/zsh' -e '/usr/bin/sh' | cut -d: -f 1
    rm -r ../"$1"
fi
#subtask№33
if [ "$1" = "task_33" ]
    then
        mkdir "$1" && cd $_
    echo -e "\nTask Description:\nFrom the page from the Internet, download all links to href resources that are on the page.\n"
    echo -e "Command:\ncurl -sS https://tomcat.apache.org/download-90.cgi |  grep -Po 'href=\"\K.*?(?=\")' | tail -5 | xargs wget {} \;\n"
    echo -e "Output:\n"
    curl -sS https://tomcat.apache.org/download-90.cgi |  grep -Po 'href="\K.*?(?=")' | tail -5 | xargs wget {} \;
    ls -l
    rm -r ../"$1"
fi
#subtask№34
if [ "$1" = "task_34" ]
    then
    echo -e "\nTask Description:\nStop the processes which work more than 5 days. Using by killall and without the killall command.\n"
    echo -e "Command:\nkillall --older-than 5d $proc_name
--------------------------------------------------------------------------------------------
find /proc -user myuser -maxdepth 1 -type d -mtime +5 -exec basename {} \; | xargs kill -9\n"
fi
#subtask№35
if [ "$1" = "task_35" ]
    then
        mkdir "$1" && cd $_
        sh ../task35.sh
    echo -e "\nTask Description:\nThere are files and directories (*.txt & *.jpeg). Files *.txt и *.jpeg
connected with each othere unambiguously. Files can be in different places of this directory.
Need to delete all *.jpeg for which there is no *.txt file.
\n"
    tree
    echo -e "Command:\nfind . \( -name '*.txt' -o -name '*.jpeg' \) -printf '%f\'n'' |
 cut -d \".\" -f1 | sort | uniq -u | xargs -I{} find . -name '{}.jpeg' | xargs rm -v\n"
    echo -e "Output:\n"
    find . \( -name '*.txt' -o -name '*.jpeg' \) -printf '%f\n' | cut -d "." -f1 \
            | sort | uniq -u | xargs -I{} find . -name '{}.jpeg' | xargs rm -v
    tree
    rm -r ../"$1"
fi
#subtask№36
if [ "$1" = "task_36" ]
    then
    echo -e "\nTask Description:\nFind your IP address using the command line.\n"
    echo -e "Command:\nip a | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'\n"
    echo -e "Output:\n"
    ip a | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
fi
#subtask№37
if [ "$1" = "task_37" ]
    then
            cat ip_list | head
    echo -e "\nTask Description:\nGet all IP addresses from file.\n"
    echo -e "Command:\ngrep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ip_list\n"
    echo -e "Output:\n"
    grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ip_list
fi
#subtask№38
if [ "$1" = "task_38" ]
    then
    echo -e "\nTask Description:\nGet all active hosts in current network\n"
    echo "Command:\nseq 254 | xargs printf \"192.168.0.%s\n\" | xargs -P0 -n1 ping -q -c1 |
  grep -B1 \"0% packet loss\" | grep -B1 \" 0% packet loss\" |
  grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'\n"
    echo -e "Output:\n"
    seq 254 | xargs printf "192.168.0.%s\n" | xargs -P0 -n1 ping -q -c1 \
            | grep -B1 " 0% packet loss" | grep -B1 " 0% packet loss" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
fi
#subtask№39
if [ "$1" = "task_39" ]
    then
    echo -e "\nTask Description:\nUsing nMap get all active hosts in current network and from list of IP.\n"
    echo -e "Command:\nnmap  -sn  192.168.0.1/24\n"
    echo -e "Output:\n"
    nmap  -sn  192.168.0.1/24
    echo -e "Command:\nnmap -F -iL ip_list_38 192.168.0.0/24\n"
    echo -e "Output:\n"
    nmap -F -iL list_ip_39 192.168.0.0/24
fi
#subtask№40
if [ "$1" = "task_40" ]
    then
    echo -e "\nTask Description:\nGet all subdomain from SSL certificate\n"
    echo -e "Command:\necho | openssl s_client -connect google.com:443 | openssl x509 -noout -text| grep -Po '?<=DNS:).+?(?=, )'\n"
    echo -e "Output:\n"
    sub_domain=$(openssl s_client -connect google.com:443 | openssl x509 -noout -text| grep -Po '?<=DNS:).+?(?=, )')
    echo "$sub_domain"
fi

















