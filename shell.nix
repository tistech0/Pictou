{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "pictou";
  buildInputs = with pkgs; [
    pre-commit
  ];

  shellHook = ''
    pre-commit install
  '';
}
