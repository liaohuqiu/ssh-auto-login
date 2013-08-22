#!/bin/bash
#
if [ ! $# -eq 5 ]; then
    echo "Usage: sh $0 short_cut_command host_name user_name password"
    echo "exsample: sh $0 to_pre host_name huqiu Flzx3qc"
    exit;
fi
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
fi
current_dir=`pwd`
auto_gen_dir="$current_dir/auto_gen"
cp -f files/ssh_config ~/.ssh/ssh_config
chmod 400 ~/.ssh/ssh_config

command=$1
ip=$2
user_name=$3
password=$4
pre_passcode=$5

cat > "$auto_gen_dir/$command.sh" <<EOF
#!/bin/bash
host="$ip"
user_name="$user_name"
password="$password"
prePASSCODE="$pre_passcode"
cd $current_dir/files
./auto_login.sh \$host \$user_name \$password \$prePASSCODE
EOF
chmod u+x $command.sh

if ! grep -q "alias $command" ~/.bashrc; then
    echo alias $command="$auto_gen_dir/$command.sh" >> ~/.bashrc
fi
