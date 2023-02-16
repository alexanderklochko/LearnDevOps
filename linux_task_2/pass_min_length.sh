#!/bin/bash
# This script implements next things:
# - set user’s password length N characters;
# - set number up case, low case, number digit and special chars;
# - prevent accidental removal of the /var/log/secure

DT=$(date '+%d%m%Y_%H:%M:%S') # variable date for creating backup's names 

#Create flags
while getopts l:d:o:u: flag
do
    case "${flag}" in
        l) len=${OPTARG};;            # password min_length
        d) digit_char=${OPTARG};;     # max numbers of digit in the password
        o) other_char=${OPTARG};;     # min numbers of other char in the password
        u) uppercase_char=${OPTARG};; # min numbers of the uppercase char in the password 
    esac
done

#Do backap /etc/security/pwquality.conf
sudo cp /etc/security/pwquality.conf /root/pwquality"$DT".conf.bak

# Set minimal password length
if [[ "$len" -ge 6 ]] && [[ "$len" -le 12 ]]
    then
        sudo sed -i -e "s/^#\? \?minlen = [0-9]\+/minlen = $len/" /etc/security/pwquality.conf
else
        echo "It's inappropriate values for minimal length of password. Try numbers from 6 to 12"
        exit 1
fi

    sudo sed -i -e "s/^#\? \?dcredit = -\?[0-9]\+/dcredit = $digit_char/" /etc/security/pwquality.conf
    sudo sed -i -e "s/^#\? \?ocredit = -\?[0-9]\+/ocredit = $other_char/" /etc/security/pwquality.conf
    sudo sed -i -e "s/^#\? \?ucredit = -\?[0-9]\+/ucredit = $uppercase_char/" /etc/security/pwquality.conf

# prevent accidental removal
sudo chattr +i /var/log/secure
