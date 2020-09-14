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

FLAG=0
FLAG_TRY=0
ARRAY_LINES=()


while :

do


	if [ "$FLAG_TRY" = 0 ]; then

		#
		# Generates random number between lines
		#
		NUMBER_LINE=$(($RANDOM % $LINES_FILE + 1))

		#
		# Check if the number has already been
		#
		for i in ${ARRAY_LINES[@]};
		do
			if [ "$i" = "$NUMBER_LINE" ]; then
				FLAG=1
				break
			fi
		done
		
		#
		# Question has already
		#
		if [ "$FLAG" = 1 ]; then
			FLAG=0
			continue
		fi

		#
		# Add the number to the array
		#
		ARRAY_LINES+=($NUMBER_LINE)
	fi

	


	#
	# Takes the line from the file
	#
	QUESTIONS=$(cat question.txt | tail -n+$NUMBER_LINE | head -1 )

	#
	# Generates the question
	#
	QUESTION=$(echo $QUESTIONS | grep -oP "^[^=]*")
	ANSWER=$(echo $QUESTIONS | grep -oP "[^=]*$")

	#
	# Question
	#
	echo $QUESTION
	read TRY

	#
	# Verify read
	#
	if [ "$TRY" = "$ANSWER" ]; then
		COUNT=$(($COUNT + 1))
		clear
		echo "that's right!"
		FLAG_TRY=0
	else
		FLAG_TRY=1
	fi


	#
	# break loop
	#
	if [ $COUNT -gt $LINES_FILE ]; then 
		break
	fi

done



