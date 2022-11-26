#!/usr/bin/env bash
set -e

[ "$1" = "-h" ] && exec sed -ne '/^#/!q;s/.\{1,2\}//;1d;p' < "$0"

workdir="$(mktemp -d -t gh-pages)"
repo="${1}"

if [[ -z "${repo}" ]]; then
	exec sed -ne '/^#/!q;s/.\{1,2\}//;1d;p' < "$0"
	exit 1
fi

pushd ${workdir} >/dev/null
	git init
	git checkout --orphan gh-pages

	touch index.html
	git add index.html

	git commit -m 'chore: initial commit'

	git remote add origin https://github.com/${repo}.git
	git push -u origin gh-pages
popd >/dev/null

rm -rf ${workdir}
