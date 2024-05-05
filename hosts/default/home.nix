{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "itsscb";
  home.homeDirectory = "/home/itsscb";

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   settings = {
  #     # "$mod" = "SUPER";
  #     "exec-once" = "/etc/nixos/dotfiles/hypr/init.sh";
  #   };
  # };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  programs = {
    bash = {
      enable = true;
      shellAliases = {
        ls = "eza -la --git";
        cat = "bat";
      };
    };

    git = {
      enable = true;
      userName = "itsscb";
      userEmail = "dev@itsscb.de";
    };

    chromium = {
      enable=true;
      commandLineArgs = [
        "--disable-default-apps"
        "--homepage https://start.duckduckgo.com"
        "--start-maximized"
        
      ];
      # homepageLocation = "https://start.duckduckgo.com";
      # extraOpts = {
      #   syncDisabled = true;
      #   BrowserSignin = 0;
      #   PasswordManagerEnabled = false;
      #   SpellcheckEnabled = false;
      # };
      # defaultSearchProviderEnabled= true;
      # defaultSearchProviderSearchURL = "https://start.duckduckgo.com/?q={searchTerms}";
    };
  };

  # dconf = {
  #   enable = true;
  #   settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  #   settings."org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
  #   settings."org/gnome/desktop/background".picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/keys-d.jpg";
  #   settings."org/gnome/desktop/background".picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/keys-l.jpg";
  #   settings."org/gnome/desktop/background".primary-color = "#aaaaaa";
  #   settings."org/gnome/desktop/background".secondary-color = "#000000";
  #   settings."org/gnome/desktop/interface".show-battery-percentage = true;
  #   settings."org/gnome/settings-daemon/plugins/media-keys".home = ["<Super>e"];
  #   settings."org/gnome/settings-daemon/plugins/media-keys".control-center= ["<Super>i"];
  #   settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".binding= "<Super>t";
  #   settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".command= "gnome-terminal";
  #   settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".name= "gt1";

  #   settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1".binding= "<Control><Alt>t";
  #   settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1".command= "gnome-terminal";
  #   settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1".name= "gt2";
  #   settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings= ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];

  # };  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
wayland.windowManager.hyprland.enable = true;
# wayland.windowManager.hyprland.plugins = [
#   inputs.hyprlock.packages."${pkgs.system}".hyprlock
# ];
wayland.windowManager.hyprland.settings = {
    
    exec-once = [
      "swww-daemon"
      "swww img /etc/nixos/dotfiles/hypr/rust.png"
      "nm-applet --indicator"
      "waybar"
      "dunst"
    ];
    
    "$terminal" = "alacritty";
    "$fileManager" = "dolphin";
    "$menu" = "rofi -show drun";
    
    "$mod" = "SUPER";

    monitor = ",preferred,auto,1";

    general = {
      layout = "master";
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      allow_tearing = false;
    };


    decoration = {
      rounding = 10;

      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };

      drop_shadow = "yes";
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
    };

    animations = {
      enabled = "yes";

      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
      
    };

    gestures = {
      workspace_swipe = "off";
    };

    misc = {
      force_default_wallpaper = 0;
    };

    windowrulev2 = "suppressevent maximize, class:.*";
    
    input = {
      # kb_layout = us;
      follow_mouse = 2;

      touchpad = {
        natural_scroll = "yes";  
      };

      # sensitivity = 0;
    };

    master = {
      new_is_master = false;
    };

    # env = [
    #   "XCURSOR_SIZE,24"
    #   "QT_QPA_PLATFORMTHEME,qt5ct"
    # ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    
    bind =
      [
        "$mod, T, exec, $terminal"
        "$mod, Q, exec, $terminal"
        "$mod, M, exit"
        "$mod, C, killactive"
        "$mod, E, exec, $fileManager"
        "$mod, V, exec, togglefloating"
        "$mod, R, exec, $menu"
        "$mod, P, pseudo,"
        "$mod, O, togglesplit,"
        "$mod, U, fullscreen,"
        "$mod, P, focuscurrentorlast,"
        "$mod, P, movewindow,l"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
  };  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/helix".source = ../../dotfiles/helix;
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
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/itsscb/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
