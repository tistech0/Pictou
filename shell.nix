{ pkgs ? import <nixpkgs> {} }:

let
  libjxl-0-10-2 = pkgs.libjxl.overrideAttrs (old: {
    version = "0.10.2";
    src = pkgs.fetchFromGitHub {
      owner = "libjxl";
      repo = "libjxl";
      rev = "v0.10.2";
      hash = "sha256-Ip/5fbzt6OfIrHJajnxEe14ppvX1hJ1FSJUBEE/h5YQ=";
      # There are various submodules in `third_party/`.
      fetchSubmodules = true;
    };
  });
in
  pkgs.mkShell {
    name = "pictou";
    buildInputs = with pkgs; [
      pre-commit
      diesel-cli
      postgresql
      libjxl-0-10-2
      python312
    ];

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    shellHook = ''
      pre-commit install
      cd back/image-classifier && source configure.sh
    '';
  }
