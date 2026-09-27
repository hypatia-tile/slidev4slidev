{
  description = "slidev4slidev: a Slidev deck about Slidev, deployed to Vercel";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        # Keep nodejs and pnpm in sync with `engines.node` and `packageManager` in package.json.
        default = pkgs.mkShell {
          packages = [
            pkgs.nodejs_24
            pkgs.pnpm
            pkgs.lefthook
          ];
          shellHook = ''
            if [ -f lefthook.yml ]; then lefthook install >/dev/null; fi
          '';
        };
      });
    };
}
