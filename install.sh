#!/bin/bash
#
shopt -s expand_aliases

if [ ! $# -eq 4 ]; then
    echo "Usage: sh $0 short_cut_command host_name user_name password"
    echo "exsample: sh $0 to_pre host_name huqiu Flzx3qc"
    exit;
fi

bashrc=$HOME/.bashrc
current_dir=`pwd`
auto_gen_dir="$current_dir/auto_gen"
if [ ! -d $HOME"/.ssh" ]; then
    mkdir $HOME"/.ssh"
fi
if [ ! -d $auto_gen_dir ]; then
    mkdir $auto_gen_dir
fi

#todo: meger ssh_config
cp -f files/ssh_config ~/.ssh/ssh_config
chmod 400 ~/.ssh/ssh_config

command=$1
ip=$2
user_name=$3
password=$4
pre_passcode=$5

auto_login_file_path="$auto_gen_dir/$command.sh"

cat >$auto_login_file_path  <<EOF
#!/bin/bash
host="$ip"
user_name="$user_name"
password="$password"
cd $current_dir/files
./auto_login.sh \$host \$user_name \$password
EOF
chmod u+x $auto_login_file_path

#todo:  make alias take effect instantly
if ! grep -q "alias $command" $bashrc; then
    cmd="alias $command=$auto_gen_dir/$command.sh"
    echo $cmd >> $bashrc
fi
