{ config, pkgs, lib, ... }:
let
  username = "liuhao";
  homeDir  = "/Users/${username}";
in
{
  home.username      = username;
  home.homeDirectory = lib.mkForce homeDir;
  home.stateVersion  = "24.11";

  # ── Packages ──────────────────────────────────────────────────────────────────

  home.packages = with pkgs; [
    # Shell utilities
    antigen
    coreutils
    curl
    ghostty-bin
    wget
    eza
    bat
    fd
    ripgrep
    carapace
    lazygit
    mtr
    nmap
    mosh
    rlwrap
    tmux
    silver-searcher
    tailscale
    tree
    zoxide
    zsh-completions
    zsh-autosuggestions

    # Git & signing
    git-lfs
    gnupg
    gh

    # Data & text processing
    jq
    graphviz
    plantuml
    poppler
    qpdf
    yq-go
    pandoc
    bun

    # Cloud & infrastructure
    awscli2
    google-cloud-sdk
    terraform
    orbstack
    utm

    # Build tools
    autoconf
    automake
    gcc
    maven
    gradle
    sbt
    openssl
    readline

    # Languages
    clojure
    leiningen
    elixir
    go
    rustup
    nodejs
    ocaml
    opam
    polylith

    # JS/TS
    nodePackages.typescript

    # Nix tooling
    cachix
    niv

    # Search

    # Image
    ffmpeg
    imagemagick
    yt-dlp

    # Misc
    exercism
    starship

    # Personal
    fava
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    m-cli
    cocoapods

    # iOS development (Xcode itself must be installed via App Store or xcodes)
    xcodes          # Xcode version manager
    xcodegen        # Generate Xcode projects from YAML spec
    swiftlint       # Swift style linter

  ];

  # ── PATH & environment ────────────────────────────────────────────────────────

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "/run/current-system/sw/bin"
    "/opt/homebrew/bin"
  ];

  home.sessionVariables = {
    EDITOR           = "emacsclient";
    LDFLAGS          = "-L${homeDir}/.nix-profile/lib";
    CPPFLAGS         = "-I${homeDir}/.nix-profile/include";
  };

  # ── Git ───────────────────────────────────────────────────────────────────────

  programs.git = {
    enable     = true;
    lfs.enable = true;
    signing.format = null;

    settings = {
      user.name  = "LiuHao";
      user.email = "sniperliuhao@gmail.com";

      alias = {
        co   = "checkout";
        br   = "branch";
        st   = "status -sb";
        nb   = "checkout -b";
        rb   = "branch -d";
        lb   = "branch -l";
        ll   = "log --oneline";
        p    = "push --force-with-lease";
        last = "log -1 HEAD --stat";
        cm   = "commit -m";
        ca   = "commit --amend";
        rv   = "remote -v";
        d    = "diff";
        gl   = "config --global -l";
        se   = "!git rev-list --all | xargs git grep -F";
      };

      core = {
        editor   = "emacsclient";
        autocrlf = "input";
      };
      push.autoSetupRemote = true;
      merge.tool           = "p4merge";
      init.defaultBranch   = "main";
    };
  };

  # ── Zsh ───────────────────────────────────────────────────────────────────────

  programs.zsh = {
    enable                    = true;
    enableCompletion          = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable  = true;
      plugins = [ "git" "macos" "ssh-agent" "genpass" ];
      theme   = "gentoo";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
      '')
      ''
        # Carapace multi-shell completions
        export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
        zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
        source <(carapace _carapace)

      ''
    ];

    shellAliases = {
      ls   = "eza --icons";
      ll   = "eza --icons -lh --git";
      la   = "eza --icons -lah --git";
      lt   = "eza --icons --tree --level=2";
      tree = "eza --icons --tree";
    };
  };

  # ── Starship ──────────────────────────────────────────────────────────────────

  programs.starship = {
    enable               = true;
    enableZshIntegration = true;
  };

  # ── fzf ───────────────────────────────────────────────────────────────────────

  programs.fzf = {
    enable               = true;
    enableZshIntegration = true;
  };

  # ── zoxide ────────────────────────────────────────────────────────────────────

  programs.zoxide = {
    enable               = true;
    enableZshIntegration = true;
  };

  # ── direnv ────────────────────────────────────────────────────────────────────

  programs.direnv = {
    enable            = true;
    nix-direnv.enable = true;
  };

  # ── htop ──────────────────────────────────────────────────────────────────────

  programs.htop = {
    enable                     = true;
    settings.show_program_path = true;
  };

  # ── SSH ───────────────────────────────────────────────────────────────────────

  programs.ssh = {
    enable                = true;
    enableDefaultConfig   = false;
    matchBlocks."*" = {
      extraOptions = {
        UseKeychain    = "yes";
        AddKeysToAgent = "yes";
      };
    };
  };

  # ── Ghostty terminal ──────────────────────────────────────────────────────────

  home.file.".config/ghostty/config".text = ''
    # Typography
    font-family        = JetBrainsMonoNerdFont
    font-size          = 14
    font-thicken       = true
    adjust-cell-height = 2

    # Theme — Catppuccin with automatic light/dark switching
    theme = light:Catppuccin Latte,dark:Catppuccin Mocha

    # Window
    background-opacity     = 0.9
    background-blur-radius = 20
    macos-titlebar-style   = transparent
    window-padding-x       = 10
    window-padding-y       = 8
    window-save-state      = always
    window-theme           = auto

    # Cursor
    cursor-style       = bar
    cursor-style-blink = true
    cursor-opacity     = 0.8

    # Mouse
    mouse-hide-while-typing = true
    copy-on-select          = clipboard

    # Quick Terminal (Quake-style dropdown)
    quick-terminal-position           = top
    quick-terminal-screen             = mouse
    quick-terminal-autohide           = true
    quick-terminal-animation-duration = 0.15

    # Security
    clipboard-paste-protection     = true
    clipboard-paste-bracketed-safe = true

    # Shell integration
    shell-integration = detect

    # Keybindings — Tabs
    keybind = cmd+t=new_tab
    keybind = cmd+shift+left=previous_tab
    keybind = cmd+shift+right=next_tab
    keybind = cmd+w=close_surface

    # Keybindings — Splits
    keybind = cmd+d=new_split:right
    keybind = cmd+shift+d=new_split:down
    keybind = cmd+alt+left=goto_split:left
    keybind = cmd+alt+right=goto_split:right
    keybind = cmd+alt+up=goto_split:top
    keybind = cmd+alt+down=goto_split:bottom
    keybind = cmd+shift+e=equalize_splits
    keybind = cmd+shift+f=toggle_split_zoom

    # Keybindings — Font size
    keybind = cmd+plus=increase_font_size:1
    keybind = cmd+minus=decrease_font_size:1
    keybind = cmd+zero=reset_font_size

    # Keybindings — Misc
    keybind = global:ctrl+grave_accent=toggle_quick_terminal
    keybind = cmd+shift+comma=reload_config

    # Performance
    scrollback-limit = 25000000
  '';

  # ── Emacs ─────────────────────────────────────────────────────────────────────

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.pdf-tools
    ];
  };

  home.file = {
    ".emacs.d/init.el".source           = ./config/.emacs.d/init.el;
    ".emacs.d/configuration.org".source = ./config/.emacs.d/configuration.org;
  };

  # ── AWS ───────────────────────────────────────────────────────────────────────

  home.file.".aws/config".source = ./config/aws/config;

  # ── Haskell Stack ─────────────────────────────────────────────────────────────

  home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
    templates = {
      scm-init = "git";
      params = {
        author-name     = "LiuHao";
        author-email    = "sniperliuhao@gmail.com";
        github-username = "liuhao";
      };
    };
    nix.enable = true;
  };

  # ── Java ───────────────────────────────────────────────────────────────────────
  programs.java.enable = true;
}
