{
  description = "Soothing pastel theme for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:

    let
      inherit (nixpkgs) lib;

      # Systems for public outputs
      systems = lib.systems.flakeExposed;

      # Systems for development related outputs
      # (that evaluate more exotic packages cleanly, unlike some systems above)
      devSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = lib.genAttrs systems;
      forAllDevSystems = lib.genAttrs devSystems;

      mkModule =
        {
          name ? "everforest",
          type,
          file,
        }:
        { pkgs, ... }:
        {
          _file = "${self.outPath}/flake.nix#${type}Modules.${name}";

          imports = [ file ];

          everforest.sources = lib.mkDefault self.packages.${pkgs.stdenv.hostPlatform.system};
        };
    in

    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          everforestPackages = (import ./default.nix { inherit pkgs; }).packages;
        in
        everforestPackages
        // {
          default = everforestPackages.timber;
        }
      );

      devShells = forAllDevSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = import ./shell.nix { inherit pkgs; };

          ci = pkgs.mkShellNoCC {
            packages = with pkgs; [
              nodejs-slim_22
              corepack
              nrr
            ];
          };
        }
      );

      formatter = forAllDevSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.treefmt.withConfig {
          runtimeInputs = with pkgs; [
            keep-sorted
            nixfmt-rfc-style
          ];

          settings = {
            on-unmatched = "info";
            tree-root-file = "flake.nix";

            formatter = {
              keep-sorted = {
                command = "keep-sorted";
                includes = [ "*" ];
              };
              nixfmt = {
                command = "nixfmt";
                includes = [ "*.nix" ];
              };
            };
          };
        }
      );

      homeModules = {
        default = self.homeModules.everforest;
        catppuccin = mkModule {
          type = "homeManager";
          file = ./modules/home-manager;
        };
      };

      nixosModules = {
        default = self.nixosModules.everforest;
        catppuccin = mkModule {
          type = "nixos";
          file = ./modules/nixos;
        };
      };
    };
}
