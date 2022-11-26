#!/bin/bash

# A simple command line utility to help clean unwanted items from the macosx launcher
#

# default parameters
#
CMD=$1          # the operation to perform
APP_NAME=$2     # the target name of the app if applicable

# list all the aops known to the launcher
#
function list_apps {
    sqlite3 $(sudo find /private/var/folders -name com.apple.dock.launchpad)/db/db \
        "select * from apps;"
}

# determine if the specified app is known to the launcher
#
function check_app {
    _APP_NAME="$1"
    RESULT=`sqlite3 $(sudo find /private/var/folders -name com.apple.dock.launchpad)/db/db \
        "select title from apps where title='${_APP_NAME}';" \
        | tail -n 1`
    if [[ ${RESULT} == $_APP_NAME ]]; then
        echo The app ${_APP_NAME} is registered.
    else
        echo The app ${_APP_NAME} is NOT registered.
    fi
}

# delete the specified app from the launcher
#
function remove_app {
    _APP_NAME="$1"
    sqlite3 $(sudo find /private/var/folders -name com.apple.dock.launchpad)/db/db \
        "delete from apps where title=${_APP_NAME};" && killall Dock
}

# handle the command line input and invoke the correct function
#
if [[ ${CMD} == "list" ]]; then
    list_apps
elif [[ ${CMD} == "check"  ]]; then
    check_app ${APP_NAME}
elif [[ ${CMD} == "remove"  ]]; then
    remove_app ${APP_NAME}
else
    echo "Usage $0 <list>|<check>|<remove> <AppName>"
fi
