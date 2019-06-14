#!/usr/bin/env bash

treehere (){
	[ ! "$1" ] && echo "$1" || echo "no"
	if !$1 then $1 = 1;
	tree -a -F -C -L $1 --dirsfirst --si;
	unset -f f;
}; f'
