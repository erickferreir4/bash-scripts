#!/bin/bash

#
#
#	Minify html
#
#
#

main()
{
	IS_HTML=$(echo "$1" | egrep -o "html$")

	if [ $IS_HTML != '' ]; then
		if [ -f $1 ]; then
			sed -zi 's/\s\s*/ /g; s/> </></g; s/> />/g; s/ </</g' $1
		fi
	fi
}





main $1

