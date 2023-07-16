#!/bin/bash
# Script to be run as insight user with sudo privillages

BASE_DIR=/sftp/
CHROOT_GRP=mpesa-files

username_input=$1
password=$2
username=SP$username_input

if [ -z "$1" ]; then
    echo "Username input is null!" && exit 1
fi

if [ -z "$2" ]; then
    echo "Password input is null!" && exit 1
fi

[ ! -d "$BASE_DIR" ] && sudo mkdir -p $BASE_DIR

egrep "^$CHROOT_GRP" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
    sudo groupadd $CHROOT_GRP
fi

egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
    echo "$username exists!"
    exit 1
else
    HOME_DIR=$BASE_DIR$username/home
    WORKING_DIR=$HOME_DIR/working
    BACKUP_DIR=$HOME_DIR/backup
    sudo useradd -p $(openssl passwd -1 "$password") $username
    sudo mkdir -p $BACKUP_DIR $WORKING_DIR
    sudo chmod -R 755 $BASE_DIR$username/
    sudo usermod -aG $CHROOT_GRP $username
    sudo chown -R $username:$CHROOT_GRP $HOME_DIR/
    sudo chmod -R 757 $BASE_DIR$username/*
    sudo setfacl -dRm u:$username:rwX,g:$CHROOT_GRP:r-X $HOME_DIR/
    if [ $? -eq 0 ]; then
        echo "User successfully created."
        exit 0
    else
        echo "Failed. Error creating user $username"
        exit 1
    fi
fi