{
  description = "A very basic flake";


  inputs = { flake-utils.url = github:numtide/flake-utils; };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        packages = {
          nix-tester = pkgs.poetry2nix.mkPoetryApplication {
            projectDir = ./.;
          };

          nix-tester-docker-image = pkgs.dockerTools.buildLayeredImage {
            name = "nix-tester-docker-image";
            tag = "latest";
            contents = [ packages.nix-tester.dependencyEnv ];
            config = {
              Cmd = [ "${packages.nix-tester.dependencyEnv}/bin/gunicorn" "--bind=0.0.0.0:8081" "nix_tester.app:app" ];

              ExposedPorts = {
                "8081/tcp" = { };
              };
            };
          };

        };

        defaultPackage = packages.nix-tester;

        apps = {
          nix-tester = flake-utils.lib.mkApp {
            drv = defaultPackage;
            name = "nix-tester";
          };
        };

        defaultApp = apps.nix-tester;

        devShell = pkgs.mkShell {
          buildInputs = [
            (pkgs.poetry2nix.mkPoetryEnv { projectDir = ./.; })
          ];

          shellHook = ''
            poetry run true
          '';
        };

      }
    );
}
