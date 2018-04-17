{ pkgs ? import <nixpkgs> {}
, doCheck ? true }:

# This pins the nixpkgs version to an - admittedly arbitrarily chosen
# - commit with the correct dependencies.
# This should be removed once the majority of relevant machines are
# running NixOS 18.03.

let unstable = import (pkgs.fetchFromGitHub {
  owner  = "NixOS";
  repo   = "nixpkgs-channels";
  rev    = "ea145b68a019f6fff89e772e9a6c5f0584acc02c";
  sha256 = "18jr124cbgc5zvawvqvvmrp8lq9jcscmn5sg8f5xap6qbg1dgf22";
}) {};
in with unstable; rustPlatform.buildRustPackage rec {
  name        = "converse-${version}";
  version     = "0.1.0";
  src         = ./.;
  cargoSha256 = "0a0634v22wazmyym05x4ricqkxwn4r3spv6s2f3ilma65cy6qyrf";

  buildInputs = [ openssl pkgconfig postgresql.lib ];

  inherit doCheck;

  meta = with stdenv.lib; {
    description = "A simple forum software";
    homepage    = "https://github.com/tazjin/converse";
    license     = licenses.agpl3;
    maintainers = [ maintainers.tazjin ];
  };
}
