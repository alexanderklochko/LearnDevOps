#!/bin/bash
# This script implements next things:
# Lock user and send him notification to the email
set -x
# Create flags
while getopts u:m: flag
do
    case "${flag}" in
        u) user=${OPTARG};;     # set user
        m) mail=${OPTARG};;     # set user email
    esac
done

if id "$user" &>/dev/null; then
    sudo usermod -L "$user"
    # Check for the flag *LK* in the below command output
    # which indicates that the account is locked.
    status=$(sudo passwd --status "${user}")
    if [[ $status == *"LK"* ]]; then
        sudo curl --ssl-reqd \
                  --url 'smtps://smtp.gmail.com:465' \
                  --mail-from 'oleksandriyskiy@gmail.com' \
                  --netrc-file '/home/vagrant/.netrc' \
                  --mail-rcpt "${mail}" \
                  --upload-file mail.txt
    fi

fi




