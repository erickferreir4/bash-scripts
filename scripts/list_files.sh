#!/bin/bash

#
#
#
#	List files in directory
#
#
#
#



main()
{
	dir=$(ls -a)

	for isFile in $dir; do
		if [ -f $isFile ]; then
			echo $isFile
		fi
	done
}



main
