#/bin/bash

# https://mac-how-to.gadgethacks.com/how-to/remove-duplicates-customize-open-with-menu-mac-os-x-0157100/

/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -kill -r -domain local -domain system -domain user

killall finder
