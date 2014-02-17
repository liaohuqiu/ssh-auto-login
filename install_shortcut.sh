#!/bin/bash
#

if [ ! $# -eq 4 ]; then
    echo "Usage: sh $0 alias_key host_name user_name password"
    echo "exsample: sh $0 to_pre host_name wuxiu Flzx3qc"
    return;
fi

. ./base.sh

init

alias_key=$1
host=$2
user_name=$3
password=$4

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
