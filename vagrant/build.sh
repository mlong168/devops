#!/bin/bash

set -x

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

if [ ! -d "$AA_DEV_PATH" ]; then
    vagrant plugin install vagrant-salt
    exit_if_failed "install vagrant-salt"
    vagrant plugin install vagrant-vbguest
    exit_if_failed "install vagrant-vbguest"
    
    echo "Please input box file location."
    read BOX_FILE_PATH
    
    vagrant box add $BOX_NAME $BOX_FILE_PATH
    exit_if_failed "add vagrant box"
    
    git clone $CONFIG_GIT_REPO $AA_DEV_PATH
    exit_if_failed "clone config repo from git"

    cd $AA_VAGRANT_PATH
    echo "Please input your local aa repository path"
    read AA_REPO_PATH
    echo "local_aa_repo_file=\"$AA_REPO_PATH\"" > Vagrantfile
    echo "" >> Vagrantfile
    cat Vagrantfile.tpl >> Vagrantfile

    vagrant up
else
    vagrant up --no-provision
fi
