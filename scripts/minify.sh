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

	echo $IS_HTML

	
	if [ $IS_HTML != '' ]; then


		if [ -f $1 ]; then
			


		fi



	fi


}





main $1

