#!/usr/bin/env sh
set -e

[ "$1" = "-h" ] && exec sed -ne '/^#/!q;s/.\{1,2\}//;1d;p' < "$0"

branch="$(git symbolic-ref --short HEAD)"
remote="${1%/*}"
remote_branch="${1#*/}"

[ "$remote_branch" != "${remote}" ] || remote_branch="$branch"

if [ -z "${remote}" ]; then
	remote="$(git remote -v | grep -E '(git@|https://)(git|scm)' | head -1 | awk '{print $1}')"
fi

if [ -z "${remote}" ]; then
	echo "no remote with write access" >&2
	exit 1
fi

git push -u "${remote}" "${branch}":"${remote_branch}"
