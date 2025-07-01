{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        packages = with pkgs; [
          envsubst # to enable tests which use absolute paths
          inotify-tools
        ];
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = packages;
          shellHook =
            ''
              if [ -z ''${LBLP_PLUGINS_DIR} ]; then
                echo "The environment variable LBLP_PLUGINS_DIR must be defined. Set it to the directory containing your compiled LBLP plugins (i.e. .wasm files)."
                exit 1
              fi
            '';

        };
      });
}
