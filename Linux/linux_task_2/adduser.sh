#!/bin/bash
# This script implements next things:
# Grant access to the user to read file /var/log/messages without
# using SUDO for the permission;
# ask password changing when the 1st user login;
# deny executing ‘sudo su -’ and ‘sudo -s’;


# Create flags
while getopts u:p: flag
do
    case "${flag}" in
        u) user=${OPTARG};; # create user
        p) pass=${OPTARG};; # limit password reuse N-time
    esac
done

# Create user
if id "$user" &>/dev/null; then
    echo 'user found'
else
    # Crypt user password
    password=$(perl -e 'print crypt($ARGV[0], "pass")' $pass)
    useradd -m -p "$password" "$user"
    usermod -aG wheel "$user"
    # Force to change password when user has the first logging
    passwd -e "$user"
    # Deny executing sudo -su, sudo -s

    tee -a /etc/sudoers.d/"$user" << END
# Sudoers "$user" settings

$user         ALL=(ALL:ALL) !SU, !SHELLS
$user         ALL=(ALL) NOPASSWD: /usr/sbin/iptables

END

    cat <<EOT >> /home/"$user"/.bashrc
alias iptable='sudo iptables -L -n -v'
EOT
fi
# Grant access to the user to read file /var/log/messages
# without using SUDO for the permission.
setfacl -m u:"$user":r /var/log/messages
