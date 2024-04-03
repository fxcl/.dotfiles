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
          "chipsalliance/verible"
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
          "code-composer-studio"
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
          "visual-studio-code-insiders"
          #"xquartz"
          #"xournal-plus-plus"
          #"zoom"
        ];

        # `brew install`
        brews = [
          "pinentry-mac"
          "gcc"
          "libiconv"
          "mas"
          "rustup-init"
          "python@3.12"
          #"cmake"
          #"openssl"
          # "libolm"
          "mysql-client"
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
          "verible"
          "libgccjit"
          "icu4c"
          "tree-sitter"
        {
              name = "emacs-mac";
            args = [
              "with-emacs-big-sur-icon"
              "with-ctags"
              "with-natural-title-bar"
              "with-starter"
              "with-mac-metal"
              "with-native-compilation"
              "with-xwidgets"
              "with-unlimited-select"
            ];
          }

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
          # disable Chrome native DNS resolver
          if [ -d '/Applications/Google Chrome Canary.app' ]; then
            defaults write com.google.Chrome BuiltInDnsClientEnabled -bool false
          fi
          # disable saving to keychain for GPG
          defaults write org.gpgtools.common DisableKeychain -bool true
          # reset the order of the launchpad and size of dock
          defaults write com.apple.dock ResetLaunchPad -bool true
          defaults write com.apple.dock tilesize -integer 64
          defaults write com.apple.dock size-immutable -bool yes
          defaults write com.apple.dock no-bouncing -bool true
          defaults write com.flexibits.fantastical2.mac HideLocationSuggestions -bool yes
          defaults write com.flexibits.fantastical2.mac AlwaysIgnoreLocation -bool yes
          defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
          killall Dock
          # if Emacs.app exists, reset Emacs to /Applications
          if [ -d /usr/local/Cellar/emacs-mac/emacs-29.1-mac-10.0/Emacs.app ]; then
            rm -rf /Applications/Emacs.app
            cp -r  /usr/local/Cellar/emacs-mac/emacs-29.1-mac-10.0/Emacs.app /Applications
          elif [ -d /Applications/Emacs.app ]; then
            rm -rf /Applications/Emacs.app
          fi
        '';

        defaults = {
          menuExtraClock.Show24Hour = true; # show 24 hour clock
          SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
          # ".GlobalPreferences".com.apple.sound.beep.sound = "Funk";
          LaunchServices.LSQuarantine = false;

          dock = {
            autohide = false;
            autohide-delay = 0.0;
            autohide-time-modifier = 0.0;
            show-recents = false;
            # do not automatically rearrange spaces based on most recent use.
            mru-spaces = false;

            dashboard-in-overlay = true;
            expose-animation-duration = 0.15;
            expose-group-by-app = false;
            launchanim = false;
            mineffect = "genie";
            minimize-to-application = true;
            mouse-over-hilite-stack = true;
            show-process-indicators = false;
            showhidden = true;
            static-only = true;
            tilesize = 46;
            # Hot corners, reset them all.
            # Not supported in nix-darwin yet

            wvous-tl-corner = 2;
            wvous-tr-corner = 1;
            wvous-bl-corner = 11;
            wvous-br-corner = 1;

            #wvous-tl-corner = 2; # top-left - Mission Control
            #wvous-tr-corner = 13; # top-right - Lock Screen
            #wvous-bl-corner = 3; # bottom-left - Application Windows
            #wvous-br-corner = 4; # bottom-right - Desktop
          };

          finder = {
            _FXShowPosixPathInTitle = true; # show full path in finder title
            AppleShowAllExtensions = true; # show all file extensions
            FXEnableExtensionChangeWarning =
              false; # disable warning when changing file extension
            QuitMenuItem = true; # enable quit menu item
            ShowPathbar = true; # show path bar
            ShowStatusBar = true; # show status bar
            FXPreferredViewStyle = "clmv";
          };

          trackpad = {
            # tap - 轻触触摸板, click - 点击触摸板
            Clicking = true; # enable tap to click(轻触触摸板相当于点击)
            TrackpadRightClick = true; # enable two finger right click
            TrackpadThreeFingerDrag = true; # enable three finger drag
          };

          NSGlobalDomain = {
            # `defaults read NSGlobalDomain "xxx"`
            "com.apple.swipescrolldirection" =
              true; # enable natural scrolling(default to true)
            "com.apple.sound.beep.feedback" =
              0; # disable beep sound when pressing volume up/down key
            AppleInterfaceStyle = "Dark"; # dark mode
            AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
            ApplePressAndHoldEnabled = false; # enable press and hold
            # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
            # This is very useful for vim users, they use `hjkl` to move cursor.
            # sets how long it takes before it starts repeating.
            InitialKeyRepeat =
              15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
            # sets how fast it repeats once it starts.
            KeyRepeat =
              3; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)
            NSNavPanelExpandedStateForSaveMode =
              true; # expand save panel by default(保存文件时的路径选择/文件名输入页)
            NSNavPanelExpandedStateForSaveMode2 = true;

            NSAutomaticCapitalizationEnabled =
              false; # disable auto capitalization(自动大写)
            NSAutomaticDashSubstitutionEnabled =
              false; # disable auto dash substitution(智能破折号替换)
            NSAutomaticPeriodSubstitutionEnabled =
              false; # disable auto period substitution(智能句号替换)
            NSAutomaticQuoteSubstitutionEnabled =
              false; # disable auto quote substitution(智能引号替换)
            NSAutomaticSpellingCorrectionEnabled =
              false; # disable auto spelling correction(自动拼写检查)

            AppleFontSmoothing = 2;
            AppleMeasurementUnits = "Centimeters";
            AppleMetricUnits = 1;
            AppleShowAllExtensions = true;
            AppleShowScrollBars = "Automatic";
            AppleTemperatureUnit = "Celsius";
            NSDocumentSaveNewDocumentsToCloud = false;
            NSTableViewDefaultSizeMode = 2;
            NSTextShowsControlCharacters = true;
            NSWindowResizeTime = 0.001;
            PMPrintingExpandedStateForPrint = true;
            PMPrintingExpandedStateForPrint2 = true;
            _HIHideMenuBar = false;
            # com.apple.mouse.tapBehavior = 1;
            # com.apple.springing.delay = 0;
            # com.apple.springing.enabled = true;
          };

          # customize settings that not supported by nix-darwin directly
          # see the source code of https://github.com/rgcr/m-cli to get all the available options
          CustomUserPreferences = {
            ".GlobalPreferences" = {
              "com.apple.mouse.linear" = 1;
              # automatically switch to a new space when switching to the application
              AppleSpacesSwitchOnActivate = true;
            };
            NSGlobalDomain = {
              # Add a context menu item for showing the Web Inspector in web views
              WebKitDeveloperExtras = true;
              ApplePressAndHoldEnabled = false;
            };
            "com.apple.finder" = {
              ShowExternalHardDrivesOnDesktop = true;
              ShowHardDrivesOnDesktop = true;
              ShowMountedServersOnDesktop = true;
              ShowRemovableMediaOnDesktop = true;
              _FXSortFoldersFirst = true;
              # When performing a search, search the current folder by default
              FXDefaultSearchScope = "SCcf";
            };
            "com.apple.desktopservices" = {
              # Avoid creating .DS_Store files on network or USB volumes
              DSDontWriteNetworkStores = true;
              DSDontWriteUSBStores = true;
            };
            "com.apple.screensaver" = {
              # Require password immediately after sleep or screen saver begins
              askForPassword = 1;
              askForPasswordDelay = 0;
            };
            "com.apple.screencapture" = {
              location = "~/Desktop";
              type = "png";
            };
            "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
            # Prevent Photos from opening automatically when devices are plugged in
            "com.apple.ImageCapture".disableHotPlug = true;
          };

          loginwindow = {
            GuestEnabled = false; # disable guest user
            SHOWFULLNAME = true; # show full name in login window
          };
        };

        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToEscape = true;
        };

      };
    };
}
