#!/bin/bash

create_config()
{
	read -p "SSH: " SSH
	echo "SSH='$SSH'" > deploy_config.sh

	read -p "ROOT: " ROOT
	echo "ROOT='$ROOT'" >> deploy_config.sh

	chmod ugo=r deploy_config.sh
}

check_config () 
{
	FILES=$(find . -name "deploy_config.sh" -type f)

	if [ ! -f "$FILES" ]; then
		create_config
	fi

	source deploy_config.sh
}


deploy_files()
{
	echo

	DIR=$( echo $file | grep -o "[^/].*/" | grep -o "[^.].*" )

	ssh $SSH "[ ! -d $ROOT$DIR ] && mkdir -p $ROOT$DIR"

	echo $ROOT$DIR
	scp $file "$SSH:$ROOT$DIR"
}



watch_files()
{

	sleep 2 

	FILES_MODIFY=$(find . -mmin 0.05)

	for file in $FILES_MODIFY; do
		if [ -f $file ];then
			deploy_files
		fi
	done

	watch_files
}

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




main()
{
	check_config	

	echo
	echo "ssh: $SSH"
	echo "root: $ROOT"
	echo

	if [ "$1" = 'watch' ]; then
		echo 'watching....'
		watch_files

	elif [ "$1" = 'config' ]; then
		chmod ugo=rw deploy_config.sh
		create_config

	elif [ "$1" = 'all' ] && [ "$2" -gt 0 ]; then
			TIME=$2
			all $TIME

	elif [ -z "$1" ]; then
		echo 1
		all
	else
		echo 'invalid command line'
	fi

}

main $1 $2


