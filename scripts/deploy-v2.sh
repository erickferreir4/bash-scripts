#!/bin/bash

####################################
#
# ./deploy.sh watch
#
# - watch files modification to deploy in server
#
####################################

####################################
#
# ./deploy.sh all n
#
# - deploy files last n hours
#
####################################

####################################
#
# ./deploy.sh config
#
# - config ssh and root server
#
####################################

####################################
#
# ./deploy.sh
#
# - deploy all files in server
#
####################################


#
# Create config to deploy
#
create_config()
{
	read -p "SSH: " SSH
	echo "SSH='$SSH'" > deploy_config.sh

	read -p "ROOT: " ROOT
	echo "ROOT='$ROOT'" >> deploy_config.sh

	chmod ugo=r deploy_config.sh
}

#
# Check has config deploy
#
check_config () 
{
	FILES=$(find . -name "deploy_config.sh" -type f)

	if [ ! -f "$FILES" ]; then
		create_config
	fi

	source deploy_config.sh
}

#
# Deploy files in server
#
deploy_files()
{
	echo

	DIR=$( echo $file | grep -o "[^/].*/" | grep -o "[^.].*" )

	ssh $SSH "[ ! -d $ROOT$DIR ] && mkdir -p $ROOT$DIR"

	echo $ROOT$DIR
	scp $file "$SSH:$ROOT$DIR"
}

#
# Watch files modification
#
listening_files()
{

	sleep 2 

	SYS=$(uname)
	
	if [ $SYS = 'Linux' ];then
		FILES_MODIFY=$(find . -mmin 0.05)
	else
		FILES_MODIFY=$(find . -mtime -5s)
	fi


	for file in $FILES_MODIFY; do
		if [ -f $file ];then
			deploy_files
		fi
	done

	listening_files
}

#
# Deploy all files option
#
all()
{
	if [ -z $TIME ]; then
		FILES_MODIFY=$(find . -name "*" -type f)
	else
		FILES_MODIFY=$(find . -cmin $TIME)
	fi

	for file in $FILES_MODIFY; do
		if [ -f $file ];then
			deploy_files
		fi
	done
}


#
# Main program
#
main()
{
	check_config	

	echo
	echo "ssh: $SSH"
	echo "root: $ROOT"
	echo

	if [ "$1" = 'watch' ]; then
		echo 'listening...'
		listening_files

	elif [ "$1" = 'config' ]; then
		chmod ugo=rw deploy_config.sh
		create_config

	elif [ "$1" = 'all' ] && [ "$2" -gt 0 ]; then
			TIME=$2
			all $TIME

	elif [ -z "$1" ]; then
		all
	else
		echo 'invalid command line'
	fi
}

main $1 $2


