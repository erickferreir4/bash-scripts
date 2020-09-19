#!/bin/bash

create_config()
{
	read -p "SSH: " SSH
	echo "SSH='$SSH'" > deploy_config.sh

	read -p "ROOT: " ROOT
	echo "ROOT='$ROOT'" >> deploy_config.sh
}

check_config () 
{
	FILES=$(find . -name "deploy_config.sh" -type f)

	if [ ! -f "$FILES" ]; then
		create_config
	fi

	chmod ugo=r deploy_config.sh
	source deploy_config.sh
}


deploy_files()
{

	echo

	DIR=$(echo $file | grep -o "[^/].*/" | grep -o "[^.].*" )

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
	fi
	



}

main $1

