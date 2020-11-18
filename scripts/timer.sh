#!/bin/bash

#
#
#	Cronometro
#
#	./cronometro.sh n
#
#

main()
{
	if [ "$1" -eq "$1" ] 2>/dev/null
	then

		clear

		for i in $(seq $1 -1 0)
		do
			sleep 1
			clear
			echo "Timer is running"
			echo "count: $i seconds"
		done

		clear
		echo -ne '\007'

	else 
		echo "ERROR: first parameter must be an interger."
		echo $USAGE
		exit 1
	fi
}

main $1


