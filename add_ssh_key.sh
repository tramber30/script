#!/bin/bash

source ~/local_variable.sh
source ${UTILITY_PATH}


# KEY_PATH basicaly your ~/.ssh folder
KEY_NB=1
KEY_LIST="github_ed25519"

check_var KEY_PATH

debug "in add_ssh_key"

eval `ssh-agent`

for i in $KEY_LIST
do
	debug $KEY_PATH/$i
	ssh-add $KEY_PATH/$i
done
