#!/bin/bash
host=$1
user=$2
password=$3
file=$HOME"/.ssh/master-$user@$host:22"
if [ -e "$file" ]; then
    ssh $user@$host
else
    known_hosts=$HOME'/.ssh/known_hosts'
    save_RSA_key=''
    if [ -f $known_hosts ]; then
        if ! grep -q "$host" $known_hosts; then
            save_RSA_key='yes'
        fi
    fi
    ./auto_login.exp $host $user $password $save_RSA_key
fi
