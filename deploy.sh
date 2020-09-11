#!/bin/bash

FILES=$(find . -cmin -60)

# scp to copy files
# ex 
# SCP="name@127.0.0.1:~/Desktop/App"
SCP="name@host:~/Dir/ProjectMain"

# base dir to project main
# ex
# BASEDIR="~/Desktop/App"
BASEDIR="~/Dir/ProjectMain"

# 
# SSH
#
# ssh-keygen required in the server
#
SSH="ssh name@host"


for i in $FILES; do

	if [ -f $i ]; then

		DIR=$(echo $i | grep -oP "[^/].*/" |  grep  -o "[^.].*")
		scp -r $i $SCP$DIR
		echo "$i   ==+copied+==>   $SCP$DIR"

	else
		DIR=$(echo $i | grep -o "[^.].*")
		$SSH "[ ! -d $BASEDIR$DIR ] && mkdir -p $BASEDIR$DIR && echo $BASEDIR$DIR  ==+directory created+=="
	fi

done
