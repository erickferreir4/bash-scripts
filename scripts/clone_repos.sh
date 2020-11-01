#!/bin/bash



#
#
#
#	Clone repository from github
#
#	./clone_repos.sh repo1 repo2
#

GITHUB_USER=''

main()
{
	for repo in $@; do
		if [ -n $repo ] && [ "$repo" != "" ];then
			git clone https://github.com/$GITHUB_USER/$repo.git
		fi
	done
}


main $@


