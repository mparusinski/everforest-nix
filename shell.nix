{
  pkgs ? import <nixpkgs> {
    inherit system;
    config = { };
    overlays = [ ];
  },
  system ? builtins.currentSystem,
}:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    # Nix tools
    deadnix
    nixfmt-rfc-style
    nil
    statix

    # GHA lints
    actionlint
  ];

  shellHook = ''
    echo "Welcome to the mparusinski/everforest-nix repository! Thanks for contributing and have a wonderful day 🌲"
  '';
}
