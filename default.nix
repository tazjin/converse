# This Nix derivation imports the generated Carnix sources and builds
# Converse.
#
# To work around an issue in Carnix ([1] & [2]) the attributes of the
# comrak crate have been overridden with a dummy environment variable
# to simulate a Cargo-based build. This requires a manual change to
# `Cargo.nix` when updating dependencies.
#
# [1]: https://nest.pijul.com/pmeunier/carnix/discussions/2
# [2]: https://nest.pijul.com/pmeunier/carnix/discussions/3

{ pkgs ? import <nixpkgs> {}}:

let cargo = pkgs.callPackage ./Cargo.nix {};
in cargo.converse {}
