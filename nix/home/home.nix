{ config, pkgs, input, ... }:

{
  nixpkgs = { config = { allowUnfree = true; }; };
  nixpkgs.config.allowUnfreePredicate = _: true;

  # NIX PACKAGES
  home = {

    username = if pkgs.stdenv.isDarwin then "clementcouriol" else "ozaki";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/clementcouriol" else "/home/ozaki";
    packages = with pkgs;
      [
        jq
        yq
        fnm
        atuin
        duf
        ollama
        bun
        lazydocker
        btop
        ffmpeg
        tealdeer
        ncdu
        glow
        dust
        ugrep
        nh
        nixfmt
        nvd
        github-copilot-cli
        (nerdfonts.override { fonts = [ "CascadiaMono" ]; })
      ] ++ (if stdenv.isDarwin then [ raycast colima ] else [ google-chrome ]);

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.

    stateVersion = "23.11";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      mutableExtensionsDir = true;

      package = pkgs.vscode.fhs;

      extensions = with pkgs.vscode-extensions; [
        ms-vscode-remote.remote-ssh
        ms-python.python
        catppuccin.catppuccin-vsc-icons
        catppuccin.catppuccin-vsc
        github.copilot
        github.copilot-chat
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        eval "$(${pkgs.fnm}/bin/fnm env --use-on-cd --corepack-enabled --resolve-engines)"
        export ATUIN_NOBIND=1
        eval "$(${pkgs.atuin}/bin/atuin init zsh)"
        bindkey '^r' _atuin_search_widget
        eval "$(${pkgs.github-copilot-cli}/bin/github-copilot-cli alias -- \"$0\")"

      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "gitfast"
          "common-aliases"
          "docker"
          "docker-compose"
          "ssh-agent"
        ];
      };

      shellAliases = {
        cd = "z";
        l = "eza -lah --icons --group-directories-first";
      };
    };

    starship = {
      enable = true;

      settings = {
        username = {
          disabled = false;
          show_always = true;
        };

        hostname = { ssh_only = false; };
      };
    };

    git = {
      enable = true;

      # Core section configuration
      core = {
        editor = "code -w -n";
        autocrlf = "input";
        fileMode = false;
        whitespace = "-trailing-space";
      };

      # Stash section configuration
      stash = { showPatch = true; };

      # Log section configuration
      log = { decorate = "full"; };

      # Color section configuration
      color = {
        status = {
          added = "green";
          changed = "yellow bold";
          untracked = "red bold";
        };
      };

      # Rebase section configuration
      rebase = { autostash = true; };

      # Pull section configuration
      pull = { rebase = true; };
    };

    fd = {
      enable = true;
      ignores = [
        "**/.cache"
        "**/.local"
        "**/.android"
        "**/.npm"
        "**/.tldr"
        "**/.vscode-server"
        "**/.gnupg"
        "**/.config"
        "**/.git"
        "**/node_modules"
      ];
    };

    eza = {
      enableAliases = true;
      enable = true;
      enableZshIntegration = true;
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
        pager = "${pkgs.bat}/bin/bat";
      };
    };

    kitty = {
      enable = true;
      font = { name = "CascadiaMono"; };
      settings = { enable_audio_bell = false; };
    };

    bat = { enable = true; };
    ripgrep = { enable = true; };
    zoxide = { enable = true; };
    jq = { enable = true; };
    fzf = { enable = true; };
    yt-dlp = { enable = true; };
    bottom = { enable = true; };
    lazygit = { enable = true; };
  };

  services = { vscode-server = { enable = true; }; };

  # plain files is through 'home.file'.
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/clementcouriol/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { EDITOR = "nvim"; };

}
