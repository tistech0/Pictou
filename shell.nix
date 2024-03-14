{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "pictou";
  buildInputs = with pkgs; [
    pre-commit
    diesel-cli
    postgresql
  ];

  shellHook = ''
    pre-commit install
  '';
}
