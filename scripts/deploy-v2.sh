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
# ./deploy.sh all
#
# - deploy all files
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
# - deploy files last time
#
####################################


#
# Create config to deploy
#
create_config()
{
	if [ -f ".deploy_config" ]; then
		chmod ugo=rw .deploy_config
		DATE_FILE=$(date -r .deploy_config)
	fi


	read -p "SSH: " SSH
	echo "SSH='$SSH'" > .deploy_config

	read -p "ROOT: " ROOT
	echo "ROOT='$ROOT'" >> .deploy_config

	chmod ugo=r .deploy_config


	if [ ! "$DATE_FILE" = '' ]; then
		touch -d "$DATE_FILE" .deploy_config
	fi
}

#
# Check has config deploy
#
check_config () 
{
	if [ ! -f ".deploy_config" ]; then
		create_config
	fi

	source .deploy_config
}

#
# Watch files modification
#
listening_files()
{
	sleep 2 

	FILES_MODIFY=$(find . -newer .deploy_config -type f)

	for file in $FILES_MODIFY; do
		if [ -f $file ];then
			deploy_files $file
		fi
	done

	listening_files
}

#
# Deploy files in server
#
deploy_files()
{
	echo

	DIR=$( echo $file | grep -o "[^/].*/" | grep -o "[^.].*" )

	ssh $SSH "[ ! -d $ROOT$DIR ] && mkdir -p $ROOT$DIR; exit" 2> deploy_error.log

	echo $ROOT$DIR
	scp $file "$SSH:$ROOT$DIR" 2> deploy_error.log


	touch deploy_error.log
	ERROR=$(cat deploy_error.log)

	if [ "$ERROR" = '' ]; then
		touch .deploy_config
	fi

}

#
# Deploy all files option
#
all()
{

	if [ "$1" = '' ]; then

		FILES_MODIFY=$(find . -newer .deploy_config -type f)

		if [ "$FILES_MODIFY" = '' ]; then
			echo "no files modified for deployment"
		else
			echo "deployng files modified"
		fi


	else 
		echo "deployng all files"
		FILES_MODIFY=$(find . -name "*" -type f)
	fi

	for file in $FILES_MODIFY; do
		if [ -f $file ];then
			deploy_files $file
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

	if [ "$1" = '' ]; then
		all 

	elif [ "$1" = 'all' ]; then
		all $1

	elif [ "$1" = 'config' ]; then
		create_config

	elif [ "$1" = 'watch' ]; then
		echo 'listening...'
		listening_files

	else
		echo 'invalid command line'

	fi
}


main $1


