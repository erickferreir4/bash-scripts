#!/bin/bash


#
#
#	Create repository in github
#
#
#	CONFIG
#
#		# Create personal access token #
#			
#		1 - github > settings > Developer settings > Personal access tokens			
#			
#		2 - click Generate new token	
#			
#		3 - name token			
#			
#		4 - Select scopes "repo", "admin:repo" 			
#			
#		5 - click Generate token			
#			
#		6 - copy token			
#			
#		7 - paste in GITHUB_TOKEN			
#			
#			
#			
#	./create_repos.sh repo1 repo2
#
#
#

GITHUB_TOKEN='TOKEN'


main()
{
	for repo in $@; do
		if [ -n $repo ] && [ "$1" != "" ]; then
			curl -H 'Authorization: token '$GITHUB_TOKEN'' https://api.github.com/user/repos -d '{"name": "'$repo'"}'
		fi
	done
}

main $@
