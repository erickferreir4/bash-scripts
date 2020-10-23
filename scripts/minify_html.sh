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
			sed -zi 's/\s\s*/ /g; s/> </></g; s/>  */> /g; s/  *</ </g' $1
			sed -i 's/<!--/\n<!--/g; s/[^\!]-->/-->\n/g' $1
			sed -i '/<!--.*-->/d' $1
			sed -zi 's/\s\s*/ /g; s/> </></g; s/>  */> /g; s/  *</ </g' $1
		fi
	fi
}

main $1

