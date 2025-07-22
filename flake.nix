{
  description = "kobweb-cli flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in rec {
        packages = rec {
          kobweb-cli = pkgs.stdenv.mkDerivation rec {
            name = "kobweb-cli";
            version = "0.9.18";
            src = builtins.fetchurl {
              url = "https://github.com/varabyte/kobweb-cli/releases/download/v${version}/kobweb-${version}.tar";
              sha256 = "sha256:1whz5qsqfbqickzafp6jpv0ckh39lr3ssqzksmgp5cwc6i38ff06";
            };
            nativeBuildInputs = [ pkgs.makeWrapper ];
            unpackPhase = ''
              tar -xf $src "kobweb-${version}"
              mv "kobweb-${version}" source
            '';

            installPhase = ''
              mkdir -p $out/bin
              cp -r source/* $out/
              chmod +x $out/bin/kobweb
              wrapProgram $out/bin/kobweb \
                --prefix PATH : ${pkgs.jdk17}/bin
            '';
            # Gradle dependency hash. Set to empty to rebuild.
          };
          default = kobweb-cli;
        };

        defaultPackage = packages.default;
      }
    );
}
