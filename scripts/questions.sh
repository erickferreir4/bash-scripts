#!/bin/bash

#
# create question.txt
#
# add line in question
#
# question=answer
#
# ex 
#
# What year javascript was created?=1995
#



COUNT=1
LINES_FILE=$(cat question.txt | wc -l)

while :
do

	QUESTIONS=$(cat question.txt | tail -n+$COUNT | head -1 )

	QUESTION=$(echo $QUESTIONS | grep -oP "^[^=]*")
	ANSWER=$(echo $QUESTIONS | grep -oP "[^=]*$")

	#question
	echo $QUESTION
	read TRY

	#verify read
	if [ "$TRY" = "$ANSWER" ]; then
		COUNT=$(($COUNT + 1))
		clear
		echo "that's right!"
	fi



	#echo "$LINES_FILE $COUNT" 

	#break loop
	if [ $COUNT -gt $LINES_FILE ]; then 
		break
	fi

done



