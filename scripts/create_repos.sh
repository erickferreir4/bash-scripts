#!/bin/bash


#
#
#	Create repository in github
#
#	./create_repos.sh repo1 repo2
#
#


GITHUB_USER=''
GITHUB_PASS=''


main()
{
	for repo in $@; do
		if [ -n $repo ] && [ "$1" != "" ]; then
			curl -u "$GITHUB_USER:$GITHUB_PASS" https://api.github.com/user/repos -d '{"name": "'$repo'"}'
		fi
	done
}

main $@
