{
  description = "xxx";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    devenv.url = "github:fmway/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    fmway-nix.url = "github:fmway/fmway.nix";
    fmway-nix.inputs.flake-parts.follows = "flake-parts";
    fmway-nix.inputs.nixpkgs.follows = "nixpkgs";
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
  };

  outputs = { fmway-nix, self, ... } @ inputs:
  fmway-nix.fmway.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" ];

    imports = [
      fmway-nix.flakeModules.nixpkgs
      fmway-nix.flakeModules.devenv
    ];

    perSystem = { pkgs, config, lib, ... }: {
      nixpkgs.overlays = [
        (self: super: {
          unstable = inputs.nixpkgs-unstable.legacyPackages.${self.system};
        })
      ];
      devenv.modules = [
        { _module.args.flake = self; }
        fmway-nix.devenvModules.some
      ];

      packages.default = let
        shell = config.devenv.shells.default;
        isDevboxed = x: lib.any (y: x == y) [
          "DEVENV_ROOT"
          "DEVENV_STATE"
          "DEVENV_DOTFILE"
        ];
        init = pkgs.writeScriptBin "env-init" /* bash */ ''
          ${lib.pipe shell.env [
            (lib.attrNames)
            (map (x:
              "export ${x}=${
                lib.optionalString (isDevboxed x) "$DEVBOX_WD" +
                lib.escapeShellArg shell.env.${x}
              }"
            ))
            (lib.concatStringsSep "\n")
          ]}
        '';
      in pkgs.symlinkJoin {
        inherit (shell) name;
        paths = shell.packages ++ [
          init
        ];
      };

      devenv.shells.default.imports = [ ./devenv.nix ];
    };
  };
}
