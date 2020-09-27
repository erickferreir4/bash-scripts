#!/bin/bash

#
# UP to dir
#
# alias up=". $HOME/up.sh"
#

DIR=$(pwd | grep -o "[/^].*$1")
cd $DIR
