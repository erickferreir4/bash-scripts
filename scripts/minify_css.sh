#!/bin/bash

#
#
#
#	Minify CSS
#
#
#
#

main()
{
	CSS=$( echo $1 | egrep -o ".css$" )

	if [ "$CSS" != '' ]; then

		sed -zi 's/\s\s*//g; s/\n//g' $1
		sed -zi 's!/\*!\n/\*!g; s!\*/!\*/\n!g' $1
		sed -i '/\/\*.*\*\//d' $1
		sed -zi 's/\s\s*//g; s/\n//g' $1

	fi
}

main $1
