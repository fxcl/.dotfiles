#!/usr/bin/env bash

output=$(brew outdated --greedy)

echo

brew outdated --greedy
if [ -n "$output" ]; then
	read -p "These packages will be upgraded, please confirm. [y/N]: " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		brew upgrade --greedy
	fi
else
	echo "No upgradable packages, not doing anything..."
fi

brew cleanup --prune=all
