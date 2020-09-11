#!/bin/bash


#
# time file modified
#
FILES=$(find . -cmin -60)


# scp to copy files
# ex
# SCP="name@host:~/Desktop/App"
SCP="name-host@host-address:~/Desktop/App"


# base dir to project main
# ex
# BASEDIR="~/Desktop/App"
BASEDIR="~/dir/app"

#
# SSH
#
# ssh-keygen required in the server
#
SSH="ssh name-host@host-address"


for file in $FILES; do
	if [ -f $file ]; then

		DIR=$(echo $file | grep -oP "[^/].*/" |  grep  -o "[^.].*")
		$SSH "[ ! -d $BASEDIR$DIR ] && mkdir -p $BASEDIR$DIR && echo \"$DIR   +++++++++++directory created+++++++++++++>   $BASEDIR\""

		scp -q $file $SCP$DIR
		echo "$file   +++++++++++copied+++++++++++++>   $SCP$DIR"

	fi
done
