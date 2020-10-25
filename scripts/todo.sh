#!/bin/bash



#
#
#  A Todo list
#
#
#
#	### cleal all tasks ###
#
#	todo clear
#
#
#
#	### list tasks ###
#
#	todo ls
#
#
#
#	### add task ###
#
#	todo add task
#
#
#
#	### remove task ###
#
#	todo remove id
#
#
#

create_file()
{
	if [ ! -f "$HOME/.todo_list" ]; then
		touch $HOME/.todo_list	
	fi
}

todo_ls()
{
	cat "$HOME/.todo_list"
}

todo_add()
{
	lines=$(wc -l "$HOME/.todo_list" | awk '{print $1}')

	task=$(echo "($[$lines+1]). $1")

	echo $task >> "$HOME/.todo_list"

	todo_ls
}

todo_remove()
{
	sed -i "/($1)/d" "$HOME/.todo_list"

	lines=$(wc -l "$HOME/.todo_list"| awk '{print $1}')	

	for x in $(seq 	1 $lines); do
		sed -i "$x s/(.*)/($x)/" "$HOME/.todo_list"
	done
}

todo_clear()
{
	sed -i 'd' "$HOME/.todo_list"
}

main()
{
	create_file

	if [ "$1" == "add" ]; then
		todo_add "${*:2}"

	elif [ "$1" == "remove" ]; then
		todo_remove $2

	elif [ "$1" == "ls" ]; then
		todo_ls

	elif [ "$1" == "clear" ]; then
		todo_clear

	fi
}


main $@
