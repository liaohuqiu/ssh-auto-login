#!/bin/bash
#

#if [ $BASH_SOURCE == $0 ]; then
#    echo "Please use source command to run this script."
#    exit;
#fi

if [ ! $# -eq 2 ]; then
    echo "Usage: sh $0 alias_key user_name@host_name"
    echo "exsample: sh $0 to_pre wuxiu@host_name"
    exit
fi

. ./base.sh

init

alias_key=$1
uri=$2

uri_componet=(${uri//@/ })

host=${uri_componet[1]}
user_name=${uri_componet[0]}

read -sp "Please input your password for $user_name@$host:" password

echo

work_script_file_path="$auto_gen_dir/$alias_key.sh"

cat >$work_script_file_path  <<EOF
#!/bin/bash
host="$host"
user_name="$user_name"
password="$password"
cd $current_dir/files
./auto_login.sh \$host \$user_name \$password
EOF

chmod u+x $work_script_file_path
set_alias $alias_key $work_script_file_path
