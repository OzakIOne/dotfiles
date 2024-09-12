{ pkgs, lib, ... }:
let
  unstable-packages = with pkgs.unstable; [
    coreutils
    curl
    fd
    fx
    jq
    yq
    git
    duf
    ffmpeg
    atuin
    make
    lazydocker
    ncdu
    fnm
    atuin
    ollama
    lazydocker
    tealdeer
    github-copilot-cli
    zoxide
    tmux
    glow
    bun
    gh
    fzf
    unzip
    wget
    zip
    # shell better alternatives
    neovim
    ripgrep
    ugrep
    bat
    btop
    bottom
    dust
    # nix
    statix
    deadnix
    alejandra
    nh
    nixfmt
    nvd
    nil
  ];
  stable-packages = with pkgs;
    [ (nerdfonts.override { fonts = [ "CascadiaMono" ]; }) ]
    ++ (if stdenv.isDarwin then [ raycast colima ] else [ google-chrome ]);
in {
  nixpkgs = { config = { allowUnfree = true; }; };
  nixpkgs.config.allowUnfreePredicate = _: true;

  home = {
    username = "clementcouriol";
    homeDirectory = "/Users/clementcouriol";
    packages = stable-packages ++ unstable-packages;
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
        # catppuccin.catppuccin-vsc-icons
        # catppuccin.catppuccin-vsc
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
        ls = "eza";
        l = "eza -lah --icons --group-directories-first";
        ll = "eza -lh --icons --group-directories-first";
        tree = "eza --tree";
        cat = "bat";
        ccat = "cat";
      };
    };

    starship = {
      enable = true;
      settings = {
        format =
          lib.concatStrings [ "$fill" "$time $all" "$character" "$line_break" ];
        add_newline = false;
        directory = { truncation_length = 5; };
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
        docker_context = {
          only_with_files = false;
          format = "via [🐋 $context](blue bold)";
        };
        deno = { format = "via [🦕 $version](green bold)"; };
        nodejs = { format = "via [🤖 $version](green bold)"; };
        fill = {
          symbol = "-";
          style = "bold #AAAAAA";
        };
        hostname = { ssh_only = true; };
        sudo = {
          style = "bold green";
          symbol = "sudo";
          disabled = true;
        };
        username = {
          show_always = true;
          format = "[$user ]($style)";
          style_user = "red bold";
          style_root = "yellow bold";
        };
        container = { disabled = true; };
        memory_usage = {
          format = "$symbol[\${ram}( | \${swap})]($style)";
          threshold = 0;
          style = "bold dimmed white";
          disabled = true;
        };
        localip = {
          ssh_only = false;
          format = "[$localipv4](bold red)";
          disabled = true;
        };
        shell = {
          style = "cyan bold";
          disabled = true;
        };
        time = {
          disabled = false;
          format = "[$time]($style)";
          style = "bold bright-black";
          time_format = "%T";
          utc_time_offset = "+2";
          time_range = "10:00:00-14:00:00";
        };
      };
    };

    git = {
      enable = true;

      core = {
        editor = "code -w -n";
        autocrlf = "input";
        fileMode = false;
        whitespace = "-trailing-space";
        pager = "${pkgs.delta}/bin/bat";
      };
      rerere = { enabled = true; };
      push = { autoSetupRemote = true; };
      user = {
        name = "ozakione";
        email = "29860391+OzakIOne@users.noreply.github.com";
      };

      delta = {
        navigate = true;
        line-numbers = true;
      };

      stash = { showPatch = true; };

      log = { decorate = "full"; };

      # Color section configuration
      color = {
        status = {
          added = "green";
          changed = "yellow bold";
          untracked = "red bold";
        };
      };

      pull = { rebase = true; };
      rebase = { autostash = true; };
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
      extensions = with pkgs;
        [
          gh-poi
          # gh-copilot
        ];

    };

    kitty = {
      enable = true;
      font = { name = "CascadiaMono"; };
      settings = { enable_audio_bell = false; };
    };

    jq = { enable = true; };
    bat = { enable = true; };
    fzf = { enable = true; };
    delta = { enable = true; };
    yt-dlp = { enable = true; };
    zoxide = { enable = true; };
    bottom = { enable = true; };
    ripgrep = { enable = true; };
    lazygit = { enable = true; };
  };

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
