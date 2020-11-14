#!/bin/bash

#
#	Clone all public repository in github
#
#	close_all.sh user
#


main()
{
	github=$(curl -s https://api.github.com/users/$1/repos)

	repos=$(echo "$github" | grep -o "git://.*[^,\"]")

	mkdir "repos_public"
	cd "repos_public/"

	for repo in $repos
	do
		git clone $repo
	done
}

main $1





