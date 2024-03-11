{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "pictou";
  buildInputs = with pkgs; [
    pre-commit
    diesel-cli
  ];

  shellHook = ''
    pre-commit install
  '';
}
