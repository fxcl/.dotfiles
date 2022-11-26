{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.macos;
  me = "kelvin";
in

{
  options = with lib; {
    my.modules.macos = {
      enable = mkEnableOption ''
        Whether to enable macos module
      '';
    };

    # system.defaults.dock.wvous-tl-corner = mkOption {
    #   type = types.nullOr types.int;
    #   default = null;
    #   description = ''
    #     Hot corner action for top left corner
    #   '';
    # };

    # system.defaults.dock.wvous-bl-corner = mkOption {
    #   type = types.nullOr types.int;
    #   default = null;
    #   description = ''
    #     Hot corner action for bottom left corner
    #   '';
    # };

    # system.defaults.dock.wvous-tr-corner = mkOption {
    #   type = types.nullOr types.int;
    #   default = null;
    #   description = ''
    #     Hot corner action for top right corner
    #   '';
    # };

    # system.defaults.dock.wvous-br-corner = mkOption {
    #   type = types.nullOr types.int;
    #   default = null;
    #   description = ''
    #     Hot corner action for bottom right corner
    #   '';
    # };

    system.defaults.dock.largesize = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        Large size of the icons in the dock.  The default is 64.
      '';
    };

    system.defaults.dock.magnification = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        Enable magnification for the icons in the dock.  The default is false.
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
          "homebrew/cask"
          "homebrew/core"
          "homebrew/services"
        ];

        casks = [
          "swiftdefaultappsprefpane"
        ];

        brews = [
          "mas"
          # "libolm"

        ];

        masApps = {
          # "1Password 7" = 1333542190;
          # "Xcode" = 497799835;
          # "The Unarchiver" = 425424353;
        };
      };

      system = {
        defaults = {
          # System - Disable 'Are you sure you want to open this application?' dialog
          LaunchServices.LSQuarantine = false;
          SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

          # System - Enable font smoothing
          # Enables subpixel font rendering on non-Apple LCDs
          NSGlobalDomain.AppleFontSmoothing = 1;

          # Keyboard - Enable full keyboard access for all controls.
          # (e.g., enable Tab in modal dialogs)
          NSGlobalDomain.AppleKeyboardUIMode = 3;
          # NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
          # NSGlobalDomain.AppleMetricUnits = 1;

          # Keyboard - Disable press-and-hold for keys in favor of key repeat
          NSGlobalDomain.ApplePressAndHoldEnabled = false;

          # Finder - Show filename extensions.
          NSGlobalDomain.AppleShowAllExtensions = true;

          # System - Automatically show scroll bars
          NSGlobalDomain.AppleShowScrollBars = "Automatic";

          # System - What temperature unit to use
          NSGlobalDomain.AppleTemperatureUnit = "Celsius";

          # Keyboard - Set a short Delay until key repeat.
          NSGlobalDomain.InitialKeyRepeat = 15;

          # Keyboard - Set a fast keyboard repeat rate.
          NSGlobalDomain.KeyRepeat = 1;

          # System - Disable automatic capitalization as it’s annoying when typing code
          NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;

          # System - Disable smart dashes as they’re annoying when typing code
          NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;

          # System - Disable automatic period substitution as it’s annoying when typing code
          NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;

          # System - Disable smart quotes as they’re annoying when typing code
          NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;

          # System - Disable auto-correct
          NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;

          # iCloud - Don't save new documents to iCloud by default
          NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;

          # System - Expand save panel by default.
          NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
          NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

          NSGlobalDomain.NSTableViewDefaultSizeMode = 2;
          NSGlobalDomain.NSTextShowsControlCharacters = true;

          # System - Decrease window resize duration
          # NSGlobalDomain.NSWindowResizeTime = "0";

          # Printer - Expand print panel by default.
          NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
          NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;

          dock.autohide = false;
          # dock.dashboard-in-overlay = true;
          # dock.expose-animation-duration = 0;
          # dock.expose-group-by-app = false;
          # dock.launchanim = false;
          # dock.mineffect = "genie";
          # dock.mouse-over-hilite-stack = true;
          # dock.show-process-indicators = false;
          # dock.static-only = true;
          dock.tilesize = 48;

          # Dock - Don’t show recent applications in Dock
          dock.show-recents = false;

          # Dock - Make icons of hidden applications translucent
          dock.showhidden = true;

          # Dock - Don’t automatically rearrange Spaces based on most recent use
          dock.mru-spaces = false;

          # Dock - Orient to the bottom
          dock.orientation = "bottom";

          # Dock - Minimize apps to their icon
          dock.minimize-to-application = true;

          # Hot corners, reset them all.
          # Not supported in nix-darwin yet
          # wvous-tl-corner = 0;
          # wvous-tl-modifier = 0;
          # wvous-tr-corner = 0;
          # wvous-tr-modifier = 0;
          # wvous-bl-corner = 0;
          # wvous-bl-modifier = 0;
          # wvous-br-corner = 0;
          # wvous-br-modifier = 0;

          # Finder - Disable the warning when changing a file extension
          finder.FXEnableExtensionChangeWarning = false;

          # Finder - Add quit option
          finder.QuitMenuItem = true;

          finder.AppleShowAllExtensions = true;
          finder._FXShowPosixPathInTitle = true;

          # Screencapture - Save screenshots to the desktop
          screencapture.location = "/Users/${config.my.username}/Pictures/Screenshots";

          loginwindow.DisableConsoleAccess = true;
          loginwindow.GuestEnabled = false;
          loginwindow.PowerOffDisabledWhileLoggedIn = true;
          loginwindow.RestartDisabledWhileLoggedIn = true;
          loginwindow.ShutDownDisabledWhileLoggedIn = true;
          loginwindow.SHOWFULLNAME = true;

          trackpad.ActuationStrength = 1;
          trackpad.Clicking = true;
          trackpad.FirstClickThreshold = 1;
          trackpad.SecondClickThreshold = 1;
          trackpad.TrackpadRightClick = true;
          trackpad.TrackpadThreeFingerDrag = true;
        };

        activationScripts.postActivation.text = ''
          # Finder - Set $HOME as the default location for new windows
          defaults write com.apple.finder NewWindowTarget -string "PfDe"
          defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME"
          # Bluetooth - Increase sound quality for headphones/headsets
          defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
          # Printer - Automatically quit printer app once the print jobs complete
          defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
          # Safari - Enable the Develop menu and the Web Inspector
          defaults write com.apple.Safari IncludeDevelopMenu -bool true
          defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
          defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
          # Safari - Add a context menu item for showing the Web Inspector in web views
          defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
          # Safari - Press Tab to highlight each item on a web page
          defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
          defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
          # Safari - Prevent Safari from opening ‘safe’ files automatically after downloading
          defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
          # Safari - Make Safari’s search banners default to Contains instead of Starts With
          defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
          # Safari - Enable continuous spellchecking
          defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
          # Safari - Disable auto-correct
          defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
          # Safari - Warn about fraudulent websites
          defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
          # Safari - Disable Java
          defaults write com.apple.Safari WebKitJavaEnabled -bool false
          defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
          # Safari - Block pop-up windows
          defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
          defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
          # Safari - Disable auto-playing video
          defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
          defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
          defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
          defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
          # Safari Enable “Do Not Track”
          defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
          # Safari - Update extensions automatically
          defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
          # Terminal - Only use UTF-8
          defaults write com.apple.terminal StringEncodings -array 4
          # Terminal - Enable Secure Keyboard Entry
          # See: https://security.stackexchange.com/a/47786/8918
          defaults write com.apple.terminal SecureKeyboardEntry -bool true
          # Terminal - Disable the annoying line marks
          defaults write com.apple.Terminal ShowLineMarks -int 0
          # Activity Monitor - Show the main window when launching
          defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
          # Activity Monitor - Visualize CPU usage in the Dock icon
          defaults write com.apple.ActivityMonitor IconType -int 5
          # Activity Monitor - Show all processes
          defaults write com.apple.ActivityMonitor ShowCategory -int 0
          # Activity Monitor - Sort results by CPU usage
          defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
          defaults write com.apple.ActivityMonitor SortDirection -int 0
          # TextEdit - Use plain text mode for new documents
          defaults write com.apple.TextEdit RichText -int 0
          # TextEdit - Open and save files as UTF-8
          defaults write com.apple.TextEdit PlainTextEncoding -int 4
          defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
          # QuickTime Player - Auto-play videos when opened with QuickTime Player
          defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true
          # AirDrop - Use AirDrop over every interface
          defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
          # Mac App Store - Enable the automatic update check
          defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
          # Mac App Store - Download newly available updates in background
          defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
          # Mac App Store - Check for software updates daily, not just once per week
          defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
          # Mac App Store - Install System data files & security updates
          defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
          # Mac App Store - Turn on app auto-update
          defaults write com.apple.commerce AutoUpdate -bool true
          # Mac App Store - Allow to reboot machine on macOS updates
          defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
          # Photos - Prevent Photos from opening automatically when devices are plugged in
          defaults write com.apple.ImageCapture disableHotPlug -bool true
        '';

      };

      # Suppose to fix applications not showing in the applications folder
      # https://github.com/LnL7/nix-darwin/issues/139#issuecomment-666771621
      # https://github.com/LnL7/nix-darwin/issues/214
      system.activationScripts.applications.text =
        let
          env = pkgs.buildEnv {
            name = "applications";
            paths = config.environment.systemPackages ++ config.users.users.${me}.packages;
            pathsToLink = "/Applications";
          };
        in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up ~/Applications/Nix..." >&2
          rm -rf ~/Applications/Nix
          mkdir -p ~/Applications/Nix
          srcs=()
          while read src; do
            srcs+=("$src")
          done < <(find ${env}/Applications -maxdepth 1 -type l)
          if [[ "''${#srcs[@]}" != 0 ]]; then
            /bin/cp -LR "''${srcs[@]}" ~/Applications/Nix
          fi
        '';
    };
}
