#!/bin/bash
#

if [ ! $# -eq 2 ]; then
    echo "Usage: sh $0 user_name password"
    echo "exsample: sh $0 username password"
    return;
fi

. ./base.sh

init

user_name=$1
password=$2

alias_key='to'
work_script_file_path="$auto_gen_dir/$alias_key.sh"

#build script
cat >$work_script_file_path  <<EOF
#!/bin/bash

if [ ! \$# -eq 1 ]; then
    echo "Usage: to hostname"
    exit;
fi

host=\$1
user_name="$user_name"
password="$password"
cd $current_dir/files
./auto_login.sh \$host \$user_name \$password
EOF
chmod u+x $work_script_file_path

set_alias $alias_key $work_script_file_path
