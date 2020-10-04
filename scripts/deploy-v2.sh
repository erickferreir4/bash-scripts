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

	if [ "$1" = '' ]; then

		FILES_MODIFY=$(find . -newer .deploy_config -type f)

		if [ "$FILES_MODIFY" = '' ]; then
			echo "no files modified for deployment"
		else
			echo "deployng files modified"
		fi

		touch .deploy_config

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
	fi


	#if [ "$1" = 'watch' ]; then
	#	echo 'listening...'
	#	listening_files

	#elif [ "$1" = 'config' ]; then
	#	chmod ugo=rw deploy_config.sh
	#	create_config
	#elif [ "$1" = 'all' ]; then
	#	all
	#elif [ -z "$1" ]; then
	#	all $TIME
	#else
	#	echo 'invalid command line'
	#fi
}

main $1


