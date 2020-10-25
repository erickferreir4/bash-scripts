#!/bin/bash


#
#
#
#
#	Go to dir alias
#
#
#
#	goto alias
#
#	goto add /dir alias
#
#
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
	echo "$1=$2" >> $HOME/.goto
}

go_to()
{
	alias=$1

	dir=$(awk -v var="$alias" -F "=" '{if(var == $2) print $1}' $HOME/.goto)

	cd $dir
}


main()
{
	create_file

	if [ "$1" == "add" ]; then
		goto_add $2 $3
	else
		go_to $1
	fi

}



main $1 $2 $3



