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
          #"eloston-chromium"
          # "code-composer-studio"
          #"crossover"
          #"discord"
          #"kitty"
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
          "libgccjit"
          "icu4c"
          "tree-sitter"
          #"shortcat"
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
          defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

          # Use scroll gesture with the Ctrl (^) modifier key to zoom
          # defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
          # defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
          # Follow the keyboard focus while zoomed in
          # defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

          # Set a blazingly fast keyboard repeat rate
          defaults write NSGlobalDomain KeyRepeat -int 1
          defaults write NSGlobalDomain InitialKeyRepeat -int 10

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
          defaults write com.apple.screencapture location -string "${HOME}/Desktop"

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

          # Change minimize/maximize window effect
          defaults write com.apple.dock mineffect -string "scale"

          # Minimize windows into their application’s icon
          defaults write com.apple.dock minimize-to-application -bool true

          # Enable spring loading for all Dock items
          defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

          # Show indicator lights for open applications in the Dock
          defaults write com.apple.dock show-process-indicators -bool true

          # Make Dock icons of hidden applications translucent
          defaults write com.apple.dock showhidden -bool true


          # Add iOS & Watch Simulator to Launchpad
          sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"


          ###############################################################################
          # Terminal                                                                    #
          ###############################################################################

          # Only use UTF-8 in Terminal.app
          defaults write com.apple.terminal StringEncodings -array 4


          ###############################################################################
          # Activity Monitor                                                            #
          ###############################################################################

          # Show the main window when launching Activity Monitor
          defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

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


          ###############################################################################
          # Photos                                                                      #
          ###############################################################################

          # Prevent Photos from opening automatically when devices are plugged in
          defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

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
