{ pkgs, lib, config, ... }:

let

  cfg = config.my.modules.macos;

in
{
  options = with lib; {
    my.modules.macos = {
      enable = mkEnableOption ''
        Whether to enable macos module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      environment.variables = {
        LANG = "en_US.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };

      homebrew = {
        taps = [
          "homebrew/bundle"
          #"homebrew/core"
          "homebrew/services"
          "homebrew/cask-fonts"
          "homebrew/cask-versions"
          "railwaycat/emacsmacport"
          "charmbracelet/tap"
          #"chipsalliance/verible"
        ];

        # `brew install --cask`
        casks = [
          "swiftdefaultappsprefpane"
          "iina"
          "mpv"
          # "keepingyouawake"
          "chai"
          "keka"
          "kekaexternalhelper"
          "font-jetbrains-mono-nerd-font"
          "font-mononoki-nerd-font"
          #"eloston-chromium"
          # "code-composer-studio"
          #"crossover"
          #"discord"
          #"league-of-legends"
          #"microsoft-office"
          #"microsoft-teams"
          #"middleclick"
          #"mos"
          #"obs"
          #"openemu"
          #"spotify"
          #"steam"
          #"stremio"
          #"syncthing"
          #"teamviewer"
          #"utm"
          #"via"
          "goneovim"
          #"xquartz"
          #"xournal-plus-plus"
          #"zoom"
        ];

        # `brew install`
        brews = [
          "lua"
          "luajit"
          # "ccache"
          # "sccache"
          "pinentry-mac"
          "tldr"
          "gcc"
          "libiconv"
          "mas"
          "rustup"
          #"python@3.12"
          #"cmake"
          #"openssl"
          # "libolm"
          "mysql-client"
          "maven"
          "aspell"
          "croc"
          "gstreamer"
          "gnutls"
          "jansson"
          "libxml2"
          "texinfo"
          "imagemagick"
          "libtool"
          "llvm"
          "uv"
          "libomp"
          #"verible"
          "aria2"
          "libgccjit"
          "icu4c"
          "tree-sitter"
          #"shortcat"
          "typos-cli"
          "charmbracelet/tap/mods"
          # {
          #   name = "emacs-mac";
          #   args = [
          #     "with-emacs-big-sur-icon"
          #     "with-ctags"
          #     "with-natural-title-bar"
          #     "with-starter"
          #     "with-mac-metal"
          #     "with-native-compilation"
          #     "with-xwidgets"
          #     "with-unlimited-select"
          #   ];
          # }

        ];

        masApps = {
          # "1Password 7" = 1333542190;
          # "Xcode" = 497799835;
          # "The Unarchiver" = 425424353;
        };
      };

      system = {
        # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
        activationScripts.postUserActivation.text = ''
                    # activateSettings -u will reload the settings from the database and apply them to the current session,
                    # so we do not need to logout and login again to make the changes take effect.
                    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

                    echo 'Welcome to @tr1lhx installation script'
                    echo 'This script will configure macOS'

                    # disable Chrome native DNS resolver
                    if [ -d '/Applications/Google Chrome.app' ]; then
                      defaults write com.google.Chrome BuiltInDnsClientEnabled -bool false
                    fi

                    # Close any open System Preferences panes, to prevent them from overriding
                    # settings we’re about to change
                    osascript -e 'tell application "System Preferences" to quit'

                    # Ask for the administrator password upfront
                    sudo -v

                    # Keep-alive: update existing `sudo` time stamp until `macos-settings.sh` has finished
                    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

                    echo "Making system modifications:"

                    ###############################################################################
                    # General UI/UX                                                               #
                    ###############################################################################

                    # Set standby delay to 24 hours (default is 1 hour)
                    sudo pmset -a standbydelay 86400

                    # Display battery percentage
                    defaults write com.apple.menuextra.battery ShowPercent YES

                    # Expand save panel by default
                    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
                    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

                    # Expand print panel by default
                    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
                    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

                    # Save to disk (not to iCloud) by default
                    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

                    # Set highlight color to green
                    defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.937255 0.690196"

                    # Set sidebar icon size to medium
                    defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

                    # Always show scrollbars
                    defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
                    # Possible values: `WhenScrolling`, `Automatic` and `Always`

                    # Disable the over-the-top focus ring animation
                    defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

                    # Disable smooth scrolling
                    # (Uncomment if you’re on an older Mac that messes up the animation)
                    #defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

                    # Increase window resize speed for Cocoa applications
                    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

          # Save to disk (not to iCloud) by default
          defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

                    # Automatically quit printer app once the print jobs complete
                    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

                    # Disable the “Are you sure you want to open this application?” dialog
                    defaults write com.apple.LaunchServices LSQuarantine -bool false

                    # Disable the crash reporter
                    defaults write com.apple.CrashReporter DialogType -string "none"

                    # Reveal IP address, hostname, OS version, etc. when clicking the clock
                    # in the login window
                    sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

                    # Disable confirmation of opening links in external applications from the browser
                    defaults write com.google.Chrome ExternalProtocolDialogShowAlwaysOpenCheckbox -bool true

                    # Set clock format
                    defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"

                    # Disable automatic capitalization as it’s annoying when typing code
                    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

                    # Disable smart dashes as they’re annoying when typing code
                    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

                    # Disable automatic period substitution as it’s annoying when typing code
                    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

                    # Disable smart quotes as they’re annoying when typing code
                    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

                    # Disable auto-correct
                    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

                    # Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
                    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

                    # Display ASCII control characters using caret notation in standard text views
                    # Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
                    defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

                    # Disable Resume system-wide
                    defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

                    # Disable automatic termination of inactive apps
                    defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

                    # Set Help Viewer windows to non-floating mode
                    defaults write com.apple.helpviewer DevMode -bool true


                    # Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
                    # Commented out, as this is known to cause problems in various Adobe apps :(
                    # See https://github.com/mathiasbynens/dotfiles/issues/237
                    #echo "0x08000100:0" > ~/.CFUserTextEncoding

                    # Restart automatically if the computer freezes
                    #sudo systemsetup -setrestartfreeze on

                    # Never go into computer sleep mode
                    #sudo systemsetup -setcomputersleep Off > /dev/null

                    # Disable Notification Center and remove the menu bar icon
                    launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

                    # Enable full keyboard access for all controls
                    # (e.g. enable Tab in modal dialogs)
                    ##defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

                    # Use scroll gesture with the Ctrl (^) modifier key to zoom
                    # defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
                    # defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
                    # Follow the keyboard focus while zoomed in
                    # defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

                    # Set a blazingly fast keyboard repeat rate
                    ##defaults write NSGlobalDomain KeyRepeat -int 1
                    ##defaults write NSGlobalDomain InitialKeyRepeat -int 10

                    # Set language and text formats
                    # Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
                    # `Inches`, `en_GB` with `en_US`, and `true` with `false`.
                    defaults write NSGlobalDomain AppleLanguages -array "en" "us"
                    defaults write NSGlobalDomain AppleLocale -string "en_us@currency=USD"
                    defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
                    defaults write NSGlobalDomain AppleMetricUnits -bool false

                    # Show language menu in the top right corner of the boot screen
                    sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

                    # Set the timezone; see `sudo systemsetup -listtimezones` for other values
                    #sudo systemsetup -settimezone "America/Los_Angeles" > /dev/null


                    # Stop iTunes from responding to the keyboard media keys
                    #launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null



                    ###############################################################################
                    # Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
                    ###############################################################################

                    # Trackpad: enable tap to click for this user and for the login screen
                    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
                    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
                    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

                    # Use scroll gesture with the Ctrl (^) modifier key to zoom
                    defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
                    defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

                    # Disable press-and-hold for keys in favor of key repeat
                    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false


                    ###############################################################################
                    # Screen                                                                      #
                    ###############################################################################

                    # Require password immediately after sleep or screen saver begins
                    defaults write com.apple.screensaver askForPassword -int 1
                    defaults write com.apple.screensaver askForPasswordDelay -int 0

                    # Save screenshots to the desktop
                    defaults write com.apple.screencapture location -string "~/Desktop"

                    # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
                    defaults write com.apple.screencapture type -string "png"

                    # Disable shadow in screenshots
                    defaults write com.apple.screencapture disable-shadow -bool true

                    # Enable subpixel font rendering on non-Apple LCDs
                    # Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
                    defaults write NSGlobalDomain AppleFontSmoothing -int 1

                    # Enable HiDPI display modes (requires restart)
                    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true


                    ###############################################################################
                    # Finder                                                                      #
                    ###############################################################################

                    # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
                    defaults write com.apple.finder QuitMenuItem -bool true

                    # Finder: disable window animations and Get Info animations
                    defaults write com.apple.finder DisableAllAnimations -bool true

                    # Set Desktop as the default location for new Finder windows
                    # For other paths, use `PfLo` and `file:///full/path/here/`
                    defaults write com.apple.finder NewWindowTarget -string "PfDe"
                    defaults write com.apple.finder NewWindowTargetPath -string "file://~/Desktop/"

                    # Show icons for hard drives, servers, and removable media on the desktop
                    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
                    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
                    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
                    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

                    # Finder: show hidden files by default
                    defaults write com.apple.finder AppleShowAllFiles -bool true

                    # Finder: show all filename extensions
                    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

                    # Finder: show status bar
                    defaults write com.apple.finder ShowStatusBar -bool true

                    # Finder: show path bar
                    defaults write com.apple.finder ShowPathbar -bool true

                    # Display full POSIX path as Finder window title
                    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

                    # Keep folders on top when sorting by name
                    defaults write com.apple.finder _FXSortFoldersFirst -bool true

                    # When performing a search, search the current folder by default
                    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

                    # Disable the warning when changing a file extension
                    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

                    # Avoid creating .DS_Store files on network or USB volumes
                    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
                    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true



                    # Enable spring loading for directories
                    defaults write NSGlobalDomain com.apple.springing.enabled -bool true

                    # Remove the spring loading delay for directories
                    # defaults write NSGlobalDomain com.apple.springing.delay -float 0
                    defaults write NSGlobalDomain com.apple.springing.delay -float 1000

                    # Enable snap-to-grid for icons on the desktop and in other icon views
                    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
                    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
                    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

                    # Increase grid spacing for icons on the desktop and in other icon views
                    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
                    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
                    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

                    # Show the ~/Library folder
                    chflags nohidden ~/Library

                    # Show the /Volumes folder
                    sudo chflags nohidden /Volumes

                    # Expand the following File Info panes:
                    # “General”, “Open with”, and “Sharing & Permissions”
                    defaults write com.apple.finder FXInfoPanesExpanded -dict \
                      General -bool true \
                      OpenWith -bool true \
                      Privileges -bool true

                    ###############################################################################
                    # Dock, Dashboard, and hot corners                                            #
                    ###############################################################################

                    # Enable highlight hover effect for the grid view of a stack (Dock)
                    defaults write com.apple.dock mouse-over-hilite-stack -bool true

                    # Set the icon size of Dock items to 36 pixels
                    defaults write com.apple.dock tilesize -int 36

                    # Change minimize/maximize window effect
                    defaults write com.apple.dock mineffect -string "scale"


                    # Change minimize/maximize window effect
                    defaults write com.apple.dock mineffect -string "scale"

                    # Minimize windows into their application’s icon
                    defaults write com.apple.dock minimize-to-application -bool true

                    # Enable spring loading for all Dock items
                    defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

                    # Show indicator lights for open applications in the Dock
                    defaults write com.apple.dock show-process-indicators -bool true

                    # Dock orientation: 'left', 'bottom', 'right'
                    defaults write com.apple.dock 'orientation' -string 'left'

                    # Wipe all (default) app icons from the Dock
                    # This is only really useful when setting up a new Mac, or if you don’t use
                    # the Dock to launch apps.
                    #defaults write com.apple.dock persistent-apps -array

                    # Show only open applications in the Dock
                    defaults write com.apple.dock static-only -bool true

                    # Don’t animate opening applications from the Dock
                    defaults write com.apple.dock launchanim -bool false

                    # Speed up Mission Control animations
                    defaults write com.apple.dock expose-animation-duration -float 0.1

                    # Don’t group windows by application in Mission Control
                    # (i.e. use the old Exposé behavior instead)
                    defaults write com.apple.dock expose-group-by-app -bool true

                    # Disable Dashboard
                    defaults write com.apple.dashboard mcx-disabled -bool true

                    # Don’t show Dashboard as a Space
                    defaults write com.apple.dock dashboard-in-overlay -bool true

                    # Don’t automatically rearrange Spaces based on most recent use
                    defaults write com.apple.dock mru-spaces -bool false

                    # Remove the auto-hiding Dock delay
                    defaults write com.apple.dock autohide-delay -float 0
                    # Remove the animation when hiding/showing the Dock
                    defaults write com.apple.dock autohide-time-modifier -float 0

                    # Automatically hide and show the Dock
                    defaults write com.apple.dock autohide -bool true


                    # Make Dock icons of hidden applications translucent
                    defaults write com.apple.dock showhidden -bool true

                    # Disable the Launchpad gesture (pinch with thumb and three fingers)
                    #defaults write com.apple.dock showLaunchpadGestureEnabled -int 0


                    # Add iOS & Watch Simulator to Launchpad
                    sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
                    #sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

                    # Add a spacer to the left side of the Dock (where the applications are)
                    #defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
                    # Add a spacer to the right side of the Dock (where the Trash is)
                    #defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

                    # Hot corners
                    # Possible values:
                    #  0: no-op
                    #  2: Mission Control
                    #  3: Show application windows
                    #  4: Desktop
                    #  5: Start screen saver
                    #  6: Disable screen saver
                    #  7: Dashboard
                    # 10: Put display to sleep
                    # 11: Launchpad
                    # 12: Notification Center
                    # Top left screen corner → Mission Control
                    defaults write com.apple.dock wvous-tl-corner -int 2
                    defaults write com.apple.dock wvous-tl-modifier -int 0
                    # Top right screen corner → Desktop
                    defaults write com.apple.dock wvous-tr-corner -int 4
                    defaults write com.apple.dock wvous-tr-modifier -int 0
                    # Bottom left screen corner → Start screen saver
                    defaults write com.apple.dock wvous-bl-corner -int 5
                    defaults write com.apple.dock wvous-bl-modifier -int 0

                    ###############################################################################
                    # Terminal                                                                    #
                    ###############################################################################

                    # Only use UTF-8 in Terminal.app
                    defaults write com.apple.terminal StringEncodings -array 4

                    # Enable “focus follows mouse” for Terminal.app and all X11 apps
                    # i.e. hover over a window and start typing in it without clicking first
                    #defaults write com.apple.terminal FocusFollowsMouse -bool true
                    #defaults write org.x.X11 wm_ffm -bool true

                    # Enable Secure Keyboard Entry in Terminal.app
                    # See: https://security.stackexchange.com/a/47786/8918
                    defaults write com.apple.terminal SecureKeyboardEntry -bool true

                    # Disable the annoying line marks
                    defaults write com.apple.Terminal ShowLineMarks -int 0

                    # Don’t display the annoying prompt when quitting iTerm
                    defaults write com.googlecode.iterm2 PromptOnQuit -bool false

                    ###############################################################################
                    # Time Machine                                                                #
                    ###############################################################################

                    # Prevent Time Machine from prompting to use new hard drives as backup volume
                    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

                    # Activity Monitor                                                            #
                    ###############################################################################

                    # Show the main window when launching Activity Monitor
                    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

                    # Visualize CPU usage in the Activity Monitor Dock icon
                    defaults write com.apple.ActivityMonitor IconType -int 5

                    # Show all processes in Activity Monitor
                    defaults write com.apple.ActivityMonitor ShowCategory -int 0

                    # Sort Activity Monitor results by CPU usage
                    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
                    defaults write com.apple.ActivityMonitor SortDirection -int 0


                    ###############################################################################
                    # Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
                    ###############################################################################

                    # Use plain text mode for new TextEdit documents
                    defaults write com.apple.TextEdit RichText -int 0

                    # Open and save files as UTF-8 in TextEdit
                    defaults write com.apple.TextEdit PlainTextEncoding -int 4
                    defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


                    ###############################################################################
                    # Mac App Store                                                               #
                    ###############################################################################

                    # Check for software updates daily, not just once per week
                    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

                    # Enable the WebKit Developer Tools in the Mac App Store
                    defaults write com.apple.appstore WebKitDeveloperExtras -bool true

                    # Enable Debug Menu in the Mac App Store
                    defaults write com.apple.appstore ShowDebugMenu -bool true

                    # Enable the automatic update check
                    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

                    # Check for software updates daily, not just once per week
                    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

                    # Download newly available updates in background
                    defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

                    # Install System data files & security updates
                    defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

                    # Automatically download apps purchased on other Macs
                    defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

                    # Turn on app auto-update
                    defaults write com.apple.commerce AutoUpdate -bool true

                    # Allow the App Store to reboot machine on macOS updates
                    # defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

                    ###############################################################################
                    # Photos                                                                      #
                    ###############################################################################

                    # Prevent Photos from opening automatically when devices are plugged in
                    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

                    ###############################################################################
                    # Messages                                                                    #
                    ###############################################################################

                    # Disable automatic emoji substitution (i.e. use plain text smileys)
                    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

                    # Disable smart quotes as it’s annoying for messages that contain code
                    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

                    # Disable continuous spell checking
                    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

                    ###############################################################################
                    # Google Chrome & Google Chrome Canary                                        #
                    ###############################################################################

                    # Disable the all too sensitive backswipe on trackpads
                    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
                    defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

                    # Disable the all too sensitive backswipe on Magic Mouse
                    defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
                    defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

                    # Use the system-native print preview dialog
                    defaults write com.google.Chrome DisablePrintPreview -bool true
                    defaults write com.google.Chrome.canary DisablePrintPreview -bool true

                    # Expand the print dialog by default
                    defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
                    defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

                    ###############################################################################
                    # Safari & WebKit                                                             #
                    ###############################################################################

                    # Privacy: don’t send search queries to Apple
                    defaults write com.apple.Safari UniversalSearchEnabled -bool false
                    defaults write com.apple.Safari SuppressSearchSuggestions -bool true

                    # Press Tab to highlight each item on a web page
                    defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
                    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

                    # Show the full URL in the address bar (note: this still hides the scheme)
                    defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

                    # Set Safari’s home page to `about:blank` for faster loading
                    defaults write com.apple.Safari HomePage -string "about:blank"

                    # Prevent Safari from opening ‘safe’ files automatically after downloading
                    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

                    # Allow hitting the Backspace key to go to the previous page in history
                    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

                    # Hide Safari’s bookmarks bar by default
                    defaults write com.apple.Safari ShowFavoritesBar -bool false

                    # Hide Safari’s sidebar in Top Sites
                    defaults write com.apple.Safari ShowSidebarInTopSites -bool false

                    # Disable Safari’s thumbnail cache for History and Top Sites
                    defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

                    # Enable Safari’s debug menu
                    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

                    # Make Safari’s search banners default to Contains instead of Starts With
                    defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

                    # Remove useless icons from Safari’s bookmarks bar
                    defaults write com.apple.Safari ProxiesInBookmarksBar "()"

                    # Enable the Develop menu and the Web Inspector in Safari
                    defaults write com.apple.Safari IncludeDevelopMenu -bool true
                    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
                    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

                    # Add a context menu item for showing the Web Inspector in web views
                    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

                    # Enable continuous spellchecking
                    defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
                    # Disable auto-correct
                    defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

                    # Disable AutoFill
                    defaults write com.apple.Safari AutoFillFromAddressBook -bool false
                    defaults write com.apple.Safari AutoFillPasswords -bool false
                    defaults write com.apple.Safari AutoFillCreditCardData -bool false
                    defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

                    # Warn about fraudulent websites
                    defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

                    # Disable plug-ins
                    defaults write com.apple.Safari WebKitPluginsEnabled -bool false
                    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

                    # Disable Java
                    defaults write com.apple.Safari WebKitJavaEnabled -bool false
                    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false

                    # Block pop-up windows
                    defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
                    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

                    # Disable auto-playing video
                    #defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
                    #defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
                    #defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
                    #defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

                    # Enable “Do Not Track”
                    defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

                    # Update extensions automatically
                    defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

                    ###############################################################################
                    # Mail                                                                        #
                    ###############################################################################

                    # Disable send and reply animations in Mail.app
                    defaults write com.apple.mail DisableReplyAnimations -bool true
                    defaults write com.apple.mail DisableSendAnimations -bool true

                    # Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
                    defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

                    # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
                    defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

                    # Display emails in threaded mode, sorted by date (oldest at the top)
                    defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
                    defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
                    defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

                    # Disable inline attachments (just show the icons)
                    defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

                    # Disable automatic spell checking
                    defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

                    ###############################################################################
                    # Kill affected applications                                                  #
                    ###############################################################################
                    killall Dock
                    echo "Done. Note that some of these changes require a logout/restart to take effect."

                    # if Emacs.app exists, reset Emacs to /Applications
                    if [ -d /usr/local/Cellar/emacs-mac/emacs-29.1-mac-10.0/Emacs.app ]; then
                      rm -rf /Applications/Emacs.app
                      cp -r  /usr/local/Cellar/emacs-mac/emacs-29.1-mac-10.0/Emacs.app /Applications
                    elif [ -d /Applications/Emacs.app ]; then
                      rm -rf /Applications/Emacs.app
                    fi

                    ln -sfv ~/.config/VSCodium/settings.json ~/Library/Application\ Support/VSCodium/User/settings.json
                    ln -sfv ~/.config/VSCodium/keybindings.json ~/Library/Application\ Support/VSCodium/User/keybindings.json
        '';
      };
    };
}
