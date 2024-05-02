# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-ddb552e7-c477-4d71-899b-9224d6782b9f".device = "/dev/disk/by-uuid/ddb552e7-c477-4d71-899b-9224d6782b9f";
  networking.hostName = "scbnb"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  services.xserver = {
    layout = "us";
    xkbVariant = "";
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.itsscb = {
    isNormalUser = true;
    description = "itsscb";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #thunderbird
   ];
  };

home-manager.users.itsscb = { pkgs, ... }: {
  home.packages = [pkgs.firefox pkgs.git];
  home.stateVersion = "23.11";

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
    settings."org/gnome/desktop/background".picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/keys-d.jpg";
    settings."org/gnome/desktop/background".picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/keys-l.jpg";
    settings."org/gnome/desktop/background".primary-color = "#aaaaaa";
    settings."org/gnome/desktop/background".secondary-color = "#000000";
    settings."org/gnome/desktop/interface".show-battery-percentage = true;
    settings."org/gnome/settings-daemon/plugins/media-keys".home = ["<Super>e"];
    settings."org/gnome/settings-daemon/plugins/media-keys".control-center= ["<Super>i"];
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".binding= "<Super>t";
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".command= "gnome-terminal";
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".name= "gt1";

    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1".binding= "<Control><Alt>t";
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1".command= "gnome-terminal";
    settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1".name= "gt2";
    settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings= ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
  
  };
  
  programs.git = {
    enable = true;
    userName = "itsscb";
    userEmail = "dev@itsscb.de";
  };

  programs.bash = {
  enable = true;
  shellAliases = {
    ls = "eza -la --git";
    cat = "bat";
  };
  };
  home.file.".config/helix".source = ./configs/helix;
};

home-manager.users.root= { pkgs, ... }: {
  home.stateVersion = "23.11";
  home.file.".config/helix".source = ./configs/helix;
};

environment.variables.EDITOR = "hx";
  # Install firefox.
  # programs.firefox.enable = true;
# programs.google-chrome = {
#   enable = true;
#   defaultBrowser = true;
# };

# programs.helix = {
#   enabled = true;
#   defaultEditor = true;
# };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.chromium = {
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

services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  gnomeExtensions.appindicator
  
  inkscape
  gimp
  ffmpeg
  xclip
  eza
  bat
  ripgrep
  git
	rustup
	helix
	thunderbird
  google-chrome
  vlc
  spotify
  ];

programs.steam = {
	enable = true;
};

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

# services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
# [com.ubuntu.login-screen]
# background-color='#000000'
# background-size='cover'
# background-repeat='no-repeat'
# background-picture-uri='file:///etc/nixos/configs/black.png'
# '';

programs.nix-ld.enable = true;
programs.nix-ld.libraries = with pkgs; [
  # Add any missing dynamic libraries for unpackaged 
  # programs here, NOT in environment.systemPackages
];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
