{
  description = "A Nix flake for the auditory-eeg-dataset project.";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs =
    { self, nixpkgs-python, ... }@inputs:
    let
      # The systems supported for this flake's outputs
      supportedSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
      ];

      # Helper for providing system-specific attributes
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            inherit system;
            # Provides a system-specific, configured Nixpkgs
            pkgs = import inputs.nixpkgs {
              inherit system;
              # Enable using unfree packages
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      # Development environments output by this flake
      devShells = forEachSupportedSystem (
        { pkgs, system }:
        {
          # Run `nix develop` to activate this environment
          default = pkgs.mkShellNoCC {
            # The Nix packages provided in the environment
            packages = with pkgs; [
              self.formatter.${system}
              ponysay
              nixpkgs-python.packages.${system}."3.7"
              pkgs.stdenv.cc.cc.lib
            ];

            # Set any environment variables for your development environment
            env = {
              LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
            };

            # Add any shell logic you want executed when the environment is activated
            shellHook = "
              export PYTHONPATH=$(pwd):$PYTHONPATH
              python -m venv .venv
              source .venv/bin/activate
              pip install --upgrade pip > /dev/null
              pip install -r requirements.txt > /dev/null
            ";
          };
        }
      );
      # Nix formatter
      # To format all Nix files: git ls-files -z '*.nix' | xargs -0 -r nix fmt
      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt-rfc-style);
    };
}
