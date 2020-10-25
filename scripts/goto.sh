#!/bin/bash


#
#
#
#
#	Go to dir alias
#
#
#	goto alias
#
#
#
#	####### add directory currenty #######
#
#	goto add alias
#
#
#
#
#	####### remove alias #######
#
#	goto remove alias
#
#
#
#	####### list all alias #######
#
#	goto ls
#
#
#


create_file()
{
	if [ ! -f "$HOME/.goto" ]; then
		touch "$HOME/.goto"
	fi
}

goto_add()
{
	dir=$(pwd)

	if [ "$1" != '' ]; then
		echo "$dir=$1" >> $HOME/.goto
	fi

}

goto_remove()
{
	if [ "$1" != '' ]; then
		sed -i "/$1$/d" $HOME/.goto
	fi
}

go_to()
{
	alias=$1

	dir=$(awk -v var="$alias" -F "=" '{if(var == $2) print $1}' $HOME/.goto)

	cd $dir
}

goto_ls()
{
	awk -F "=" '{print $1 "  ====>  " $2}' $HOME/.goto
}


main()
{
	create_file

	if [ "$1" == "add" ]; then
		goto_add $2

	elif [ "$1" == "remove" ]; then
		goto_remove $2

	elif [ "$1" == "ls" ]; then
		goto_ls

	else
		go_to $1

	fi

}



main $1 $2



