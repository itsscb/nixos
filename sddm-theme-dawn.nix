{pkgs}: let
  imgLink = "https://github.com/itsscb/nixos/blob/master/dotfiles/hypr/rust.png?raw=true";
  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-A6SJPjzcGueivWQZZh29bTb7oQeoLlgrKN660HF4ZWY=";
  };
in
  pkgs.stdenv.mkDerivation {
    name = "sddm-theme";
    src = pkgs.fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
      sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
    };
    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cd $out/
      rm Background.jpg
      cp -r ${image} $out/Background.jpg
    '';
  }
# pkgs.stdenv.mkDerivation {
#   name = "sddm-theme-dawn";
#   src = pkgs.fetchFromGitLab {
#     owner = "es20490446e";
#     repo = "sddm-theme-dawn";
#     rev = "154a2e19e81d3a35927a20dbfa82ea66a466f825";
#     sha256 = "sha256-dM9sebNNHelexhgZwkcXvl84NL9BY4kQCeDLBjeL6DY=";
#   };
#   installPhase = ''
#     mkdir -p $out
#     cp -R ./root/usr/share/sddm/themes/dawn/* $out/
#     rm $out/components/images/background/original.jpg
#     rm $out/components/images/background/blurred.jpg
#     cp -r ${image} $out/components/images/background/original.jpg
#     cp -r ${image} $out/components/images/background/blurred.jpg
#   '';
# }

