#!/bin/bash

#set -x

check_program() {
    i=0
    for program_name in $1; do
        type -P $program_name > /dev/null
        if [ $? -gt 0 ]; then
            echo $program_name " is needed."       
            i=`expr $i + 1`
        fi
    done

    return $i
}

exit_if_failed() {
    if [ $? -gt 0 ]; then
        echo "$1 failed, exit now."
    fi
}


NEEDED_PROGRAMS="git gcc vagrant VirtualBox ruby"

check_program "$NEEDED_PROGRAMS"

if [ $? -gt 0 ]; then
    echo "Please install all programs first(Recomending install xcode command line tools for gcc & git)."
    exit 1
fi

BOX_NAME="aa_dev"
CONFIG_GIT_REPO="https://github.com/zhangcheng/devops"
AA_DEV_PATH="$HOME/.aa_dev"
AA_VAGRANT_PATH=$AA_DEV_PATH/vagrant


FULL_ARGS=$@

for args in $FULL_ARGS; do
    if [ $args == 'up' ]; then
        UP_OPTION=1
    elif [ $args == 'update' ]; then
        UPDATE_OPTION=1
    fi
done

generate_vagrant_file() {
    cd $AA_VAGRANT_PATH
    echo -n "Please input your local aa repository path: "
    read AA_REPO_PATH
    echo "local_aa_repo_file=\"$AA_REPO_PATH\"" > Vagrantfile
    echo "" >> Vagrantfile
    cat Vagrantfile.tpl >> Vagrantfile
}

print_usage() {
    echo "========= Welcome ====================================================="
    echo "this scripts is actually an wrapper for vagrant, "
    echo "which means you can use all commands from vagrant."
    echo "FYI: if aa_dev updated, use 'aa_dev update' to update configuration"
    echo "======================================================================="
}

print_usage

if [ ! -z $UP_OPTION ]; then
    if [ ! -d "$AA_DEV_PATH" ]; then
        vagrant plugin install vagrant-salt
        exit_if_failed "install vagrant-salt"
        vagrant plugin install vagrant-vbguest
        exit_if_failed "install vagrant-vbguest"
        
        echo -n "Please input box file location: "
        read BOX_FILE_PATH
        
        vagrant box add $BOX_NAME $BOX_FILE_PATH
        exit_if_failed "add vagrant box"
        
        git clone $CONFIG_GIT_REPO $AA_DEV_PATH
        exit_if_failed "clone config repo from git"

        sudo ln -s $AA_VAGRANT_PATH/aa_dev.sh /usr/local/bin/aa_dev

        generate_vagrant_file
        cd $AA_VAGRANT_PATH
        vagrant up
    else
        cd $AA_VAGRANT_PATH
        vagrant up --no-provision
    fi
elif [ ! -z $UPDATE_OPTION ]; then
    echo -n "Update operation will halt vm first, do you want continue(y/n)?: "
    read yes_or_no
    if [ $yes_or_no == "n" -o $yes_or_no == "N" ]; then
        exit 1
    fi    
    cd $AA_DEV_PATH; git pull
    generate_vagrant_file
    cd $AA_VAGRANT_PATH
    vagrant halt
    vagrant up
else
    cd $AA_VAGRANT_PATH
    echo "vagrant $FULL_ARGS"
    vagrant $FULL_ARGS
fi
