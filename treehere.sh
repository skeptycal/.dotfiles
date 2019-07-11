#!/usr/bin/env bash

treehere (){
	[[ -z "$1" ]] && level=1 || level="$1"
	tree $tree_path -aFCL $level --dirsfirst --si
}

treehere
echo "shell level \$SHLVL: $SHLVL"
