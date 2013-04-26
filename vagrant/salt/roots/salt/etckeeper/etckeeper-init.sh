#!/usr/bin/env bash

cd /etc
if [ -d .git ]; then
	echo "etckeeper already inited"
else
	etckeeper init
	etckeeper commit -m "initial commit"
	echo "etckeeper inited"
fi
