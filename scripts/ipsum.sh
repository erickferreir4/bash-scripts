#!/bin/bash


#
#
#
#	Generate lorem ipsun text
#
#
#
#


main()
{
	ipsum=$(curl -s "https://baconipsum.com/api/?type=meat-and-filter")
	echo $ipsum | sed 's/\["//; s/"\]//'
}




main 
