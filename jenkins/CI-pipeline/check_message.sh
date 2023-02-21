#!/bin/bash
#set -x
# There is our commit message
RE="^[A-Z]+-[0-9]+"
MESS=$(git log -1 --pretty=%B)
echo -e "There is our commit message: \n "${MESS}""
# Check commit message for appropriate length and if the message start for Jira ticket
if [[ ${#MESS} -gt 50 ]];
        then
             echo "Commit message has appropriate lenght (not less than 50 characters)"
             if [[ ${MESS} =~ ${RE} ]];
                then
                echo "Commit message starts with Jira ticket"
                else
                echo "Commit message does not start with Jira ticket..."
                exit 1
                fi
        else
            echo "Commit message is too short..."
            exit 1
        fi
exit 0



