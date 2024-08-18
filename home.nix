{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "itsscb";
  home.homeDirectory = "/home/itsscb";
  home.file.".config/gtk-3.0/bookmarks".source = ./dotfiles/nemo-bookmarks;
  home.file.".config/gtk-4.0/bookmarks".source = ./dotfiles/nemo-bookmarks;
  # home.file.".config/nemo/dconf/user".text = ''
  #   [org/nemo/preferences]
  #   default-folder-viewer='list-view'
  # '';

  home.stateVersion = "23.11"; # Please read the comment before changing.

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "FiraCode";
      size = 10;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # accounts = {
  #   email = {
  #     accounts = {
  #       "itsscb" = {
  #         primary = true;
  #         thunderbird.profiles = ["itsscb"];
  #         address = "dev@itsscb.de";
  #         imap = {
  #           host = "smtp.strato.de";
  #           port = 465;
  #           tls = {
  #             enable = true;
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

  programs = {
    # thunderbird = {
    #   enable = true;
    #   settings = {
    #     "privacy.donottrackheader.enabled" = true;
    #   };

    #   profiles = {
    #     "itsscb" = {
    #       isDefault = true;
    #       # settings = {
    #       #   "mail.spellcheck.inline" = false;
    #       # };
    #     };
    #     "b.sc" = {
    #       # settings = {
    #       #   "mail.spellcheck.inline" = false;
    #       # };
    #     };
    #   };
    # };

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "onedark";
        editor = {
          line-number = "relative";
          bufferline = "multiple";
          auto-completion = true;
          auto-save = true;
          auto-format = true;
          soft-wrap.enable = true;
          soft-wrap.max-indent-retain = 80;
          cursorline = true;
          gutters = [
            "diff"
            "diagnostics"
            "line-numbers"
            "spacer"
          ];
          text-width = 80;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          statusline = {
            left = [
              "mode"
              "spinner"
              "file-modification-indicator"
              "read-only-indicator"
            ];

            center = ["file-name"];

            right = [
              "diagnostics"
              "register"
              "selections"
              "position"
              "file-encoding"
              "file-line-ending"
              "file-type"
            ];

            separator = "|";
          };

          lsp = {
            enable = true;
            auto-signature-help = true;
            display-messages = true;
            display-inlay-hints = true;
          };

          indent-guides = {
            render = true;
            character = "┊";
            skip-levels = 1;
          };
        };
        keys.insert.j.k = "normal_mode";
        keys.insert."C-c" = "normal_mode";
        keys.insert."C-right" = ["move_next_word_end" "move_char_right"];
        keys.insert."C-left" = "move_prev_word_start";

        keys.normal.g.a = "code_action";
        keys.normal."C-s" = ":w";
        keys.normal."C-right" = ["move_next_word_end" "move_char_right"];
        keys.normal."C-left" = "move_prev_word_start";
      };
    };

    bash = {
      enable = true;
      shellAliases = {
        ls = "eza -l --git";
        grep = "rg";
        cat = "bat";
      };
    };

    git = {
      enable = true;
      userName = "itsscb";
      userEmail = "dev@itsscb.de";
      extraConfig = {
        credential.helper = "store";
        http.postBuffer = 157286400;
      };
    };

    vim = {
      enable = true;
    };

    chromium = {
      enable = true;
      commandLineArgs = [
        "--disable-default-apps"
        "--homepage https://perplexity.ai"
        "--start-maximized"
        "--enable-features=WebContentsForceDark"
        "--force-dark-mode"
      ];
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/desktop/background".picture-uri = "file:///etc/nixos/dotfiles/hypr/rust.png";
    settings."org/gnome/desktop/background".picture-uri-dark = "file:///etc/nixos/dotfiles/hypr/rust.png";
    settings."org/gnome/desktop/screensaver" = {
      picture-uri = "file:///etc/nixos/dotfiles/hypr/rust.png";
      picture-uri-dark = "file:///etc/nixos/dotfiles/hypr/rust.png";
    };
    settings."org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
    # settings."org/gnome/desktop/background".picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/keys-d.jpg";
    # settings."org/gnome/desktop/background".picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/keys-l.jpg";
    # settings."org/gnome/desktop/background".primary-color = "#aaaaaa";
    # settings."org/gnome/desktop/background".secondary-color = "#000000";
    settings."org/gnome/desktop/interface".show-battery-percentage = true;
    settings."org/gnome/settings-daemon/plugins/media-keys".home = ["<Super>e"];
    settings."org/gnome/settings-daemon/plugins/media-keys".control-center = ["<Super>i"];
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".binding = "<Super>t";
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".command = "alacritty";
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".name = "gt1";

    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1".binding = "<Control><Alt>t";
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1".command = "alacritty";
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1".name = "gt2";
    settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
  };
  home.packages = with pkgs; [
    nemo
    texlab
    (texlive.combine {
      inherit (texlive) scheme-full
      latex-bin
      latexindent
      biber
      biblatex
      pgf
      tikz-cd
      xcolor
      titlesec
      fontawesome5
      fontawesome
      amsmath
      amsfonts
      hyperref
      geometry
      fontspec
      latexmk;
    })
  ];
  # wayland.windowManager = {
  #   hyprland = {
  #     enable = true;
  #     settings = {
  #       exec-once = [
  #         "swww-daemon"
  #         "swww img /etc/nixos/dotfiles/hypr/rust.png"
  #         "nm-applet --indicator"
  #         "blueman-applet"
  #         "waybar"
  #         "dunst"
  #       ];

  #       "$terminal" = "alacritty";
  #       "$fileManager" = "kitty yazi";
  #       # "$fileManager" = "dolphin";
  #       "$menu" = "rofi -show drun";

  #       "$mod" = "SUPER";

  #       monitor = ",preferred,auto,1";

  #       general = {
  #         layout = "master";
  #         gaps_in = 5;
  #         gaps_out = 20;
  #         border_size = 2;
  #         "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
  #         "col.inactive_border" = "rgba(595959aa)";

  #         allow_tearing = false;
  #       };

  #       decoration = {
  #         rounding = 10;

  #         blur = {
  #           enabled = true;
  #           size = 3;
  #           passes = 1;
  #         };

  #         drop_shadow = "yes";
  #         shadow_range = 4;
  #         shadow_render_power = 3;
  #         "col.shadow" = "rgba(1a1a1aee)";
  #       };

  #       animations = {
  #         enabled = "yes";

  #         bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

  #         animation = [
  #           "windows, 1, 7, myBezier"
  #           "windowsOut, 1, 7, default, popin 80%"
  #           "border, 1, 10, default"
  #           "borderangle, 1, 8, default"
  #           "fade, 1, 7, default"
  #           "workspaces, 1, 6, default"
  #         ];
  #       };

  #       gestures = {
  #         workspace_swipe = "off";
  #       };

  #       misc = {
  #         force_default_wallpaper = 0;
  #       };

  #       windowrulev2 = "suppressevent maximize, class:.*";

  #       input = {
  #         follow_mouse = 2;

  #         touchpad = {
  #           natural_scroll = "yes";
  #         };
  #       };

  #       # master = {
  #       #   new_is_master = false;
  #       # };

  #       bindm = [
  #         "$mod, mouse:272, movewindow"
  #         "$mod, mouse:273, resizewindow"
  #       ];

  #       bind =
  #         [
  #           "$mod, T, exec, $terminal"
  #           "$mod, L, exec, hyprlock"
  #           "$mod, Q, exec, $terminal"
  #           "$mod SHIFT, L, exit"
  #           "$mod, C, killactive"
  #           "$mod, E, exec, $fileManager"
  #           "$mod, V, exec, togglefloating"
  #           "$mod, R, exec, $menu"
  #           "$mod, P, pseudo,"
  #           "$mod, O, togglesplit,"
  #           "$mod, U, fullscreen,"
  #           "$mod, P, focuscurrentorlast,"
  #           "$mod, P, movewindow,l"
  #           # "$mod, H, movefocus, l"
  #           # "$mod, K, movefocus, u"
  #           "$mod, J, movefocus, d"
  #           "$mod, S, togglespecialworkspace, magic"
  #           "$mod SHIFT, S, movetoworkspace, special:magic"
  #           "$mod, mouse_down, workspace, e+1"
  #           "$mod, mouse_up, workspace, e-1"
  #         ]
  #         ++ (
  #           # workspaces
  #           # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  #           builtins.concatLists (builtins.genList (
  #               x: let
  #                 ws = let
  #                   c = (x + 1) / 10;
  #                 in
  #                   builtins.toString (x + 1 - (c * 10));
  #               in [
  #                 "$mod, ${ws}, workspace, ${toString (x + 1)}"
  #                 "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
  #               ]
  #             )
  #             10)
  #         );
  #     };
  #   };
  # };

  home.file = {
    # ".config/hypr/hyprlock.conf".source = ./dotfiles/hypr/hyprlock.conf;
    # ".config/waybar".source = ./dotfiles/waybar;
    ".config/helix/languages.toml".source = ./dotfiles/helix/languages.toml;
    # ".config/rofi/config.rasi".source = ./dotfiles/rofi/config.rasi;
  };

  home.sessionVariables = {
    KEEPASSXC_DATABASE_PATH = "/mnt/home/pwdb.kdbx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
