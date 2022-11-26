#!/usr/bin/env zsh

if test "$PROXY_HOST" && ping -q -c 1 -W 0.5 $PROXY_HOST > /dev/null 2>&1 ; then
  if nmcli con show --active | grep vpn > /dev/null 2>&1 ; then
    echo "at work on vpn"
  else
    echo "at work"
  fi

  # Env
  export http_proxy="http://127.0.0.1:7890"
  export https_proxy="http://127.0.0.1:7890"
  export no_proxy="$WORK_NO_PROXY"
  export CURL_NIX_FLAGS="-x http://127.0.0.1:7890"

  # Docker
  mkdir -p $HOME/.docker
  echo "\
{
  \"auths\": {
		\"$WORK_DOCKER_REGISTRY\": {
			\"auth\": \"`echo -n "$LDAP_USER:$LDAP_PASSWORD" | base64`\"
		}
	},
 \"proxies\":
 {
   \"default\":
   {
     \"httpProxy\": \"$http_proxy\",
     \"httpsProxy\": \"$https_proxy\",
     \"noProxy\": \"$no_proxy\"
   }
 }
}
" > $HOME/.docker/config.json


else
  echo "not at work"

  # Env
  unset http_proxy
  unset https_proxy
  unset no_proxy
  unset CURL_NIX_FLAGS

  # Docker
  rm -f $HOME/.docker/config.json
fi
