#!/bin/bash
#

current_dir=`pwd`
auto_gen_dir="$current_dir/auto_gen"

function init()
{
    if [ ! -d $HOME"/.ssh" ]; then
        mkdir $HOME"/.ssh"
    fi
    if [ ! -d $auto_gen_dir ]; then
        mkdir $auto_gen_dir
    fi

    #todo: meger ssh_config
    cp -f files/ssh_config $HOME/.ssh/ssh_config
    chmod 400 $HOME/.ssh/ssh_config
}

function set_alias()
{
    local bashrc=$HOME/.bashrc
    local alias_key=$1
    local file=$2
    #todo:  make alias take effect instantly
    if ! grep -q "alias $alias_key=" $bashrc; then
        cmd="alias $alias_key=$file"
        echo $cmd >> $bashrc
    fi
}
