#!/bin/bash

#
#	cd & ls -al
#
#	alias=". lcd.sh"
#
#

main()
{
	cd $1
	ls -al
}


main $1

