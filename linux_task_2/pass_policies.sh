#!/bin/bash

# This script implements next things:
# - require password changing every 3 months;
# - it is not allowed to repeat 3 last passwords;

TAB=$(printf '\t')            # variable for inputing TAB substitution in /etc/login.defs file
DT=$(date '+%d%m%Y_%H:%M:%S') # variable for creating backup's names

# Do backap /etc/login.defs
sudo cp /etc/login.defs /root/login.defs"$DT".conf.bak

# Create flags
while getopts e:r: flag
do
    case "${flag}" in
        e) expiration=${OPTARG};; # PASS_MAX_DAYS
        r) pass_reuse=${OPTARG};; # limit password reuse N-time
    esac
done

# requiring change password $expiration time
sudo sed -i -e "s/PASS_MAX_DAYS[[:space:]]\?[0-9]\+/PASS_MAX_DAYS$TAB$expiration/" /etc/login.defs

# Do backap /etc/login.defs
sudo cp /etc/pam.d/system-auth /root/system-auth"$DT".conf.bak

# Do not allowed to repeat passwords $pass_reuse time
origin="^password *sufficient *pam_unix.so.+$"
result="password    sufficient                                   pam_unix.so use_authtok md5 shadow remember=$pass_reuse"

sudo sed -i -r "s/$origin/$result/" /etc/pam.d/system-auth




