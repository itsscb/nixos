# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: let
  sops = builtins.fetchTarball {
    url = "https://github.com/Mic92/sops-nix/archive/master.tar.gz";
    sha256 = "1wzm5hs3cda6l7q9ls5nw16bifb00v5kan1xcab57bb5fg6qqnyb";
  };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
    (import "${sops}/modules/sops")
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-368f684f-d514-405f-a909-fb4488d19183".device = "/dev/disk/by-uuid/368f684f-d514-405f-a909-fb4488d19183";
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking = {
    hostName = "scbnb"; # Define your hostname.
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  services = {
    displayManager.sddm = {
      enable = true;
      theme = "${import ./sddm-theme-dawn.nix {inherit pkgs;}}";
    };

    xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
      };

      xkb = {
        layout = "us";
        variant = "";
      };

      excludePackages =
        (with pkgs; [
          nano
          xterm
        ])
        ++ (with pkgs.gnome; [
          cheese
          gnome-music
          epiphany
          geary
          totem
          tali
          iagno
          hitori
          atomix
        ]);
    };

    # Enable CUPS to print documents.
    printing.enable = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.groups.fsc = {
    gid = 1010;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.itsscb = {
    isNormalUser = true;
    uid = 1000;
    description = "itsscb";
    extraGroups = ["networkmanager" "wheel" "fsc"];
    packages = with pkgs; [
    ];
  };
  users.users."k.sc" = {
    isNormalUser = true;
    uid = 1001;
    description = "k.sc";
    extraGroups = ["networkmanager" "fsc"];
    packages = with pkgs; [
    ];
  };

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  programs = {
    steam = {
      enable = true;
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    chromium = {
      enable = true;
      homepageLocation = "https://start.duckduckgo.com";
      extraOpts = {
        syncDisabled = true;
        BrowserSignin = 0;
        PasswordManagerEnabled = false;
        SpellcheckEnabled = false;
      };
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://start.duckduckgo.com/?q={searchTerms}";
    };
  };

  environment = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    variables = {
      EDITOR = "hx";
    };
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  home-manager = {
    backupFileExtension = "backup";
    users = {
      "itsscb" = import ./home.nix;
      "root" = {
        home.stateVersion = "23.11";
        home.file.".config/helix".source = ./dotfiles/helix;
        programs.bash = {
          enable = true;
          shellAliases = {
            ls = "eza -la --git";
            grep = "rg";
            cat = "bat";
          };
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  xdg.portal.enable = true;

  environment.systemPackages = with pkgs; [
    # nix specific
    ## Secrets Manager
    sops

    ## nix formatter
    alejandra

    # Encryption
    age

    # Hyprland / Window Manager
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    ## App Starter
    rofi-wayland

    ## Network Settings
    networkmanagerapplet

    # Audio Settings
    pavucontrol

    ## Bluetooth Settings
    blueman

    ## Lockscreen
    hyprlock

    ## Top Bar
    waybar
    (
      waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      })
    )

    ## ???
    dunst

    ## Notification Daemone (?)
    libnotify

    ## File Manager
    # dolphin
    cinnamon.nemo
    breeze-icons

    ## ???
    swww

    # Clipboard Manager
    xclip

    # Image Manipulation
    inkscape
    gimp

    # Video
    ffmpeg
    vlc

    # Music
    spotify

    # Terminal
    alacritty

    ## 'ls' replacement
    eza

    ## 'cat' replacement
    bat

    ## 'grep' replacement
    ripgrep

    ## 'find' replacement
    fd

    ## Default Tools
    curl
    gitFull # git
    # broot # file manager
    yazi # file manager
    jq # json tool
    poppler # ???
    fzf # ???

    # Editor
    helix

    # Mail Client
    thunderbird
  ];

  sops.validateSopsFiles = false;
  sops.defaultSopsFile = "/etc/nixos/secrets/secrets.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/itsscb/.config/sops/age/keys.txt";

  sops.secrets."nas" = {
    owner = config.users.users.itsscb.name;
  };
  sops.secrets."git" = {
    owner = config.users.users.itsscb.name;
    path = "${config.users.users.itsscb.home}/.config/git/credentials";
  };

  fileSystems = {
    "/mnt/home" = {
      device = "//192.168.128.2/Cloud_Privat";
      fsType = "cifs";
      label = "HOME";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user";
      in ["${automount_opts},credentials=${config.sops.secrets."nas".path},uid=1000,gid=1010"];
    };
    "/mnt/music" = {
      device = "//192.168.128.2/music";
      fsType = "cifs";
      label = "HOME";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user";
      in ["${automount_opts},credentials=${config.sops.secrets."nas".path},uid=1000,gid=1010"];
    };
    "/mnt/scan" = {
      device = "//192.168.128.2/scan";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user";
      in ["${automount_opts},credentials=${config.sops.secrets."nas".path},uid=1000,gid=1010"];
    };
    "/mnt/shared" = {
      device = "//192.168.128.2/shared";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user";
      in ["${automount_opts},credentials=${config.sops.secrets."nas".path},uid=1000,gid=1010"];
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged
    # programs here, NOT in environment.systemPackages
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}
