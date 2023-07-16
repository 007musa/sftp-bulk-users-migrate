#!/bin/bash

BASE_DIR=/sftp/
username=SP$1

#for user in SP007 SP008 SP009 SP010 SP1110 SP2939 SP3300 SP33445 SP5500 SP5550 SP77889 SP8761 SP99771
#do
#username=$user

egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
    sudo userdel -r $username
    if [ $? -eq 0 ]; then
        sudo rm -r $BASE_DIR$username/
        [ $? -eq 0 ] && echo "User has been successfully deleted on system!" || echo "User Delete. Error removing user files in Base Directory!"
    else
        echo "Failed to delete user!"
        exit 1
    fi
else
    echo "$username does not exist!"
    exit 1
fi