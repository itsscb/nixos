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
      grub = {
        splashImage = "./dotfiles/hypr/rust.png";
      };
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices."luks-368f684f-d514-405f-a909-fb4488d19183".device = "/dev/disk/by-uuid/368f684f-d514-405f-a909-fb4488d19183";
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking = {
    hostName = "scbnb"; # Define your hostname.
    networkmanager.enable = true;
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
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

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
        layout = "us,de";
        variant = ",";
        options = "grp:alt_shift_toggle";
      };

      excludePackages =
        (with pkgs; [
          nano
          xterm
          epiphany
          cheese
          geary
          totem
        ])
        ++ (with pkgs.gnome; [
          gnome-music
          tali
          iagno
          hitori
          atomix
        ]);
    };

    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = [
        pkgs.gutenprint
      ];
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
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
      homepageLocation = "https://perplexity.ai";
      extraOpts = {
        syncDisabled = true;
        BrowserSignin = 0;
        PasswordManagerEnabled = false;
        SpellcheckEnabled = false;
      };
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://perplexity.ai/search?q={searchTerms}";
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
    graphics.enable = true;
    nvidia.modesetting.enable = true;

    printers = {
      ensurePrinters = [
        {
          name = "ITSP0001";
          # deviceUri = "ipp://192.168.128.3/ipp/print";
          deviceUri = "socket://192.168.128.3";
          # model = "Kyocera/Kyocera-ECOSYS-M5526cdn.ppd.gz";
          model = "drv:///sample.drv/generic.ppd";

          # model = "Kyocera/Kyocera-FS-1025MFP-KPDL-en.ppd.gz";
        }
      ];
    };
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
            ls = "eza -l --git";
            grep = "rg";
            cat = "bat";
          };
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  xdg = {
    portal.enable = true;
    mime = {
      defaultApplications = {
        "text/html" = "chromium-browser.desktop";
        "application/pdf" = "org.gnome.Evince.desktop";
        "text/plain" = "Helix.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/jpg" = "org.gnome.Loupe.desktop";
        "video/mp4" = "vlc.desktop";
        "audio/mpeg" = "vlc.desktop";
        "x-scheme-handler/http" = "chromium-browser.desktop";
        "x-scheme-handler/https" = "chromium-browser.desktop";
        "inode/directory" = "yazi.desktop";
      };
    };
  };

  qt.enable = true;
  environment.systemPackages = with pkgs; [
    # nix specific
    ## Secrets Manager
    sops

    # Password Manager
    keepassxc

    ## nix formatter
    alejandra

    # Encryption
    age

    # SDDM Login Screen requirements
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

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

    ## Notification Daemon (?)
    libnotify

    ## File Manager
    # dolphin
    cinnamon.nemo
    breeze-icons

    ## ???
    swww

    # Clipboard Manager
    # xclip
    # xsel
    wl-clipboard

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
    kitty

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
