#!/bin/bash
#

current_dir=`pwd`
auto_gen_dir="$current_dir/auto_gen"

function exe_cmd()
{
    echo $1
    eval $1
}

function init()
{
    if [ ! -d $HOME"/.ssh" ]; then
        mkdir $HOME"/.ssh"
    fi
    if [ ! -d $auto_gen_dir ]; then
        mkdir $auto_gen_dir
    fi

    #todo: merge ssh_config
    local ssh_config="$HOME/.ssh/config"
    local ssh_config_sample="$current_dir/files/ssh_config"

    if [ ! -f $ssh_config ]; then 
        exe_cmd "cp -rf $ssh_config_sample $ssh_config"
    else
        local config_content="\n"`cat $ssh_config_sample`
        exe_cmd 'change_line append $ssh_config "ControlPath" "$config_content"';
    fi
    chmod 600 $ssh_config
}

function set_alias()
{
    #TODO exe_cmd "ln -sf $1 $2"
    local bashrc=$HOME/.bash_profile
    local alias_key=$1
    local file=$2
    #todo:  make alias take effect instantly
    if ! grep -q "alias $alias_key=" $bashrc; then
        cmd="alias $alias_key=$file"
        echo $cmd >> $bashrc
    fi
}

# mode file tag_str content
function change_line() 
{
    local mode=$1
    local file=$2
    local tag_str=$3
    local content=$4
    local file_bak=$file".bak"
    local file_temp=$file".temp"
    cp -f $file $file_bak
    if [ $mode == "append" ]; then
        grep -q "$tag_str" $file || echo "$content" >> $file
    else
        cat $file |awk -v mode="$mode" -v tag_str="$tag_str" -v content="$content" '
        {
            if ( index($0, tag_str) > 0) {
                if ( mode == "after"){
                    printf( "%s\n%s\n", $0, content);

                } else if (mode == "before")
                {
                    printf( "%s\n%s\n", content, $0);

                } else if(mode == "replace") 
                {
                    print content;
                }
            } else if ( index ($0, content) > 0) 
            {
                # target content in line
                # do nothing
            } else
            {
                print $0;
            }
        }' > $file_temp
        mv $file_temp $file
    fi
}
