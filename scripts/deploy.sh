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
	else
		echo -e ".git\n.deploy_config\n/node_modules\npackage-lock.json\ndeploy_error.log" > .deployignore
	fi


	read -p "SSH: " SSH
	echo "SSH='$SSH'" > .deploy_config

	read -p "ROOT: " ROOT
	echo "ROOT='$ROOT'" >> .deploy_config

	chmod ugo=r .deploy_config


	if [ ! "$DATE_FILE" = '' ]; then
		touch -d "$DATE_FILE" .deploy_config
	fi

	exit
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

	DIR=$( echo $file | grep -o "[^/].*/" | grep -o "[^.].*" )

	FILES_IGNORE=$(cat .deployignore)

	for ignore in $FILES_IGNORE; do
		if [[ "$file" =~ "$ignore" ]]; then
			return 1
		fi
	done


	echo 

	ssh $SSH "[ ! -d $ROOT$DIR ] && mkdir -p $ROOT$DIR" 2> deploy_error.log

	echo $ROOT$DIR
	scp $file "$SSH:$ROOT$DIR" 2> deploy_error.log


	touch deploy_error.log
	ERROR=$(cat deploy_error.log)

	if [ "$ERROR" = '' ]; then
		touch .deploy_config
	fi
}

#
# Deploy all files
#
deploy_all()
{
	echo "deployng all files"

	FILES_MODIFY=$(find . -maxdepth 1)
	FILES_IGNORE=$(cat .deployignore)

	PATTERN=$(echo "$FILES_IGNORE")
	PATTERN=$(echo $PATTERN | tr ' ' '\|')

	UP_FILES=''

	for file in $FILES_MODIFY; do
		ignore=$(echo "$file" | egrep -o "$PATTERN")
		if [ "$ignore" = '' -a "$file" != '.' ]; then
			UP_FILES+="$file "
		fi
	done

	scp -r $UP_FILES "$SSH:$ROOT$DIR" 2> deploy_error.log
}

#
# Deploy modified files
#
deploy_modified()
{
	FILES_MODIFY=$(find . -newer .deploy_config -type f)

	if [ "$FILES_MODIFY" = '' ]; then
		echo "no files modified for deployment"
	else
		echo "deployng files modified"
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
		deploy_modified 

	elif [ "$1" = 'all' ]; then
		deploy_all

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


