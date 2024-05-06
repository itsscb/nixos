# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      # <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-ddb552e7-c477-4d71-899b-9224d6782b9f".device = "/dev/disk/by-uuid/ddb552e7-c477-4d71-899b-9224d6782b9f";
  networking.hostName = "scbnb"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb= {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.itsscb = {
    isNormalUser = true;
    description = "itsscb";
    extraGroups = [ "networkmanager" "wheel" ];
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
      enable=true;
      homepageLocation = "https://start.duckduckgo.com";
      extraOpts = {
        syncDisabled = true;
        BrowserSignin = 0;
        PasswordManagerEnabled = false;
        SpellcheckEnabled = false;
      };
      defaultSearchProviderEnabled= true;
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
  extraSpecialArgs = { inherit inputs; };
  backupFileExtension = "backup";
  users = {
    "itsscb" = import ./home.nix;
    "root" = {
      home.stateVersion = "23.11";
      home.file.".config/helix".source = ../../dotfiles/helix;
    };
  };
};

  nixpkgs.config.allowUnfree = true;

  xdg.portal.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    waybar
    (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      })
    )
    dunst
    libnotify
    
    swww
    dolphin
    networkmanagerapplet
    alacritty
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    rofi-wayland
    pavucontrol
    blueman
    hyprlock

    inkscape
    gimp
    ffmpeg
    xclip
    eza
    bat
    ripgrep
    gitFull
  	rustup
  	helix
    # vim
  	thunderbird

    vlc
    spotify
  ];

  services.xserver.excludePackages = (with pkgs; [
    nano
    xterm  
  ]) ++ ( with pkgs.gnome; [
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


  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged 
    # programs here, NOT in environment.systemPackages
  ];

  system.stateVersion = "23.11"; # Did you read the comment?

}
