{ pkgs, lib, hostName, ... }:
{
  nixpkgs.hostPlatform    = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "liuhao";

  home-manager.useGlobalPkgs   = true;
  home-manager.useUserPackages = true;

  # ── Nix ──────────────────────────────────────────────────────────────────────

  nix.settings = {
    substituters        = [ "https://cache.nixos.org/" ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    trusted-users         = [ "@admin" "liuhao" ];
    auto-optimise-store   = true;
    experimental-features = [ "nix-command" "flakes" ];
    extra-platforms       = lib.optionals (pkgs.stdenv.hostPlatform.system == "aarch64-darwin")
                              [ "x86_64-darwin" "aarch64-darwin" ];
  };

  # ── Networking ────────────────────────────────────────────────────────────────

  networking.hostName     = hostName;
  networking.computerName = "deathstar";

  # ── Shell ─────────────────────────────────────────────────────────────────────

  programs.zsh.enable = true;

  # ── System Packages ───────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    terminal-notifier
  ];

  # ── Fonts ─────────────────────────────────────────────────────────────────────

  fonts.packages = with pkgs; [
    recursive
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  # ── Startup ───────────────────────────────────────────────────────────────────

  system.startup.chime = false;

  # ── Keyboard ──────────────────────────────────────────────────────────────────
  # CapsLock → Left Control via HID key codes:
  #   Caps Lock = 0x700000039 = 30064771129
  #   Left Ctrl = 0x7000000E0 = 30064771296

  system.keyboard = {
    enableKeyMapping = true;
    userKeyMapping = [
      {
        HIDKeyboardModifierMappingSrc = 30064771129; # Caps Lock
        HIDKeyboardModifierMappingDst = 30064771296; # Left Control
      }
    ];
  };

  # ── Security ──────────────────────────────────────────────────────────────────

  security.pam.services.sudo_local.touchIdAuth = true;

  # ── macOS System Defaults ─────────────────────────────────────────────────────

  system.defaults = {

    # ── Dock ──────────────────────────────────────────────────────────────────
    dock = {
      autohide                              = true;
      autohide-delay                        = 0.0;
      autohide-time-modifier                = 0.0;
      tilesize                              = 36;
      mineffect                             = "scale";
      minimize-to-application               = true;
      show-recents                          = false;
      show-process-indicators               = true;
      launchanim                            = false;
      mouse-over-hilite-stack               = true;
      enable-spring-load-actions-on-all-items = true;
      expose-animation-duration             = 0.1;
      expose-group-apps                     = false;
      mru-spaces                            = false;
      dashboard-in-overlay                  = true;
      orientation                           = "bottom";
      wvous-tl-corner                       = 10; # top-left hot corner: sleep display
    };

    # ── Finder ────────────────────────────────────────────────────────────────
    finder = {
      AppleShowAllFiles              = true;
      AppleShowAllExtensions         = true;
      ShowPathbar                    = true;
      ShowStatusBar                  = true;
      FXEnableExtensionChangeWarning = false;
      FXDefaultSearchScope           = "SCcf";
      FXPreferredViewStyle           = "Nlsv";
      _FXShowPosixPathInTitle        = true;
    };

    # ── Screen capture ────────────────────────────────────────────────────────
    screencapture = {
      location       = "~/Desktop/Screenshots";
      type           = "png";
      disable-shadow = true;
    };

    # ── Global / NSGlobalDomain ───────────────────────────────────────────────
    NSGlobalDomain = {
      NSWindowResizeTime                  = 0.001;
      NSNavPanelExpandedStateForSaveMode  = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint     = true;
      PMPrintingExpandedStateForPrint2    = true;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled  = false;
      AppleKeyboardUIMode                 = 3;
      AppleShowAllExtensions              = true;
      InitialKeyRepeat                    = 15;
      KeyRepeat                           = 2;
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay"   = 0.0;
    };

    # ── Spaces ────────────────────────────────────────────────────────────────
    spaces.spans-displays = false;

    # ── Trackpad ──────────────────────────────────────────────────────────────
    trackpad.Clicking = true;

    # ── CustomUserPreferences — arbitrary plist domains ───────────────────────
    CustomUserPreferences = {

      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true;
      };

"com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores     = true;
      };

"com.apple.NetworkBrowser" = {
        BrowseAllInterfaces = true;
      };

      "com.apple.frameworks.diskimages" = {
        auto-open-ro-root = true;
        auto-open-rw-root = true;
      };

      "com.apple.finder" = {
        OpenWindowForNewRemovableDisk = true;
        FXInfoPanesExpanded = {
          General    = true;
          OpenWith   = true;
          Privileges = true;
        };
      };

      "NSGlobalDomain" = {
        WebKitDeveloperExtras = true;
      };
    };
  };

  # ── Activation scripts ────────────────────────────────────────────────────────

  system.activationScripts.postActivation.text = ''
    USER_HOME="/Users/liuhao"
    mkdir -p "$USER_HOME/Desktop/Screenshots"
    /usr/bin/chflags nohidden "$USER_HOME/Library"

    FINDER_PLIST="$USER_HOME/Library/Preferences/com.apple.finder.plist"
    for view in DesktopViewSettings FK_StandardViewSettings StandardViewSettings; do
      /usr/libexec/PlistBuddy -c \
        "Set :''${view}:IconViewSettings:showItemInfo true"      "$FINDER_PLIST" 2>/dev/null || \
      /usr/libexec/PlistBuddy -c \
        "Add :''${view}:IconViewSettings:showItemInfo bool true"  "$FINDER_PLIST"
      /usr/libexec/PlistBuddy -c \
        "Set :''${view}:IconViewSettings:arrangeBy grid"         "$FINDER_PLIST" 2>/dev/null || \
      /usr/libexec/PlistBuddy -c \
        "Add :''${view}:IconViewSettings:arrangeBy string grid"  "$FINDER_PLIST"
      /usr/libexec/PlistBuddy -c \
        "Set :''${view}:IconViewSettings:gridSpacing 100"        "$FINDER_PLIST" 2>/dev/null || \
      /usr/libexec/PlistBuddy -c \
        "Add :''${view}:IconViewSettings:gridSpacing integer 100" "$FINDER_PLIST"
      /usr/libexec/PlistBuddy -c \
        "Set :''${view}:IconViewSettings:iconSize 80"            "$FINDER_PLIST" 2>/dev/null || \
      /usr/libexec/PlistBuddy -c \
        "Add :''${view}:IconViewSettings:iconSize integer 80"    "$FINDER_PLIST"
    done
    /usr/libexec/PlistBuddy -c \
      "Set :DesktopViewSettings:IconViewSettings:labelOnBottom false" "$FINDER_PLIST" 2>/dev/null || true

    for app in cfprefsd Dock Finder; do
      /usr/bin/killall "$app" &>/dev/null || true
    done
  '';

  # ── Homebrew ──────────────────────────────────────────────────────────────────

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade    = true;
      cleanup    = "zap";
    };

    taps = [
      "bfontaine/utils"
      "candid82/brew"
      "coursier/formulas"
    ];

    brews = [
      "adr-tools"
      "bazel"
      "bzt"
      "fontconfig"
      "gemini-cli"
      "rlwrap"
      "jpeg"
      "markdown"
      "mole"
      "planck"
      "tailscale"
      "terminal-notifier"
      "the_silver_searcher"
      "tree"
      "winetricks"
      "zsh-autosuggestions"
      "zsh-completions"
    ];

    casks = [
      "anki"
      "blender"
      "codex"
      "chatgpt"
      "claude"
      "claude-code"
      "dropbox"
      "emacs-app"
      "evernote"
      "firefox"
      "font-fira-code"
      "font-hack-nerd-font"
      "gimp"
      "google-chrome"
      "jd-gui"
      "obsidian"
      "mactex"
      "raycast"
      "p4v"
      "pgadmin4"
      "skim"
      "stats"
      "superduper"
      "texmaker"
      "visual-studio-code"
      "wireshark-app"
    ];
  };

  # ── System state version ──────────────────────────────────────────────────────

  system.stateVersion = 5;
}
