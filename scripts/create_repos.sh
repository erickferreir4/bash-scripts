#!/bin/bash


#
#
#	Create repository in github
#
#	./create_repos.sh name_repo
#
#


GITHUB_USER=''
GITHUB_PASS=''


main()
{
	if [ -n $1 ] && [ "$1" != "" ]; then
		curl -u "$GITHUB_USER:$GITHUB_PASS" https://api.github.com/user/repos -d '{"name": "'$1'"}'
	fi
}

main $1
