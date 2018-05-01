# Most of this file was generated using `carnix`, however some fixes
# have been applied manually. When upgrading dependencies, care must
# be taken to not break those fixes:
#
# 1. Carnix derivations break if a crate's features start with a
#    number, which is the case for several of Diesel's features. Those
#    have had quotes added around them to fix the issue.
#
# 2. The last line of the derivation has been modified to return the
#    derivation for Converse itself, rather than an attribute set of
#    all crate derivations.
#
# 3. To fix an issue building Comrak, the Markdown parser, the
#    derivation attributes have been overridden to provide a "dummy"
#    environment variable that Comrak's binary attempts to read during
#    the build.
#    Unfortunately Carnix can not currently be configured to not build
#    the binary of a dependency (even if the relevant feature is
#    disabled), so this workaround is required.

{ pkgs ? import <nixpkgs> {} }:

with pkgs; let kernel = buildPlatform.parsed.kernel.name;
    abi = buildPlatform.parsed.abi.name;
    include = includedFiles: src:
      # The comments assume the `include` field of the Cargo.toml like:
      # include = [ "foo", "bar" ]
      # and the package is being built from /mypackage
      #
      # includeFiles == [ "foo" "bar" ]
      let
        # and includedFileAbsolutePaths == [ "/mypackage/foo" "/mypackage/bar" ]
        includedFileAbsolutePaths = builtins.map (relativePath: toString (src + ("/" + relativePath))) includedFiles;

        # Return true only when a possible path exactly matches an
        # absolute path, ie:
        #
        #     checkExactMatch "/mypackage/foo" == true
        #     checkExactMatch "/mypackage/foo/bar" == false
        #     checkExactMatch "/mypackage/baz" == false
        checkExactMatch = possiblePath: builtins.elem possiblePath includedFileAbsolutePaths;

        # Return true only when a possible path is a suffix to a
        # directory described by the include.
        #
        #     checkPrefixMatch "/mypackage/buzfoo" == false
        #     checkPrefixMatch "/mypackage/foo" == false
        #     checkPrefixMatch "/mypackage/foo/bar" == true
        #     checkPrefixMatch "/mypackage/baz/foo" == false
        checkPrefixMatch = possiblePath: lib.lists.any
          (acceptablePrefix: lib.strings.hasPrefix "${acceptablePrefix}/" possiblePath)
          includedFileAbsolutePaths;

      in builtins.filterSource (possiblePath: _type:
          builtins.trace "${possiblePath}" ((checkExactMatch possiblePath) || (checkPrefixMatch possiblePath))
      )
      src;
    updateFeatures = f: up: functions: builtins.deepSeq f (lib.lists.foldl' (features: fun: fun features) (lib.attrsets.recursiveUpdate f up) functions);
    mapFeatures = features: map (fun: fun { features = features; });
    mkFeatures = feat: lib.lists.foldl (features: featureName:
      if feat.${featureName} or false then
        [ featureName ] ++ features
      else
        features
    ) [] (builtins.attrNames feat);
in
rec {
  converse = f: converse_0_1_0 { features = converse_0_1_0_features { converse_0_1_0 = f; }; };
  actix_0_5_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "actix";
    version = "0.5.6";
    authors = [ "Nikolay Kim <fafhrd91@gmail.com>" ];
    sha256 = "13n1fq51banr49xd3pcxwdjciqhmbcpn32ym2m5rpa4bifpvid59";
    libPath = "src/lib.rs";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  actix_web_0_5_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "actix-web";
    version = "0.5.6";
    authors = [ "Nikolay Kim <fafhrd91@gmail.com>" ];
    sha256 = "1xadbnpp7b12xfjzbnzzv3l3lfm836mvhqapz3nl7hwanidgsakf";
    libPath = "src/lib.rs";
    libName = "actix_web";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  actix_derive_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "actix_derive";
    version = "0.2.0";
    authors = [ "Callym <hi@callym.com>" "Nikolay Kim <fafhrd91@gmail.com>" ];
    sha256 = "0mh7wmw4kb8vy6pqzhis2y4qqfdz86c1zn4ns4knmvq3rqcjgqpa";
    procMacro = true;
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  adler32_1_0_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "adler32";
    version = "1.0.2";
    authors = [ "Remi Rampin <remirampin@gmail.com>" ];
    sha256 = "1974q3nysai026zhz24df506cxwi09jdzqksll4h7ibpb5n9g1d4";
    inherit dependencies buildDependencies features;
  };
  aho_corasick_0_6_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.6.4";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "189v919mp6rzzgjp1khpn4zlq8ls81gh43x1lmc8kbkagdlpq888";
    libName = "aho_corasick";
    crateBin = [ {  name = "aho-corasick-dot"; } ];
    inherit dependencies buildDependencies features;
  };
  ansi_term_0_11_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "ansi_term";
    version = "0.11.0";
    authors = [ "ogham@bsago.me" "Ryan Scheel (Havvy) <ryan.havvy@gmail.com>" "Josh Triplett <josh@joshtriplett.org>" ];
    sha256 = "08fk0p2xvkqpmz3zlrwnf6l8sj2vngw464rvzspzp31sbgxbwm4v";
    inherit dependencies buildDependencies features;
  };
  antidote_1_0_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "antidote";
    version = "1.0.0";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1x2wgaw603jcjwsfvc8s2rpaqjv0aqj8mvws2ahhkvfnwkdf7icw";
    inherit dependencies buildDependencies features;
  };
  arrayvec_0_4_7_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "arrayvec";
    version = "0.4.7";
    authors = [ "bluss" ];
    sha256 = "0fzgv7z1x1qnyd7j32vdcadk4k9wfx897y06mr3bw1yi52iqf4z4";
    inherit dependencies buildDependencies features;
  };
  atty_0_2_10_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "atty";
    version = "0.2.10";
    authors = [ "softprops <d.tangren@gmail.com>" ];
    sha256 = "1h26lssj8rwaz0xhwwm5a645r49yly211amfmd243m3m0jl49i2c";
    inherit dependencies buildDependencies features;
  };
  backtrace_0_2_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "backtrace";
    version = "0.2.3";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "The Rust Project Developers" ];
    sha256 = "12bv0zibls8wckz082jnky2ixykhixc7f72n652nd7l3ljlmkzim";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  backtrace_0_3_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "backtrace";
    version = "0.3.6";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "The Rust Project Developers" ];
    sha256 = "00p77iqrv2p47m4y5lq1clb8fi1xfmnz2520frqx88497ff4zhrx";
    inherit dependencies buildDependencies features;
  };
  backtrace_sys_0_1_16_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "backtrace-sys";
    version = "0.1.16";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1cn2c8q3dn06crmnk0p62czkngam4l8nf57wy33nz1y5g25pszwy";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  base64_0_6_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "base64";
    version = "0.6.0";
    authors = [ "Alice Maz <alice@alicemaz.com>" "Marshall Pierce <marshall@mpierce.org>" ];
    sha256 = "0ql1rmczbnww3iszc0pfc6mqa47ravpsdf525vp6s8r32nyzspl5";
    inherit dependencies buildDependencies features;
  };
  base64_0_9_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "base64";
    version = "0.9.1";
    authors = [ "Alice Maz <alice@alicemaz.com>" "Marshall Pierce <marshall@mpierce.org>" ];
    sha256 = "0fnsgkhn6aqbvvgbpcyzy1dbx840g0x5rvxdf82c5pv23knl0j0a";
    inherit dependencies buildDependencies features;
  };
  bitflags_0_9_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "bitflags";
    version = "0.9.1";
    authors = [ "The Rust Project Developers" ];
    sha256 = "18h073l5jd88rx4qdr95fjddr9rk79pb1aqnshzdnw16cfmb9rws";
    inherit dependencies buildDependencies features;
  };
  bitflags_1_0_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "bitflags";
    version = "1.0.3";
    authors = [ "The Rust Project Developers" ];
    sha256 = "162p4w4h1ad76awq6b5yivmls3d50m9cl27d8g588lsps6g8s5rw";
    inherit dependencies buildDependencies features;
  };
  brotli_sys_0_3_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "brotli-sys";
    version = "0.3.2";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0b68xckd06a5gvdykimgr5f0f2whrhj0lwqq6scy0viaargqkdnl";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  brotli2_0_3_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "brotli2";
    version = "0.3.2";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1daqrhn50rr8k03h7dd2zkjc0qn2c45q6hrmi642fnz0y5rfwm5y";
    inherit dependencies buildDependencies features;
  };
  build_const_0_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "build_const";
    version = "0.2.1";
    authors = [ "Garrett Berg <vitiral@gmail.com>" ];
    sha256 = "15249xzi3qlm72p4glxgavwyq70fx2sp4df6ii0sdlrixrrp77pl";
    inherit dependencies buildDependencies features;
  };
  bytecount_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "bytecount";
    version = "0.2.0";
    authors = [ "Andre Bogus <bogusandre@gmail.de>" "Joshua Landau <joshua@landau.ws>" ];
    sha256 = "0aa82dv2mdx01n8wrhqj7bzdffyw5p4fdps4lf4a2h2dkn7sgjg1";
    inherit dependencies buildDependencies features;
  };
  byteorder_1_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "byteorder";
    version = "1.2.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "03cj21di3hck3w8a09z2b9a4jv0aay7a4bjdd1f86h3a4icl68m1";
    inherit dependencies buildDependencies features;
  };
  bytes_0_4_7_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "bytes";
    version = "0.4.7";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1icr74r099d0c0a2q1pz51182z7911g92h2j60al351kz78dzv3f";
    inherit dependencies buildDependencies features;
  };
  cargo_metadata_0_3_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "cargo_metadata";
    version = "0.3.3";
    authors = [ "Oliver Schneider <git-spam-no-reply9815368754983@oli-obk.de>" ];
    sha256 = "0vdxzdh6qmqdlcigvkzya5a4d4f9p0awm2kgkjgnxbc50y1xrndz";
    inherit dependencies buildDependencies features;
  };
  cc_1_0_15_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "cc";
    version = "1.0.15";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1zmcv4zf888byhay2qakqlc9b8snhy5ccfs35zb6flywmlj8f2c0";
    inherit dependencies buildDependencies features;
  };
  cfg_if_0_1_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.2";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0x06hvrrqy96m97593823vvxcgvjaxckghwyy2jcyc8qc7c6cyhi";
    inherit dependencies buildDependencies features;
  };
  chrono_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "chrono";
    version = "0.4.2";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" "Brandon W Maister <quodlibetor@gmail.com>" ];
    sha256 = "1zp63v1g56kfjnazmqg8s4gb66l0ra8ggn3gzqbf9sr8d5lnfzak";
    inherit dependencies buildDependencies features;
  };
  clap_2_31_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "clap";
    version = "2.31.2";
    authors = [ "Kevin K. <kbknapp@gmail.com>" ];
    sha256 = "0r24ziw85a8y1sf2l21y4mvv5qan3rjafcshpyfsjfadqfxsij72";
    inherit dependencies buildDependencies features;
  };
  comrak_0_2_9_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "comrak";
    version = "0.2.9";
    authors = [ "Ashe Connor <kivikakk@github.com>" ];
    sha256 = "14pqn1m2yiyhanbnvza8zc2y8k7yzz0jdxqxpxi02d38d211wi2d";
    crateBin = [ {  name = "comrak"; } ];
    inherit dependencies buildDependencies features;
  };
  converse_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "converse";
    version = "0.1.0";
    authors = [ "Vincent Ambo <mail@tazj.in>" ];
    src = ./.;
    inherit dependencies buildDependencies features;
  };
  cookie_0_10_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "cookie";
    version = "0.10.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Sergio Benitez <sb@sergio.bz>" ];
    sha256 = "0sipihjzmipb13i2hzlvzsyljj00cjs7vx1ymslxr9m6kl2y0qpq";
    inherit dependencies buildDependencies features;
  };
  core_foundation_0_2_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "core-foundation";
    version = "0.2.3";
    authors = [ "The Servo Project Developers" ];
    sha256 = "1g0vpya5h2wa0nlz4a74jar6y8z09f0p76zbzfqrm3dbfsrld1pm";
    inherit dependencies buildDependencies features;
  };
  core_foundation_sys_0_2_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "core-foundation-sys";
    version = "0.2.3";
    authors = [ "The Servo Project Developers" ];
    sha256 = "19s0d03294m9s5j8cvy345db3gkhs2y02j5268ap0c6ky5apl53s";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  crc_1_8_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "crc";
    version = "1.8.1";
    authors = [ "Rui Hu <code@mrhooray.com>" ];
    sha256 = "00m9jjqrddp3bqyanvyxv0hf6s56bx1wy51vcdcxg4n2jdhg109s";
    inherit dependencies buildDependencies features;
  };
  crossbeam_channel_0_1_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "crossbeam-channel";
    version = "0.1.2";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "008xqz8w58sl43fmwpqqf08lp33sjq9gnmbgzw04l6ry7kidwm56";
    inherit dependencies buildDependencies features;
  };
  crossbeam_deque_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "crossbeam-deque";
    version = "0.2.0";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "1h3n1p1qy45b6388j3svfy1m72xlcx9j9a5y0mww6jz8fmknipnb";
    inherit dependencies buildDependencies features;
  };
  crossbeam_deque_0_3_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "crossbeam-deque";
    version = "0.3.0";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "0skpja7ri6q34li5plq8yk7xinc853014ra59ra9l5sdspcbdypa";
    inherit dependencies buildDependencies features;
  };
  crossbeam_epoch_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "crossbeam-epoch";
    version = "0.2.0";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "05hyrrbmz64z0gz6n9h6jmx7swnhika90h96fcyd83psjwpkap88";
    inherit dependencies buildDependencies features;
  };
  crossbeam_epoch_0_3_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "crossbeam-epoch";
    version = "0.3.1";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "1ljrrpvalabi3r2nnpcz7rqkbl2ydmd0mrrr2fv335f7d46xgfxa";
    inherit dependencies buildDependencies features;
  };
  crossbeam_epoch_0_4_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "crossbeam-epoch";
    version = "0.4.1";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "134565vkm0h14bk8c3bw0f7n8zzhwl6zi8127zvpa8iglchafn0a";
    inherit dependencies buildDependencies features;
  };
  crossbeam_utils_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "crossbeam-utils";
    version = "0.2.2";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "0jiwzxv0lysjq68yk4bzkygrf69zhdidyw55nxlmimxlm6xv0j4m";
    inherit dependencies buildDependencies features;
  };
  crossbeam_utils_0_3_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "crossbeam-utils";
    version = "0.3.2";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "1byx31nkxl48la58571h40ssk94faky26jwz15w40v2gba3v4fql";
    inherit dependencies buildDependencies features;
  };
  dbghelp_sys_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "dbghelp-sys";
    version = "0.2.0";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0ylpi3bbiy233m57hnisn1df1v0lbl7nsxn34b0anzsgg440hqpq";
    libName = "dbghelp";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  diesel_1_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "diesel";
    version = "1.2.2";
    authors = [ "Sean Griffin <sean@seantheprogrammer.com>" ];
    sha256 = "0bcy779ndq9l2l2vh3a7h1s1s2cw67365vkx4zhxdq22wyb8z90w";
    inherit dependencies buildDependencies features;
  };
  diesel_derives_1_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "diesel_derives";
    version = "1.2.0";
    authors = [ "Sean Griffin <sean@seantheprogrammer.com>" ];
    sha256 = "0ykq7c77zsdsak0r8d384nnca9fglhih6jq66d0b9sws8vjvn4m1";
    procMacro = true;
    inherit dependencies buildDependencies features;
  };
  dtoa_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "dtoa";
    version = "0.4.2";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1bxsh6fags7nr36vlz07ik2a1rzyipc8x1y30kjk832hf2pzadmw";
    inherit dependencies buildDependencies features;
  };
  encoding_0_2_33_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "encoding";
    version = "0.2.33";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" ];
    sha256 = "16ls6avhv5ll28zajl5q1jbiz1g80c4ygnw13zzqmij14wsp5329";
    inherit dependencies buildDependencies features;
  };
  encoding_index_japanese_1_20141219_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "encoding-index-japanese";
    version = "1.20141219.5";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" ];
    sha256 = "1pmfaabps0x6v6cd4fbk9ssykhkmc799dma2y78fhk7gvyr5gyl4";
    libPath = "lib.rs";
    libName = "encoding_index_japanese";
    inherit dependencies buildDependencies features;
  };
  encoding_index_korean_1_20141219_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "encoding-index-korean";
    version = "1.20141219.5";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" ];
    sha256 = "1b756n7gcilkx07y7zjrikcg0b8v8yd6mw8w01ji8sp3k1cabcf2";
    libPath = "lib.rs";
    libName = "encoding_index_korean";
    inherit dependencies buildDependencies features;
  };
  encoding_index_simpchinese_1_20141219_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "encoding-index-simpchinese";
    version = "1.20141219.5";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" ];
    sha256 = "0rb4xd8cqymhqffqqxdk18mf9n354vs50ar66jrysb1z6ymcvvpy";
    libPath = "lib.rs";
    libName = "encoding_index_simpchinese";
    inherit dependencies buildDependencies features;
  };
  encoding_index_singlebyte_1_20141219_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "encoding-index-singlebyte";
    version = "1.20141219.5";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" ];
    sha256 = "07df3jrfwfmzi2s352lvcpvy5dqpy2s45d2xx2dz1x7zh3q5284d";
    libPath = "lib.rs";
    libName = "encoding_index_singlebyte";
    inherit dependencies buildDependencies features;
  };
  encoding_index_tradchinese_1_20141219_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "encoding-index-tradchinese";
    version = "1.20141219.5";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" ];
    sha256 = "0lb12nbv29cy41gx26yz3v4kfi8h1xbn1ppja8szgqi2zm1wlywn";
    libPath = "lib.rs";
    libName = "encoding_index_tradchinese";
    inherit dependencies buildDependencies features;
  };
  encoding_index_tests_0_1_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "encoding_index_tests";
    version = "0.1.4";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" ];
    sha256 = "0z09kwh4z76q00cfr081rgjbnai4s2maq2vk88lgrq9d6bkf93f6";
    libPath = "index_tests.rs";
    inherit dependencies buildDependencies features;
  };
  encoding_rs_0_7_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "encoding_rs";
    version = "0.7.2";
    authors = [ "Henri Sivonen <hsivonen@hsivonen.fi>" ];
    sha256 = "1c23bi3q4qmi2ci8g7p5j4b4i5abyggvyg6hkl7w4p4r527c9g3q";
    inherit dependencies buildDependencies features;
  };
  entities_1_0_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "entities";
    version = "1.0.1";
    authors = [ "Philip Jackson <p-jackson@live.com>" ];
    sha256 = "1wvhgyl5mbbh3psw7c5w3mli6h87bk78aqap49mhp0654k87zw5g";
    inherit dependencies buildDependencies features;
  };
  env_logger_0_5_9_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "env_logger";
    version = "0.5.9";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1scf1gd6mjvxj4qzibpfvw5kqj36vxsgs19lm6wnbd84kh78892v";
    inherit dependencies buildDependencies features;
  };
  error_chain_0_1_12_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "error-chain";
    version = "0.1.12";
    authors = [ "Brian Anderson <banderson@mozilla.com>" "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" ];
    sha256 = "0pc1b8zbmim3qhlb0wfpxbvjhpq411rs0l9jzxplyr7j0b0wgbg1";
    inherit dependencies buildDependencies features;
  };
  error_chain_0_8_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "error-chain";
    version = "0.8.1";
    authors = [ "Brian Anderson <banderson@mozilla.com>" "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" "Yamakaky <yamakaky@yamaworld.fr>" ];
    sha256 = "0jaipqr2l2v84raynz3bvb0vnzysk7515j3mnb9i7g1qqprg2waq";
    inherit dependencies buildDependencies features;
  };
  error_chain_0_11_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "error-chain";
    version = "0.11.0";
    authors = [ "Brian Anderson <banderson@mozilla.com>" "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" "Yamakaky <yamakaky@yamaworld.fr>" ];
    sha256 = "19nz17q6dzp0mx2jhh9qbj45gkvvgcl7zq9z2ai5a8ihbisfj6d7";
    inherit dependencies buildDependencies features;
  };
  failure_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "failure";
    version = "0.1.1";
    authors = [ "Without Boats <boats@mozilla.com>" ];
    sha256 = "0gf9cmkm9kc163sszgjksqp5pcgj689lnf2104nn4h4is18nhigk";
    inherit dependencies buildDependencies features;
  };
  failure_derive_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "failure_derive";
    version = "0.1.1";
    authors = [ "Without Boats <woboats@gmail.com>" ];
    sha256 = "1w895q4pbyx3rwnhgjwfcayk9ghbi166wc1c3553qh8zkbz52k8i";
    procMacro = true;
    inherit dependencies buildDependencies features;
  };
  flate2_1_0_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "flate2";
    version = "1.0.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0hi1r0sz8ca750hq9ym6d3n99g6rmmm8m8hadz2v49pfh6jd6svc";
    inherit dependencies buildDependencies features;
  };
  fnv_1_0_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "fnv";
    version = "1.0.6";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "128mlh23y3gg6ag5h8iiqlcbl59smisdzraqy88ldrf75kbw27ip";
    libPath = "lib.rs";
    inherit dependencies buildDependencies features;
  };
  foreign_types_0_3_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "foreign-types";
    version = "0.3.2";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "105n8sp2djb1s5lzrw04p7ss3dchr5qa3canmynx396nh3vwm2p8";
    inherit dependencies buildDependencies features;
  };
  foreign_types_shared_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "foreign-types-shared";
    version = "0.1.1";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0b6cnvqbflws8dxywk4589vgbz80049lz4x1g9dfy4s1ppd3g4z5";
    inherit dependencies buildDependencies features;
  };
  fuchsia_zircon_0_3_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "fuchsia-zircon";
    version = "0.3.3";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "0jrf4shb1699r4la8z358vri8318w4mdi6qzfqy30p2ymjlca4gk";
    inherit dependencies buildDependencies features;
  };
  fuchsia_zircon_sys_0_3_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "fuchsia-zircon-sys";
    version = "0.3.3";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "08jp1zxrm9jbrr6l26bjal4dbm8bxfy57ickdgibsqxr1n9j3hf5";
    inherit dependencies buildDependencies features;
  };
  futures_0_1_21_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "futures";
    version = "0.1.21";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0v4xrgkqx189b3b4lad2z5l9ay261p9412bzcdh1z6agxwhldr40";
    inherit dependencies buildDependencies features;
  };
  futures_cpupool_0_1_8_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "futures-cpupool";
    version = "0.1.8";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0ficd31n5ljiixy6x0vjglhq4fp0v1p4qzxm3v6ymsrb3z080l5c";
    inherit dependencies buildDependencies features;
  };
  gcc_0_3_54_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "gcc";
    version = "0.3.54";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "07a5i47r8achc6gxsba3ga17h9gnh4b9a2cak8vjg4hx62aajkr4";
    inherit dependencies buildDependencies features;
  };
  getopts_0_2_17_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "getopts";
    version = "0.2.17";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1rifkxn7njr2w1dsa29hrm26ywgcg8gv1ms00g3vs5mjiabxk0jv";
    inherit dependencies buildDependencies features;
  };
  glob_0_2_11_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "glob";
    version = "0.2.11";
    authors = [ "The Rust Project Developers" ];
    sha256 = "104389jjxs8r2f5cc9p0axhjmndgln60ih5x4f00ccgg9d3zarlf";
    inherit dependencies buildDependencies features;
  };
  h2_0_1_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "h2";
    version = "0.1.6";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "00bkracb1ysifj2sl07gbx8jdajjrmcffk5hxr39lh2nd94nhlhm";
    inherit dependencies buildDependencies features;
  };
  hostname_0_1_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "hostname";
    version = "0.1.4";
    authors = [ "fengcen <fengcen.love@gmail.com>" ];
    sha256 = "1wfz2afh9xjd5rdxgyrhvhl6z1vvdch5nnd7miw2pi3i90fw4r1h";
    libPath = "src/lib.rs";
    inherit dependencies buildDependencies features;
  };
  http_0_1_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "http";
    version = "0.1.5";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Carl Lerche <me@carllerche.com>" "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "07p5q6h45r0hlnd6vg344iy72jk7xphzf6p38gb4fhb9iibnwn08";
    inherit dependencies buildDependencies features;
  };
  http_range_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "http-range";
    version = "0.1.1";
    authors = [ "Luka Zakrajšek <luka@bancek.net>" ];
    sha256 = "1zl43iw110ybbl9g24jhwylqbwgwm25vpv9m47sfwy2ajaqb7b3g";
    inherit dependencies buildDependencies features;
  };
  httparse_1_2_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "httparse";
    version = "1.2.4";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "169grgxpsq0jaa2fk913z692a6qi8c2n1kypsay124b37720d8ll";
    inherit dependencies buildDependencies features;
  };
  humansize_1_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "humansize";
    version = "1.1.0";
    authors = [ "Leopold Arkham <leopold.arkham@gmail.com>" ];
    sha256 = "1s7jj570vz90b7wsgd24lla1yn9qp3swgv9c7jgkgrw6bxynbv0p";
    inherit dependencies buildDependencies features;
  };
  humantime_1_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "humantime";
    version = "1.1.1";
    authors = [ "Paul Colomiets <paul@colomiets.name>" ];
    sha256 = "1lzdfsfzdikcp1qb6wcdvnsdv16pmzr7p7cv171vnbnyz2lrwbgn";
    libPath = "src/lib.rs";
    inherit dependencies buildDependencies features;
  };
  hyper_0_11_25_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "hyper";
    version = "0.11.25";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "01sz75yi93x3hnyrr1n782kv5s1bzcr0114ylyw484j9xpsghw7d";
    inherit dependencies buildDependencies features;
  };
  hyper_tls_0_1_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "hyper-tls";
    version = "0.1.3";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "1dr5arj79pdyz9f2jggqmna1qpc578f9pdgsf2ana5amjpsp0j89";
    inherit dependencies buildDependencies features;
  };
  idna_0_1_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "idna";
    version = "0.1.4";
    authors = [ "The rust-url developers" ];
    sha256 = "15j44qgjx1skwg9i7f4cm36ni4n99b1ayx23yxx7axxcw8vjf336";
    inherit dependencies buildDependencies features;
  };
  indexmap_1_0_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "indexmap";
    version = "1.0.1";
    authors = [ "bluss" "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "10ak26zp3i5iyb03l99312q66jl20qs45cm5jnghm9ymdhspw3r4";
    inherit dependencies buildDependencies features;
  };
  iovec_0_1_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "iovec";
    version = "0.1.2";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0vjymmb7wj4v4kza5jjn48fcdb85j3k37y7msjl3ifz0p9yiyp2r";
    inherit dependencies buildDependencies features;
  };
  ipconfig_0_1_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "ipconfig";
    version = "0.1.6";
    authors = [ "Liran Ringel <liranringel@gmail.com>" ];
    sha256 = "1jax0paxr9m2qfmc5l386d65m2g2wyzy077wzmbryv14d6dncfp8";
    inherit dependencies buildDependencies features;
  };
  itoa_0_3_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "itoa";
    version = "0.3.4";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1nfkzz6vrgj0d9l3yzjkkkqzdgs68y294fjdbl7jq118qi8xc9d9";
    inherit dependencies buildDependencies features;
  };
  itoa_0_4_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "itoa";
    version = "0.4.1";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1jyrsmrm5q4r2ipmq5hvvkqg0mgnlbk44lm7gr0v9ymvbrh2gbij";
    inherit dependencies buildDependencies features;
  };
  kernel32_sys_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "kernel32-sys";
    version = "0.2.2";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lrw1hbinyvr6cp28g60z97w32w8vsk6pahk64pmrv2fmby8srfj";
    libName = "kernel32";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  language_tags_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "language-tags";
    version = "0.2.2";
    authors = [ "Pyfisch <pyfisch@gmail.com>" ];
    sha256 = "1zkrdzsqzzc7509kd7nngdwrp461glm2g09kqpzaqksp82frjdvy";
    inherit dependencies buildDependencies features;
  };
  lazy_static_0_2_11_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "lazy_static";
    version = "0.2.11";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1x6871cvpy5b96yv4c7jvpq316fp5d4609s9py7qk6cd6x9k34vm";
    inherit dependencies buildDependencies features;
  };
  lazy_static_1_0_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.0.0";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "0wfvqyr2nvx2mbsrscg5y7gfa9skhb8p72ayanl8vl49pw24v4fh";
    inherit dependencies buildDependencies features;
  };
  lazycell_0_6_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "lazycell";
    version = "0.6.0";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Nikita Pekin <contact@nikitapek.in>" ];
    sha256 = "1ax148clinbvp6alxcih8s5i2bg3mc5mi69n3hvzvzbwlm6k532r";
    inherit dependencies buildDependencies features;
  };
  libc_0_2_40_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "libc";
    version = "0.2.40";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1xfc39237ldzgr8x8wcflgdr8zssi3wif7g2zxc02d94gzkjsw83";
    inherit dependencies buildDependencies features;
  };
  libflate_0_1_14_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "libflate";
    version = "0.1.14";
    authors = [ "Takeru Ohta <phjgt308@gmail.com>" ];
    sha256 = "03zq769bfffg3iyp2vkkjsmkskabrxiyh5khzppyyngm8w9xpdsc";
    inherit dependencies buildDependencies features;
  };
  linked_hash_map_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "linked-hash-map";
    version = "0.4.2";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" "Andrew Paseltiner <apaseltiner@gmail.com>" ];
    sha256 = "04da208h6jb69f46j37jnvsw2i1wqplglp4d61csqcrhh83avbgl";
    inherit dependencies buildDependencies features;
  };
  log_0_3_9_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "log";
    version = "0.3.9";
    authors = [ "The Rust Project Developers" ];
    sha256 = "19i9pwp7lhaqgzangcpw00kc3zsgcqcx84crv07xgz3v7d3kvfa2";
    inherit dependencies buildDependencies features;
  };
  log_0_4_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "log";
    version = "0.4.1";
    authors = [ "The Rust Project Developers" ];
    sha256 = "01vm8yy3wngvyj6qp1x3xpcb4xq7v67yn9l7fsma8kz28mliz90d";
    inherit dependencies buildDependencies features;
  };
  lru_cache_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "lru-cache";
    version = "0.1.1";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" ];
    sha256 = "1hl6kii1g54sq649gnscv858mmw7a02xj081l4vcgvrswdi2z8fw";
    inherit dependencies buildDependencies features;
  };
  matches_0_1_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "matches";
    version = "0.1.6";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "1zlrqlbvzxdil8z8ial2ihvxjwvlvg3g8dr0lcdpsjclkclasjan";
    libPath = "lib.rs";
    inherit dependencies buildDependencies features;
  };
  md5_0_3_7_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "md5";
    version = "0.3.7";
    authors = [ "Ivan Ukhov <ivan.ukhov@gmail.com>" "Kamal Ahmad <shibe@openmailbox.org>" "Konstantin Stepanov <milezv@gmail.com>" "Lukas Kalbertodt <lukas.kalbertodt@gmail.com>" "Nathan Musoke <nathan.musoke@gmail.com>" "Tony Arcieri <bascule@gmail.com>" ];
    sha256 = "1ga55k7asxln553m89ccka2hnp5gkvacxl98r3nmx4d9mzvwn352";
    inherit dependencies buildDependencies features;
  };
  memchr_2_0_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "memchr";
    version = "2.0.1";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "0ls2y47rjwapjdax6bp974gdp06ggm1v8d1h69wyydmh1nhgm5gr";
    inherit dependencies buildDependencies features;
  };
  memoffset_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "memoffset";
    version = "0.1.0";
    authors = [ "Gilad Naaman <gilad.naaman@gmail.com>" ];
    sha256 = "1jq5vcfwqwxl709985srmsxs229da2hq3ab11fx3abbx1bpxcgx1";
    inherit dependencies buildDependencies features;
  };
  memoffset_0_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "memoffset";
    version = "0.2.1";
    authors = [ "Gilad Naaman <gilad.naaman@gmail.com>" ];
    sha256 = "00vym01jk9slibq2nsiilgffp7n6k52a4q3n4dqp0xf5kzxvffcf";
    inherit dependencies buildDependencies features;
  };
  mime_0_3_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "mime";
    version = "0.3.5";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "032y8q6h7yzmji1cznw04grbi0inbl1m6rcwgsqfwiw8gflcgy0l";
    inherit dependencies buildDependencies features;
  };
  mime_guess_2_0_0_alpha_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "mime_guess";
    version = "2.0.0-alpha.4";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "1kz8j1hb4azgyzcs6bnrrygv0ykjp170llri0is031q01vi7fgnh";
    inherit dependencies buildDependencies features;
  };
  miniz_sys_0_1_10_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "miniz-sys";
    version = "0.1.10";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "11vg6phafxil87nbxgrlhcx5hjr3145wsbwwkfmibvnmzxfdmvln";
    libPath = "lib.rs";
    libName = "miniz_sys";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  mio_0_6_14_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "mio";
    version = "0.6.14";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0zws9p0d734qps4wdv47d32mmpb85caf9l2arwhxc7pslqk4icap";
    inherit dependencies buildDependencies features;
  };
  mio_uds_0_6_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "mio-uds";
    version = "0.6.4";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0migvjj2psaln6169rmyci5v6kvx5b7ylj5a6i2dkw98dylf2s1m";
    inherit dependencies buildDependencies features;
  };
  miow_0_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "miow";
    version = "0.2.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "14f8zkc6ix7mkyis1vsqnim8m29b6l55abkba3p2yz7j1ibcvrl0";
    inherit dependencies buildDependencies features;
  };
  native_tls_0_1_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "native-tls";
    version = "0.1.5";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "11f75qmbny5pnn6zp0vlvadrvc9ph9qsxiyn4n6q02xyd93pxxlf";
    inherit dependencies buildDependencies features;
  };
  net2_0_2_32_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "net2";
    version = "0.2.32";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "15q3il71qaqrwz8q1nz0jyw5q4fl0vrkajgaj909zradxsxv1mcq";
    inherit dependencies buildDependencies features;
  };
  nodrop_0_1_12_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "nodrop";
    version = "0.1.12";
    authors = [ "bluss" ];
    sha256 = "1b9rxvdg8061gxjc239l9slndf0ds3m6fy2sf3gs8f9kknqgl49d";
    inherit dependencies buildDependencies features;
  };
  num_integer_0_1_36_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "num-integer";
    version = "0.1.36";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1fjprz9h8b04zrsnfmkkfhiw4w852bbh16hy8w9ahlcdhg77i66y";
    inherit dependencies buildDependencies features;
  };
  num_traits_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "num-traits";
    version = "0.2.2";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1gcqhcd27gi72al5salxlp3m374qr3xnc3zh249f7dsrxc9rmgh0";
    inherit dependencies buildDependencies features;
  };
  num_cpus_1_8_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "num_cpus";
    version = "1.8.0";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1y6qnd9r8ga6y8mvlabdrr73nc8cshjjlzbvnanzyj9b8zzkfwk2";
    inherit dependencies buildDependencies features;
  };
  openssl_0_9_24_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "openssl";
    version = "0.9.24";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0wzm3c11g3ndaqyzq36mcdcm1q4a8pmsyi33ibybhjz28g2z0f79";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  openssl_sys_0_9_30_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "openssl-sys";
    version = "0.9.30";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1p5y3md4crbmg0lcfkdl8pp3kf9k82vghjy28x7ix5mji3j2p87a";
    inherit dependencies buildDependencies features;
  };
  owning_ref_0_3_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "owning_ref";
    version = "0.3.3";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "13ivn0ydc0hf957ix0f5si9nnplzzykbr70hni1qz9m19i9kvmrh";
    inherit dependencies buildDependencies features;
  };
  parking_lot_0_4_8_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "parking_lot";
    version = "0.4.8";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "0qrb2f0azglbsx7k3skgnc7mmv9z9spnqgk1m450g91r94nlklqi";
    inherit dependencies buildDependencies features;
  };
  parking_lot_core_0_2_14_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "parking_lot_core";
    version = "0.2.14";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "0giypb8ckkpi34p14nfk4b19c7przj4jxs95gs7x2v5ncmi0y286";
    inherit dependencies buildDependencies features;
  };
  percent_encoding_1_0_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "percent-encoding";
    version = "1.0.1";
    authors = [ "The rust-url developers" ];
    sha256 = "04ahrp7aw4ip7fmadb0bknybmkfav0kk0gw4ps3ydq5w6hr0ib5i";
    libPath = "lib.rs";
    inherit dependencies buildDependencies features;
  };
  pest_1_0_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "pest";
    version = "1.0.6";
    authors = [ "Dragoș Tiselice <dragostiselice@gmail.com>" ];
    sha256 = "07r7aq8fni6ycjn3mlpam95pd4hlwylqqprv62ni488pjbkhcp5d";
    inherit dependencies buildDependencies features;
  };
  pest_derive_1_0_7_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "pest_derive";
    version = "1.0.7";
    authors = [ "Dragoș Tiselice <dragostiselice@gmail.com>" ];
    sha256 = "1jmw7ai3adwrp81ygs2l9i9fqm33b0m87j6rwcn3rvis4gg12kyc";
    procMacro = true;
    inherit dependencies buildDependencies features;
  };
  phf_0_7_22_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "phf";
    version = "0.7.22";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0b58l863rhmqyqsfj2d89nmdzc21g9yvvvq1m4c3a615zpcykb3i";
    libPath = "src/lib.rs";
    inherit dependencies buildDependencies features;
  };
  phf_codegen_0_7_22_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "phf_codegen";
    version = "0.7.22";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0k8yx4gr9m6cfrvh21s6bhnh1azz13j4xih88bvm06r6blfl89fs";
    inherit dependencies buildDependencies features;
  };
  phf_generator_0_7_22_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "phf_generator";
    version = "0.7.22";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "093gla320qb6rbk8z7wqqxl79zrh874sa7sxir31q2p7mrw4b70k";
    inherit dependencies buildDependencies features;
  };
  phf_shared_0_7_22_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "phf_shared";
    version = "0.7.22";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0ij9flicfi0ab5vpzdwbizpdyxhk891qxa8nxsqlv4sg4abqang6";
    libPath = "src/lib.rs";
    inherit dependencies buildDependencies features;
  };
  pkg_config_0_3_11_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "pkg-config";
    version = "0.3.11";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "177kbs465skvzmb2d9bh7aa5lqm0npfig12awcbd34c6k6nlyr5h";
    inherit dependencies buildDependencies features;
  };
  pq_sys_0_4_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "pq-sys";
    version = "0.4.4";
    authors = [ "Sean Griffin <sean@seantheprogrammer.com>" ];
    sha256 = "1iqgs12mzx711ab1idiq4ryj27f8srwh83syj0ahvmbp5b8szggg";
    libName = "pq_sys";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  proc_macro2_0_2_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.2.3";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1y47qagi1r1f13b4b66xagr3dn9hjlvba7i6f5mcb77qhkn8yg9c";
    inherit dependencies buildDependencies features;
  };
  proc_macro2_0_3_8_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.3.8";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0ixnavxcd6sk1861hjgnfxly7qgq4ch1iplsx0nclvjjkwg39qdc";
    inherit dependencies buildDependencies features;
  };
  pulldown_cmark_0_1_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "pulldown-cmark";
    version = "0.1.2";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "0imc6m2bxk4j8y5qfp9x9sjnbrz7cz4i7irv4dfqjp4cgblmg5l8";
    crateBin = [ {  name = "pulldown-cmark"; } ];
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  quick_error_1_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "quick-error";
    version = "1.2.1";
    authors = [ "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" ];
    sha256 = "0vq41csw68ynaq2fy5dvldh4lx7pnbw6pr332kv5rvrz4pz0jnq6";
    inherit dependencies buildDependencies features;
  };
  quote_0_3_15_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "quote";
    version = "0.3.15";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "09il61jv4kd1360spaj46qwyl21fv1qz18fsv2jra8wdnlgl5jsg";
    inherit dependencies buildDependencies features;
  };
  quote_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "quote";
    version = "0.4.2";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0rzka356p113f9hdcdc8ha78qar3qd6jpap9wnf5dza9hfs2k4bc";
    inherit dependencies buildDependencies features;
  };
  quote_0_5_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "quote";
    version = "0.5.2";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "062cnp12j09x0z0nj4j5pfh26h35zlrks07asxgqhfhcym1ba595";
    inherit dependencies buildDependencies features;
  };
  r2d2_0_8_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "r2d2";
    version = "0.8.2";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1m8cvw9gpc5r922alyha2qq9nl79q3ldsjk1qwax36zrca0akvdi";
    inherit dependencies buildDependencies features;
  };
  rand_0_3_22_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "rand";
    version = "0.3.22";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0wrj12acx7l4hr7ag3nz8b50yhp8ancyq988bzmnnsxln67rsys0";
    inherit dependencies buildDependencies features;
  };
  rand_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "rand";
    version = "0.4.2";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0h8pkg23wb67i8904sm76iyr1jlmhklb85vbpz9c9191a24xzkfm";
    inherit dependencies buildDependencies features;
  };
  rayon_0_8_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "rayon";
    version = "0.8.2";
    authors = [ "Niko Matsakis <niko@alum.mit.edu>" "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "0d0mddg1k75hb9138pn8lysy2095jijrinskqbpgfr73s0jx6dq8";
    inherit dependencies buildDependencies features;
  };
  rayon_core_1_4_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "rayon-core";
    version = "1.4.0";
    authors = [ "Niko Matsakis <niko@alum.mit.edu>" "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "1gmg5fmgvhzks7b05g3ms7x8h1xxqnfkg28wvhzwpdzjljcbnr23";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  redox_syscall_0_1_37_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.37";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "0qa0jl9cr3qp80an8vshp2mcn8rzvwiavs1398hq1vsjw7pc3h2v";
    libName = "syscall";
    inherit dependencies buildDependencies features;
  };
  redox_termios_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "redox_termios";
    version = "0.1.1";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "04s6yyzjca552hdaqlvqhp3vw0zqbc304md5czyd3axh56iry8wh";
    libPath = "src/lib.rs";
    inherit dependencies buildDependencies features;
  };
  regex_0_2_11_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "regex";
    version = "0.2.11";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0r50cymxdqp0fv1dxd22mjr6y32q450nwacd279p9s7lh0cafijj";
    inherit dependencies buildDependencies features;
  };
  regex_syntax_0_5_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.5.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "10vf3r34bgjnbrnqd5aszn35bjvm8insw498l1vjy8zx5yms3427";
    inherit dependencies buildDependencies features;
  };
  relay_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "relay";
    version = "0.1.1";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "16csfaslbmj25iaxs88p8wcfh2zfpkh9isg9adid0nxjxvknh07r";
    inherit dependencies buildDependencies features;
  };
  remove_dir_all_0_5_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "remove_dir_all";
    version = "0.5.1";
    authors = [ "Aaronepower <theaaronepower@gmail.com>" ];
    sha256 = "1chx3yvfbj46xjz4bzsvps208l46hfbcy0sm98gpiya454n4rrl7";
    inherit dependencies buildDependencies features;
  };
  reqwest_0_8_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "reqwest";
    version = "0.8.5";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1wrrv3kwh0pm5yzajf986z21pyf48vxskvn7pflzhrm9y11kalnf";
    inherit dependencies buildDependencies features;
  };
  resolv_conf_0_6_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "resolv-conf";
    version = "0.6.0";
    authors = [ "paul@colomiets.name" ];
    sha256 = "11aslgks1zdwwx5nj6fmrnigyvphgk0chd8isz4zwb3pik1jjvc0";
    libPath = "src/lib.rs";
    libName = "resolv_conf";
    inherit dependencies buildDependencies features;
  };
  ring_0_12_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "ring";
    version = "0.12.1";
    authors = [ "Brian Smith <brian@briansmith.org>" ];
    sha256 = "1i47apwkpa0wz9fwp4iqf0xks95b9nmhhlgvk5fsgbg0aphhw0p7";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  rustc_demangle_0_1_7_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "rustc-demangle";
    version = "0.1.7";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0wrln6jvwmqrhyvqlw5vq9a2s4r04ja8mrybxjj9aaaar1fyvns6";
    inherit dependencies buildDependencies features;
  };
  safemem_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "safemem";
    version = "0.2.0";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "058m251q202n479ip1h6s91yw3plg66vsk5mpaflssn6rs5hijdm";
    inherit dependencies buildDependencies features;
  };
  same_file_0_1_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "same-file";
    version = "0.1.3";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "01hdnxblb1hlysr47nwdv7r8vs7p63ia08v5h4lcffmzqvl5zzn9";
    inherit dependencies buildDependencies features;
  };
  schannel_0_1_12_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "schannel";
    version = "0.1.12";
    authors = [ "Steven Fackler <sfackler@gmail.com>" "Steffen Butzer <steffen.butzer@outlook.com>" ];
    sha256 = "1lqdzx8d4rql8ah9w760syvrbbyp26s9cgidvrh34h0hjglja42d";
    inherit dependencies buildDependencies features;
  };
  scheduled_thread_pool_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "scheduled-thread-pool";
    version = "0.2.0";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0x8jxh3l4irj5hm7rwfwmfd0iazcpvcfvnqbsngrrn3dmzpy0ig9";
    inherit dependencies buildDependencies features;
  };
  scoped_tls_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "scoped-tls";
    version = "0.1.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1csp1bp0cc1hvdk0ml293zqjpblh7254cd88q22yx63xmszj1dh4";
    inherit dependencies buildDependencies features;
  };
  scopeguard_0_3_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "scopeguard";
    version = "0.3.3";
    authors = [ "bluss" ];
    sha256 = "0i1l013csrqzfz6c68pr5pi01hg5v5yahq8fsdmaxy6p8ygsjf3r";
    inherit dependencies buildDependencies features;
  };
  security_framework_0_1_16_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "security-framework";
    version = "0.1.16";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1kxczsaj8gz4922jl5af2gkxh71rasb6khaf3dp7ldlnw9qf2sbm";
    inherit dependencies buildDependencies features;
  };
  security_framework_sys_0_1_16_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "security-framework-sys";
    version = "0.1.16";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0ai2pivdr5fyc7czbkpcrwap0imyy0r8ndarrl3n5kiv0jha1js3";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  semver_0_8_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "semver";
    version = "0.8.0";
    authors = [ "Steve Klabnik <steve@steveklabnik.com>" "The Rust Project Developers" ];
    sha256 = "0wgg4lmjmqj6sk6q50mw4qbx178a9nd3afb5q8c68ajzj0lfc3cv";
    inherit dependencies buildDependencies features;
  };
  semver_parser_0_7_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "semver-parser";
    version = "0.7.0";
    authors = [ "Steve Klabnik <steve@steveklabnik.com>" ];
    sha256 = "1da66c8413yakx0y15k8c055yna5lyb6fr0fw9318kdwkrk5k12h";
    inherit dependencies buildDependencies features;
  };
  serde_1_0_43_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "serde";
    version = "1.0.43";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "05zqbc008pg0q8ds2njxh09lpfi2a99j8n7ihawkrjm2ldwdzb17";
    inherit dependencies buildDependencies features;
  };
  serde_derive_1_0_43_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.43";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0a3q4ckirmafb4q9ix7rwmw3crv5q96m1p9m7avf11il6k9hkcrr";
    procMacro = true;
    inherit dependencies buildDependencies features;
  };
  serde_derive_internals_0_23_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "serde_derive_internals";
    version = "0.23.1";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0bjgcn2irh6sd34q3j3xkbn5ghfgiv3cfdlffb31lh0bikwpk1b4";
    inherit dependencies buildDependencies features;
  };
  serde_json_1_0_16_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.16";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1715lzswbbc1gj1pq213smvw21iyrsy8pmkbkw503vxdgzkzgc78";
    inherit dependencies buildDependencies features;
  };
  serde_urlencoded_0_5_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "serde_urlencoded";
    version = "0.5.1";
    authors = [ "Anthony Ramine <n.oxyde@gmail.com>" ];
    sha256 = "0zh2wlnapmcwqhxnnq1mdlmg8vily7j54wvj01s7cvapzg5jphdl";
    inherit dependencies buildDependencies features;
  };
  sha1_0_6_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "sha1";
    version = "0.6.0";
    authors = [ "Armin Ronacher <armin.ronacher@active-4.com>" ];
    sha256 = "12cp2b8f3hbwhfpnv1j1afl285xxmmbxh9w4npzvwbdh7xfyww8v";
    inherit dependencies buildDependencies features;
  };
  siphasher_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "siphasher";
    version = "0.2.2";
    authors = [ "Frank Denis <github@pureftpd.org>" ];
    sha256 = "0iyx7nlzfny9ly1634a6zcq0yvrinhxhypwas4p8ry3zqnn76qqr";
    inherit dependencies buildDependencies features;
  };
  skeptic_0_13_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "skeptic";
    version = "0.13.2";
    authors = [ "Brian Anderson <banderson@mozilla.com>" "Michał Budzyński <budziq@gmail.com>" ];
    sha256 = "1wv5ajmaapv9naki7z33mk88z1a547p5dll6hipwpdsc66wrd564";
    libPath = "lib.rs";
    inherit dependencies buildDependencies features;
  };
  slab_0_3_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "slab";
    version = "0.3.0";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0y6lhjggksh57hyfd3l6p9wgv5nhvw9c6djrysq7jnalz8fih21k";
    inherit dependencies buildDependencies features;
  };
  slab_0_4_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "slab";
    version = "0.4.0";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1qy2vkgwqgj5z4ygdkh040n9yh1vz80v5flxb1xrvw3i4wxs7yx0";
    inherit dependencies buildDependencies features;
  };
  slug_0_1_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "slug";
    version = "0.1.3";
    authors = [ "Steven Allen <steven@stebalien.com>" ];
    sha256 = "0ry961rwq5d9jf6b9xhlq75caiwrylxz681l3ghan7nf32nmv6zw";
    inherit dependencies buildDependencies features;
  };
  smallvec_0_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "smallvec";
    version = "0.2.1";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "0rnsll9af52bpjngz0067dpm1ndqmh76i64a58fc118l4lvnjxw2";
    libPath = "lib.rs";
    inherit dependencies buildDependencies features;
  };
  smallvec_0_6_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "smallvec";
    version = "0.6.1";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "16m07xh67xcdpwjkbzbv9d7visxmz4fb4a8jfcrsrf333w7vkl1g";
    libPath = "lib.rs";
    inherit dependencies buildDependencies features;
  };
  socket2_0_3_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "socket2";
    version = "0.3.5";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0bi6z6qvra16rwm3lk7xz4aakvcmmak6fpdmra1v7ccp40bss0kf";
    inherit dependencies buildDependencies features;
  };
  stable_deref_trait_1_0_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "stable_deref_trait";
    version = "1.0.0";
    authors = [ "Robert Grosse <n210241048576@gmail.com>" ];
    sha256 = "0ya5fms9qdwkd52d3a111w4vcz18j4rbfx4p88z44116cqd6cczr";
    inherit dependencies buildDependencies features;
  };
  string_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "string";
    version = "0.1.0";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0pca6c4kf47izwapzz9bzmq7sb6hbzn26xxdfi8ld7mqf0dqg1z7";
    inherit dependencies buildDependencies features;
  };
  strsim_0_7_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "strsim";
    version = "0.7.0";
    authors = [ "Danny Guo <dannyguo91@gmail.com>" ];
    sha256 = "0fy0k5f2705z73mb3x9459bpcvrx4ky8jpr4zikcbiwan4bnm0iv";
    inherit dependencies buildDependencies features;
  };
  syn_0_11_11_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "syn";
    version = "0.11.11";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0yw8ng7x1dn5a6ykg0ib49y7r9nhzgpiq2989rqdp7rdz3n85502";
    inherit dependencies buildDependencies features;
  };
  syn_0_12_15_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "syn";
    version = "0.12.15";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0kkzav72yy0idzbh9zcg92dam3785xzrbxjjp8vxcis9z2zd6b13";
    inherit dependencies buildDependencies features;
  };
  syn_0_13_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "syn";
    version = "0.13.4";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "029n8x53hvn00fs3wx8x7qcxxkfaaqjcrisgrz1qszzbr8f9hx1b";
    inherit dependencies buildDependencies features;
  };
  synom_0_11_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "synom";
    version = "0.11.3";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1l6d1s9qjfp6ng2s2z8219igvlv7gyk8gby97sdykqc1r93d8rhc";
    inherit dependencies buildDependencies features;
  };
  synstructure_0_6_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "synstructure";
    version = "0.6.1";
    authors = [ "Michael Layzell <michael@thelayzells.com>" ];
    sha256 = "1xnyw58va9zcqi4vvpnmpllacdj2a0mvy0cbd698izmr4qs92xlk";
    inherit dependencies buildDependencies features;
  };
  take_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "take";
    version = "0.1.0";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "17rfh39di5n8w9aghpic2r94cndi3dr04l60nkjylmxfxr3iwlhd";
    inherit dependencies buildDependencies features;
  };
  tempdir_0_3_7_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tempdir";
    version = "0.3.7";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0y53sxybyljrr7lh0x0ysrsa7p7cljmwv9v80acy3rc6n97g67vy";
    inherit dependencies buildDependencies features;
  };
  tera_0_11_7_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tera";
    version = "0.11.7";
    authors = [ "Vincent Prouillet <prouillet.vincent@gmail.com>" ];
    sha256 = "14s7pbrg804bb45majjxbgdgkj2ckh8i3kfjg1hc7f803yzhykc2";
    inherit dependencies buildDependencies features;
  };
  termcolor_0_3_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "termcolor";
    version = "0.3.6";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0w609sa1apl1kii67ln2g82r4rrycw45zgjq7mxxjrx1fa21v05z";
    inherit dependencies buildDependencies features;
  };
  termion_1_5_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "termion";
    version = "1.5.1";
    authors = [ "ticki <Ticki@users.noreply.github.com>" "gycos <alexandre.bury@gmail.com>" "IGI-111 <igi-111@protonmail.com>" ];
    sha256 = "02gq4vd8iws1f3gjrgrgpajsk2bk43nds5acbbb4s8dvrdvr8nf1";
    inherit dependencies buildDependencies features;
  };
  textwrap_0_9_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "textwrap";
    version = "0.9.0";
    authors = [ "Martin Geisler <martin@geisler.net>" ];
    sha256 = "18jg79ndjlwndz01mlbh82kkr2arqm658yn5kwp65l5n1hz8w4yb";
    inherit dependencies buildDependencies features;
  };
  thread_local_0_3_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "thread_local";
    version = "0.3.5";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "0mkp0sp91aqsk7brgygai4igv751r1754rsxn37mig3ag5rx8np6";
    inherit dependencies buildDependencies features;
  };
  time_0_1_39_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "time";
    version = "0.1.39";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1ryy3bwhvyzj6fym123il38mk9ranm4vradj2a47l5ij8jd7w5if";
    inherit dependencies buildDependencies features;
  };
  tokio_0_1_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio";
    version = "0.1.5";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0dd11vmmq7q65l1nwq85707n87r7b8gh29lq232j8hrimpkwnav9";
    inherit dependencies buildDependencies features;
  };
  tokio_core_0_1_17_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-core";
    version = "0.1.17";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1j6c5q3aakvb1hjx4r95xwl5ms8rp19k4qsr6v6ngwbvr6f9z6rs";
    inherit dependencies buildDependencies features;
  };
  tokio_executor_0_1_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-executor";
    version = "0.1.2";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1y4mwqjw438x6jskigz1knvfbpbinxfv6h43s60w6wdb80xmyg48";
    inherit dependencies buildDependencies features;
  };
  tokio_io_0_1_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-io";
    version = "0.1.6";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0awvw1cfylws2lqdls615hcnrz7x7krr7gm57bgj55xai14rmk9k";
    inherit dependencies buildDependencies features;
  };
  tokio_proto_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-proto";
    version = "0.1.1";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "030q9h8pn1ngm80klff5irglxxki60hf5maw0mppmmr46k773z66";
    inherit dependencies buildDependencies features;
  };
  tokio_reactor_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-reactor";
    version = "0.1.1";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0crs57d2k4a69abqhjzs3crs3hfw7qia3phpc3saxpnwh1j51093";
    inherit dependencies buildDependencies features;
  };
  tokio_service_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-service";
    version = "0.1.0";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0c85wm5qz9fabg0k6k763j89m43n6max72d3a8sxcs940id6qmih";
    inherit dependencies buildDependencies features;
  };
  tokio_signal_0_1_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-signal";
    version = "0.1.5";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1rqbb1n2kzzy3gqc4ha3rd3km1wdgy1mgbbngn5alpq9xvd4x1kz";
    inherit dependencies buildDependencies features;
  };
  tokio_tcp_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-tcp";
    version = "0.1.0";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "19cyajkqvvbn3qqnak0qzivdq6amfjymbc30k7bbqhx4y1pcgqvh";
    inherit dependencies buildDependencies features;
  };
  tokio_threadpool_0_1_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-threadpool";
    version = "0.1.2";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "12690m4cyh6v986xdd705mx2ba4r6mvlmfjfhiqcysyrmv2bk9h2";
    inherit dependencies buildDependencies features;
  };
  tokio_timer_0_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-timer";
    version = "0.2.1";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1igk1jmpgwhhy2giccsshs8smwby6kfyz2fw9y4yav8yp5vzd0r9";
    inherit dependencies buildDependencies features;
  };
  tokio_tls_0_1_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-tls";
    version = "0.1.4";
    authors = [ "Carl Lerche <me@carllerche.com>" "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "07rwv3q6jbg65ln1ahzb4g648l8lcn4hvc0ax3r12bnsi1py7agp";
    inherit dependencies buildDependencies features;
  };
  tokio_udp_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "tokio-udp";
    version = "0.1.0";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0c1wjiqri0xlfrqq2hmgppvl9j8pjy8469s67f08dc8lybmrb1q1";
    inherit dependencies buildDependencies features;
  };
  trust_dns_proto_0_3_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "trust-dns-proto";
    version = "0.3.3";
    authors = [ "Benjamin Fry <benjaminfry@me.com>" ];
    sha256 = "10cf1999j552fdxnk9cq84n26ybj5b8pk2914akag57g035iq1ql";
    libPath = "src/lib.rs";
    libName = "trust_dns_proto";
    inherit dependencies buildDependencies features;
  };
  trust_dns_resolver_0_8_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "trust-dns-resolver";
    version = "0.8.2";
    authors = [ "Benjamin Fry <benjaminfry@me.com>" ];
    sha256 = "0df4ls6gk97zc1931jwm8w9d1mg34h0j4zhm77aaxwq9cjk71xw1";
    libPath = "src/lib.rs";
    libName = "trust_dns_resolver";
    inherit dependencies buildDependencies features;
  };
  twoway_0_1_8_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "twoway";
    version = "0.1.8";
    authors = [ "bluss" ];
    sha256 = "0svrdcy08h0gm884f220hx37g8fsp5z6abaw6jb6g3f7djw1ir1g";
    inherit dependencies buildDependencies features;
  };
  typed_arena_1_3_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "typed-arena";
    version = "1.3.0";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "19yylpxv4mkx5285igiywh57snj6bgk8yw6139cjy7j86nz0mx9s";
    libPath = "src/lib.rs";
    libName = "typed_arena";
    inherit dependencies buildDependencies features;
  };
  ucd_util_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "ucd-util";
    version = "0.1.1";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "02a8h3siipx52b832xc8m8rwasj6nx9jpiwfldw8hp6k205hgkn0";
    inherit dependencies buildDependencies features;
  };
  unicase_1_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unicase";
    version = "1.4.2";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "0rbnhw2mnhcwrij3vczp0sl8zdfmvf2dlh8hly81kj7132kfj0mf";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  unicase_2_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unicase";
    version = "2.1.0";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1zzn16hh8fdx5pnbbnl32q8m2mh4vpd1jm9pdcv969ik83dw4byp";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  unicode_bidi_0_3_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unicode-bidi";
    version = "0.3.4";
    authors = [ "The Servo Project Developers" ];
    sha256 = "0lcd6jasrf8p9p0q20qyf10c6xhvw40m2c4rr105hbk6zy26nj1q";
    libName = "unicode_bidi";
    inherit dependencies buildDependencies features;
  };
  unicode_normalization_0_1_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unicode-normalization";
    version = "0.1.5";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "0hg29g86fca7b65mwk4sm5s838js6bqrl0gabadbazvbsgjam0j5";
    inherit dependencies buildDependencies features;
  };
  unicode_width_0_1_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unicode-width";
    version = "0.1.4";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "1rp7a04icn9y5c0lm74nrd4py0rdl0af8bhdwq7g478n1xifpifl";
    inherit dependencies buildDependencies features;
  };
  unicode_xid_0_0_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.0.4";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "1dc8wkkcd3s6534s5aw4lbjn8m67flkkbnajp5bl8408wdg8rh9v";
    inherit dependencies buildDependencies features;
  };
  unicode_xid_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.1.0";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "05wdmwlfzxhq3nhsxn6wx4q8dhxzzfb9szsz6wiw092m1rjj01zj";
    inherit dependencies buildDependencies features;
  };
  unicode_categories_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unicode_categories";
    version = "0.1.1";
    authors = [ "Sean Gillespie <sean@swgillespie.me>" ];
    sha256 = "0capsv7dgw45sh7gpdgpfnmrjx2rdmkp5m523h35apq51cf8fpdi";
    inherit dependencies buildDependencies features;
  };
  unidecode_0_3_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unidecode";
    version = "0.3.0";
    authors = [ "Amit Chowdhury <amitc97@gmail.com>" ];
    sha256 = "09jqspji8m4n2959n35h36ik0nb0c7xq5cb3i0z6kiczz65ba0rs";
    inherit dependencies buildDependencies features;
  };
  unreachable_1_0_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "unreachable";
    version = "1.0.0";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "1am8czbk5wwr25gbp2zr007744fxjshhdqjz9liz7wl4pnv3whcf";
    inherit dependencies buildDependencies features;
  };
  untrusted_0_5_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "untrusted";
    version = "0.5.1";
    authors = [ "Brian Smith <brian@briansmith.org>" ];
    sha256 = "10nbd2nd9asx0v2g59i188rbpclh2xjaj10cjmp8h8a7in4i9pvd";
    inherit dependencies buildDependencies features;
  };
  url_1_7_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "url";
    version = "1.7.0";
    authors = [ "The rust-url developers" ];
    sha256 = "0333ynhkp47hna88aamz1zpk4lxyzx4ab9n7yhc75g14w27cv8jj";
    inherit dependencies buildDependencies features;
  };
  url_serde_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "url_serde";
    version = "0.2.0";
    authors = [ "The rust-url developers" ];
    sha256 = "07ry87rw0pi1da6b53f7s3f52wx3ihxbcgjd4ldspfv5xh6wipsg";
    inherit dependencies buildDependencies features;
  };
  utf8_ranges_1_0_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "1.0.0";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0rzmqprwjv9yp1n0qqgahgm24872x6c0xddfym5pfndy7a36vkn0";
    inherit dependencies buildDependencies features;
  };
  uuid_0_5_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "uuid";
    version = "0.5.1";
    authors = [ "The Rust Project Developers" ];
    sha256 = "17d4csjmy7fa3ckrm40d3c3v411rw5d4400w756mcrzyw2pm1i2r";
    inherit dependencies buildDependencies features;
  };
  uuid_0_6_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "uuid";
    version = "0.6.3";
    authors = [ "Ashley Mannix<ashleymannix@live.com.au>" "Christopher Armstrong" "Dylan DPC<dylan.dpc@gmail.com>" "Hunar Roop Kahlon<hunar.roop@gmail.com>" ];
    sha256 = "1kjp5xglhab4saaikn95zn3mr4zja7484pv307cb5bxm2sawb8p6";
    inherit dependencies buildDependencies features;
  };
  vcpkg_0_2_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "vcpkg";
    version = "0.2.3";
    authors = [ "Jim McGrath <jimmc2@gmail.com>" ];
    sha256 = "0achi8sfy0wm4q04gj7nwpq9xfx8ynk6vv4r12a3ijg26hispq0c";
    inherit dependencies buildDependencies features;
  };
  vec_map_0_8_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "vec_map";
    version = "0.8.0";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Jorge Aparicio <japaricious@gmail.com>" "Alexis Beingessner <a.beingessner@gmail.com>" "Brian Anderson <>" "tbu- <>" "Manish Goregaokar <>" "Aaron Turon <aturon@mozilla.com>" "Adolfo Ochagavía <>" "Niko Matsakis <>" "Steven Fackler <>" "Chase Southwood <csouth3@illinois.edu>" "Eduard Burtescu <>" "Florian Wilkens <>" "Félix Raimundo <>" "Tibor Benke <>" "Markus Siemens <markus@m-siemens.de>" "Josh Branchaud <jbranchaud@gmail.com>" "Huon Wilson <dbau.pp@gmail.com>" "Corey Farwell <coref@rwell.org>" "Aaron Liblong <>" "Nick Cameron <nrc@ncameron.org>" "Patrick Walton <pcwalton@mimiga.net>" "Felix S Klock II <>" "Andrew Paseltiner <apaseltiner@gmail.com>" "Sean McArthur <sean.monstar@gmail.com>" "Vadim Petrochenkov <>" ];
    sha256 = "07sgxp3cf1a4cxm9n3r27fcvqmld32bl2576mrcahnvm34j11xay";
    inherit dependencies buildDependencies features;
  };
  version_check_0_1_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "version_check";
    version = "0.1.3";
    authors = [ "Sergio Benitez <sb@sergio.bz>" ];
    sha256 = "0z635wdclv9bvafj11fpgndn7y79ibpsnc364pm61i1m4wwg8msg";
    inherit dependencies buildDependencies features;
  };
  void_1_0_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "void";
    version = "1.0.2";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "0h1dm0dx8dhf56a83k68mijyxigqhizpskwxfdrs1drwv2cdclv3";
    inherit dependencies buildDependencies features;
  };
  walkdir_1_0_7_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "walkdir";
    version = "1.0.7";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1ygsc59m8mbnlz0psjxdzm1xjndxpywjwalqcd3pwdarzk1gy1vr";
    inherit dependencies buildDependencies features;
  };
  widestring_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "widestring";
    version = "0.2.2";
    authors = [ "Kathryn Long <squeeself@gmail.com>" ];
    sha256 = "07n6cmk47h8v4bvg7cwawipcn6ijqcfwhf9w6x3r2nw3ghsm2h0a";
    inherit dependencies buildDependencies features;
  };
  winapi_0_2_8_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "winapi";
    version = "0.2.8";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0a45b58ywf12vb7gvj6h3j264nydynmzyqz8d8rqxsj6icqv82as";
    inherit dependencies buildDependencies features;
  };
  winapi_0_3_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.4";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1qbrf5dcnd8j36cawby5d9r5vx07r0l4ryf672pfncnp8895k9lx";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  winapi_build_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "winapi-build";
    version = "0.1.1";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lxlpi87rkhxcwp2ykf1ldw3p108hwm24nywf3jfrvmff4rjhqga";
    libName = "build";
    inherit dependencies buildDependencies features;
  };
  winapi_i686_pc_windows_gnu_0_4_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "winapi-i686-pc-windows-gnu";
    version = "0.4.0";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "05ihkij18r4gamjpxj4gra24514can762imjzlmak5wlzidplzrp";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  winapi_x86_64_pc_windows_gnu_0_4_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "winapi-x86_64-pc-windows-gnu";
    version = "0.4.0";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0n1ylmlsb8yg1v583i4xy0qmqg42275flvbc51hdqjjfjcl9vlbj";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  wincolor_0_1_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "wincolor";
    version = "0.1.6";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0f8m3l86pw6qi31jidqj78pgd15xj914850lyvsxkbln4f1drv47";
    inherit dependencies buildDependencies features;
  };
  winreg_0_5_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "winreg";
    version = "0.5.0";
    authors = [ "Igor Shaula <gentoo90@gmail.com>" ];
    sha256 = "0smhk0h5kcwzpjlhyvx2p6cjda28cchzjbnwbs658rz641q98rcd";
    inherit dependencies buildDependencies features;
  };
  winutil_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "winutil";
    version = "0.1.1";
    authors = [ "Dave Lancaster <lancaster.dave@gmail.com>" ];
    sha256 = "1wvq440hl1v3a65agjbp031gw5jim3qasfvmz703dlz95pbjv45r";
    inherit dependencies buildDependencies features;
  };
  ws2_32_sys_0_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "ws2_32-sys";
    version = "0.2.1";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1zpy9d9wk11sj17fczfngcj28w4xxjs3b4n036yzpy38dxp4f7kc";
    libName = "ws2_32";
    build = "build.rs";
    inherit dependencies buildDependencies features;
  };
  actix_0_5_6 = { features?(actix_0_5_6_features {}) }: actix_0_5_6_ {
    dependencies = mapFeatures features ([ actix_derive_0_2_0 bitflags_1_0_3 bytes_0_4_7 crossbeam_channel_0_1_2 failure_0_1_1 futures_0_1_21 libc_0_2_40 log_0_4_1 smallvec_0_6_1 tokio_core_0_1_17 tokio_io_0_1_6 tokio_signal_0_1_5 trust_dns_resolver_0_8_2 uuid_0_6_3 ]);
    buildDependencies = mapFeatures features ([ skeptic_0_13_2 ]);
  };
  actix_0_5_6_features = f: updateFeatures f (rec {
    actix_0_5_6.default = (f.actix_0_5_6.default or true);
    actix_derive_0_2_0.default = true;
    bitflags_1_0_3.default = true;
    bytes_0_4_7.default = true;
    crossbeam_channel_0_1_2.default = true;
    failure_0_1_1.default = true;
    futures_0_1_21.default = true;
    libc_0_2_40.default = true;
    log_0_4_1.default = true;
    skeptic_0_13_2.default = true;
    smallvec_0_6_1.default = true;
    tokio_core_0_1_17.default = true;
    tokio_io_0_1_6.default = true;
    tokio_signal_0_1_5.default = true;
    trust_dns_resolver_0_8_2.default = true;
    uuid_0_6_3.default = true;
    uuid_0_6_3.v4 = true;
  }) [ actix_derive_0_2_0_features bitflags_1_0_3_features bytes_0_4_7_features crossbeam_channel_0_1_2_features failure_0_1_1_features futures_0_1_21_features libc_0_2_40_features log_0_4_1_features smallvec_0_6_1_features tokio_core_0_1_17_features tokio_io_0_1_6_features tokio_signal_0_1_5_features trust_dns_resolver_0_8_2_features uuid_0_6_3_features skeptic_0_13_2_features ];
  actix_web_0_5_6 = { features?(actix_web_0_5_6_features {}) }: actix_web_0_5_6_ {
    dependencies = mapFeatures features ([ actix_0_5_6 base64_0_9_1 bitflags_1_0_3 byteorder_1_2_2 bytes_0_4_7 cookie_0_10_1 encoding_0_2_33 failure_0_1_1 futures_0_1_21 futures_cpupool_0_1_8 h2_0_1_6 http_0_1_5 http_range_0_1_1 httparse_1_2_4 language_tags_0_2_2 lazy_static_1_0_0 libc_0_2_40 log_0_4_1 mime_0_3_5 mime_guess_2_0_0_alpha_4 mio_0_6_14 net2_0_2_32 num_cpus_1_8_0 percent_encoding_1_0_1 rand_0_4_2 regex_0_2_11 serde_1_0_43 serde_json_1_0_16 serde_urlencoded_0_5_1 sha1_0_6_0 smallvec_0_6_1 time_0_1_39 tokio_core_0_1_17 tokio_io_0_1_6 url_1_7_0 ]
      ++ (if features.actix_web_0_5_6.brotli2 or false then [ brotli2_0_3_2 ] else [])
      ++ (if features.actix_web_0_5_6.flate2 or false then [ flate2_1_0_1 ] else []));
    buildDependencies = mapFeatures features ([ version_check_0_1_3 ]);
    features = mkFeatures (features.actix_web_0_5_6 or {});
  };
  actix_web_0_5_6_features = f: updateFeatures f (rec {
    actix_0_5_6.default = true;
    actix_web_0_5_6.brotli =
      (f.actix_web_0_5_6.brotli or false) ||
      (f.actix_web_0_5_6.default or false) ||
      (actix_web_0_5_6.default or false);
    actix_web_0_5_6.brotli2 =
      (f.actix_web_0_5_6.brotli2 or false) ||
      (f.actix_web_0_5_6.brotli or false) ||
      (actix_web_0_5_6.brotli or false);
    actix_web_0_5_6.default = (f.actix_web_0_5_6.default or true);
    actix_web_0_5_6.flate2-c =
      (f.actix_web_0_5_6.flate2-c or false) ||
      (f.actix_web_0_5_6.default or false) ||
      (actix_web_0_5_6.default or false);
    actix_web_0_5_6.native-tls =
      (f.actix_web_0_5_6.native-tls or false) ||
      (f.actix_web_0_5_6.tls or false) ||
      (actix_web_0_5_6.tls or false);
    actix_web_0_5_6.openssl =
      (f.actix_web_0_5_6.openssl or false) ||
      (f.actix_web_0_5_6.alpn or false) ||
      (actix_web_0_5_6.alpn or false);
    actix_web_0_5_6.session =
      (f.actix_web_0_5_6.session or false) ||
      (f.actix_web_0_5_6.default or false) ||
      (actix_web_0_5_6.default or false);
    actix_web_0_5_6.tokio-openssl =
      (f.actix_web_0_5_6.tokio-openssl or false) ||
      (f.actix_web_0_5_6.alpn or false) ||
      (actix_web_0_5_6.alpn or false);
    actix_web_0_5_6.tokio-tls =
      (f.actix_web_0_5_6.tokio-tls or false) ||
      (f.actix_web_0_5_6.tls or false) ||
      (actix_web_0_5_6.tls or false);
    base64_0_9_1.default = true;
    bitflags_1_0_3.default = true;
    brotli2_0_3_2.default = true;
    byteorder_1_2_2.default = true;
    bytes_0_4_7.default = true;
    cookie_0_10_1.default = true;
    cookie_0_10_1.percent-encode = true;
    cookie_0_10_1.secure =
      (f.cookie_0_10_1.secure or false) ||
      (actix_web_0_5_6.session or false) ||
      (f.actix_web_0_5_6.session or false);
    encoding_0_2_33.default = true;
    failure_0_1_1.default = true;
    flate2_1_0_1.default = (f.flate2_1_0_1.default or false);
    flate2_1_0_1.miniz-sys =
      (f.flate2_1_0_1.miniz-sys or false) ||
      (actix_web_0_5_6.flate2-c or false) ||
      (f.actix_web_0_5_6.flate2-c or false);
    flate2_1_0_1.rust_backend =
      (f.flate2_1_0_1.rust_backend or false) ||
      (actix_web_0_5_6.flate2-rust or false) ||
      (f.actix_web_0_5_6.flate2-rust or false);
    futures_0_1_21.default = true;
    futures_cpupool_0_1_8.default = true;
    h2_0_1_6.default = true;
    http_0_1_5.default = true;
    http_range_0_1_1.default = true;
    httparse_1_2_4.default = true;
    language_tags_0_2_2.default = true;
    lazy_static_1_0_0.default = true;
    libc_0_2_40.default = true;
    log_0_4_1.default = true;
    mime_0_3_5.default = true;
    mime_guess_2_0_0_alpha_4.default = true;
    mio_0_6_14.default = true;
    net2_0_2_32.default = true;
    num_cpus_1_8_0.default = true;
    percent_encoding_1_0_1.default = true;
    rand_0_4_2.default = true;
    regex_0_2_11.default = true;
    serde_1_0_43.default = true;
    serde_json_1_0_16.default = true;
    serde_urlencoded_0_5_1.default = true;
    sha1_0_6_0.default = true;
    smallvec_0_6_1.default = true;
    time_0_1_39.default = true;
    tokio_core_0_1_17.default = true;
    tokio_io_0_1_6.default = true;
    url_1_7_0.default = true;
    url_1_7_0.query_encoding = true;
    version_check_0_1_3.default = true;
  }) [ actix_0_5_6_features base64_0_9_1_features bitflags_1_0_3_features brotli2_0_3_2_features byteorder_1_2_2_features bytes_0_4_7_features cookie_0_10_1_features encoding_0_2_33_features failure_0_1_1_features flate2_1_0_1_features futures_0_1_21_features futures_cpupool_0_1_8_features h2_0_1_6_features http_0_1_5_features http_range_0_1_1_features httparse_1_2_4_features language_tags_0_2_2_features lazy_static_1_0_0_features libc_0_2_40_features log_0_4_1_features mime_0_3_5_features mime_guess_2_0_0_alpha_4_features mio_0_6_14_features net2_0_2_32_features num_cpus_1_8_0_features percent_encoding_1_0_1_features rand_0_4_2_features regex_0_2_11_features serde_1_0_43_features serde_json_1_0_16_features serde_urlencoded_0_5_1_features sha1_0_6_0_features smallvec_0_6_1_features time_0_1_39_features tokio_core_0_1_17_features tokio_io_0_1_6_features url_1_7_0_features version_check_0_1_3_features ];
  actix_derive_0_2_0 = { features?(actix_derive_0_2_0_features {}) }: actix_derive_0_2_0_ {
    dependencies = mapFeatures features ([ quote_0_3_15 rand_0_3_22 syn_0_11_11 ]);
    buildDependencies = mapFeatures features ([ version_check_0_1_3 ]);
  };
  actix_derive_0_2_0_features = f: updateFeatures f (rec {
    actix_derive_0_2_0.default = (f.actix_derive_0_2_0.default or true);
    quote_0_3_15.default = true;
    rand_0_3_22.default = true;
    syn_0_11_11.default = true;
    syn_0_11_11.full = true;
    version_check_0_1_3.default = true;
  }) [ quote_0_3_15_features rand_0_3_22_features syn_0_11_11_features version_check_0_1_3_features ];
  adler32_1_0_2 = { features?(adler32_1_0_2_features {}) }: adler32_1_0_2_ {};
  adler32_1_0_2_features = f: updateFeatures f (rec {
    adler32_1_0_2.default = (f.adler32_1_0_2.default or true);
  }) [];
  aho_corasick_0_6_4 = { features?(aho_corasick_0_6_4_features {}) }: aho_corasick_0_6_4_ {
    dependencies = mapFeatures features ([ memchr_2_0_1 ]);
  };
  aho_corasick_0_6_4_features = f: updateFeatures f (rec {
    aho_corasick_0_6_4.default = (f.aho_corasick_0_6_4.default or true);
    memchr_2_0_1.default = true;
  }) [ memchr_2_0_1_features ];
  ansi_term_0_11_0 = { features?(ansi_term_0_11_0_features {}) }: ansi_term_0_11_0_ {
    dependencies = (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else []);
  };
  ansi_term_0_11_0_features = f: updateFeatures f (rec {
    ansi_term_0_11_0.default = (f.ansi_term_0_11_0.default or true);
    winapi_0_3_4.consoleapi = true;
    winapi_0_3_4.default = true;
    winapi_0_3_4.errhandlingapi = true;
    winapi_0_3_4.processenv = true;
  }) [ winapi_0_3_4_features ];
  antidote_1_0_0 = { features?(antidote_1_0_0_features {}) }: antidote_1_0_0_ {};
  antidote_1_0_0_features = f: updateFeatures f (rec {
    antidote_1_0_0.default = (f.antidote_1_0_0.default or true);
  }) [];
  arrayvec_0_4_7 = { features?(arrayvec_0_4_7_features {}) }: arrayvec_0_4_7_ {
    dependencies = mapFeatures features ([ nodrop_0_1_12 ]);
    features = mkFeatures (features.arrayvec_0_4_7 or {});
  };
  arrayvec_0_4_7_features = f: updateFeatures f (rec {
    arrayvec_0_4_7.default = (f.arrayvec_0_4_7.default or true);
    arrayvec_0_4_7.serde =
      (f.arrayvec_0_4_7.serde or false) ||
      (f.arrayvec_0_4_7.serde-1 or false) ||
      (arrayvec_0_4_7.serde-1 or false);
    arrayvec_0_4_7.std =
      (f.arrayvec_0_4_7.std or false) ||
      (f.arrayvec_0_4_7.default or false) ||
      (arrayvec_0_4_7.default or false);
    nodrop_0_1_12.default = (f.nodrop_0_1_12.default or false);
  }) [ nodrop_0_1_12_features ];
  atty_0_2_10 = { features?(atty_0_2_10_features {}) }: atty_0_2_10_ {
    dependencies = (if kernel == "redox" then mapFeatures features ([ termion_1_5_1 ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else []);
  };
  atty_0_2_10_features = f: updateFeatures f (rec {
    atty_0_2_10.default = (f.atty_0_2_10.default or true);
    libc_0_2_40.default = (f.libc_0_2_40.default or false);
    termion_1_5_1.default = true;
    winapi_0_3_4.consoleapi = true;
    winapi_0_3_4.default = true;
    winapi_0_3_4.minwinbase = true;
    winapi_0_3_4.minwindef = true;
    winapi_0_3_4.processenv = true;
    winapi_0_3_4.winbase = true;
  }) [ termion_1_5_1_features libc_0_2_40_features winapi_0_3_4_features ];
  backtrace_0_2_3 = { features?(backtrace_0_2_3_features {}) }: backtrace_0_2_3_ {
    dependencies = mapFeatures features ([ cfg_if_0_1_2 libc_0_2_40 rustc_demangle_0_1_7 ]
      ++ (if features.backtrace_0_2_3.backtrace-sys or false then [ backtrace_sys_0_1_16 ] else [])
      ++ (if features.backtrace_0_2_3.dbghelp-sys or false then [ dbghelp_sys_0_2_0 ] else [])
      ++ (if features.backtrace_0_2_3.kernel32-sys or false then [ kernel32_sys_0_2_2 ] else [])
      ++ (if features.backtrace_0_2_3.winapi or false then [ winapi_0_2_8 ] else []));
    buildDependencies = mapFeatures features ([]);
    features = mkFeatures (features.backtrace_0_2_3 or {});
  };
  backtrace_0_2_3_features = f: updateFeatures f (rec {
    backtrace_0_2_3.backtrace-sys =
      (f.backtrace_0_2_3.backtrace-sys or false) ||
      (f.backtrace_0_2_3.libbacktrace or false) ||
      (backtrace_0_2_3.libbacktrace or false);
    backtrace_0_2_3.dbghelp =
      (f.backtrace_0_2_3.dbghelp or false) ||
      (f.backtrace_0_2_3.default or false) ||
      (backtrace_0_2_3.default or false);
    backtrace_0_2_3.dbghelp-sys =
      (f.backtrace_0_2_3.dbghelp-sys or false) ||
      (f.backtrace_0_2_3.dbghelp or false) ||
      (backtrace_0_2_3.dbghelp or false);
    backtrace_0_2_3.default = (f.backtrace_0_2_3.default or true);
    backtrace_0_2_3.dladdr =
      (f.backtrace_0_2_3.dladdr or false) ||
      (f.backtrace_0_2_3.default or false) ||
      (backtrace_0_2_3.default or false);
    backtrace_0_2_3.kernel32-sys =
      (f.backtrace_0_2_3.kernel32-sys or false) ||
      (f.backtrace_0_2_3.dbghelp or false) ||
      (backtrace_0_2_3.dbghelp or false);
    backtrace_0_2_3.libbacktrace =
      (f.backtrace_0_2_3.libbacktrace or false) ||
      (f.backtrace_0_2_3.default or false) ||
      (backtrace_0_2_3.default or false);
    backtrace_0_2_3.libunwind =
      (f.backtrace_0_2_3.libunwind or false) ||
      (f.backtrace_0_2_3.default or false) ||
      (backtrace_0_2_3.default or false);
    backtrace_0_2_3.rustc-serialize =
      (f.backtrace_0_2_3.rustc-serialize or false) ||
      (f.backtrace_0_2_3.serialize-rustc or false) ||
      (backtrace_0_2_3.serialize-rustc or false);
    backtrace_0_2_3.serde =
      (f.backtrace_0_2_3.serde or false) ||
      (f.backtrace_0_2_3.serialize-serde or false) ||
      (backtrace_0_2_3.serialize-serde or false);
    backtrace_0_2_3.serde_codegen =
      (f.backtrace_0_2_3.serde_codegen or false) ||
      (f.backtrace_0_2_3.serialize-serde or false) ||
      (backtrace_0_2_3.serialize-serde or false);
    backtrace_0_2_3.winapi =
      (f.backtrace_0_2_3.winapi or false) ||
      (f.backtrace_0_2_3.dbghelp or false) ||
      (backtrace_0_2_3.dbghelp or false);
    backtrace_sys_0_1_16.default = true;
    cfg_if_0_1_2.default = true;
    dbghelp_sys_0_2_0.default = true;
    kernel32_sys_0_2_2.default = true;
    libc_0_2_40.default = true;
    rustc_demangle_0_1_7.default = true;
    winapi_0_2_8.default = true;
  }) [ backtrace_sys_0_1_16_features cfg_if_0_1_2_features dbghelp_sys_0_2_0_features kernel32_sys_0_2_2_features libc_0_2_40_features rustc_demangle_0_1_7_features winapi_0_2_8_features ];
  backtrace_0_3_6 = { features?(backtrace_0_3_6_features {}) }: backtrace_0_3_6_ {
    dependencies = mapFeatures features ([ cfg_if_0_1_2 rustc_demangle_0_1_7 ])
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "fuchsia") && !(kernel == "emscripten") && !(kernel == "darwin") && !(kernel == "ios") then mapFeatures features ([ ]
      ++ (if features.backtrace_0_3_6.backtrace-sys or false then [ backtrace_sys_0_1_16 ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ ]
      ++ (if features.backtrace_0_3_6.winapi or false then [ winapi_0_3_4 ] else [])) else []);
    features = mkFeatures (features.backtrace_0_3_6 or {});
  };
  backtrace_0_3_6_features = f: updateFeatures f (rec {
    backtrace_0_3_6.addr2line =
      (f.backtrace_0_3_6.addr2line or false) ||
      (f.backtrace_0_3_6.gimli-symbolize or false) ||
      (backtrace_0_3_6.gimli-symbolize or false);
    backtrace_0_3_6.backtrace-sys =
      (f.backtrace_0_3_6.backtrace-sys or false) ||
      (f.backtrace_0_3_6.libbacktrace or false) ||
      (backtrace_0_3_6.libbacktrace or false);
    backtrace_0_3_6.coresymbolication =
      (f.backtrace_0_3_6.coresymbolication or false) ||
      (f.backtrace_0_3_6.default or false) ||
      (backtrace_0_3_6.default or false);
    backtrace_0_3_6.dbghelp =
      (f.backtrace_0_3_6.dbghelp or false) ||
      (f.backtrace_0_3_6.default or false) ||
      (backtrace_0_3_6.default or false);
    backtrace_0_3_6.default = (f.backtrace_0_3_6.default or true);
    backtrace_0_3_6.dladdr =
      (f.backtrace_0_3_6.dladdr or false) ||
      (f.backtrace_0_3_6.default or false) ||
      (backtrace_0_3_6.default or false);
    backtrace_0_3_6.findshlibs =
      (f.backtrace_0_3_6.findshlibs or false) ||
      (f.backtrace_0_3_6.gimli-symbolize or false) ||
      (backtrace_0_3_6.gimli-symbolize or false);
    backtrace_0_3_6.gimli =
      (f.backtrace_0_3_6.gimli or false) ||
      (f.backtrace_0_3_6.gimli-symbolize or false) ||
      (backtrace_0_3_6.gimli-symbolize or false);
    backtrace_0_3_6.libbacktrace =
      (f.backtrace_0_3_6.libbacktrace or false) ||
      (f.backtrace_0_3_6.default or false) ||
      (backtrace_0_3_6.default or false);
    backtrace_0_3_6.libunwind =
      (f.backtrace_0_3_6.libunwind or false) ||
      (f.backtrace_0_3_6.default or false) ||
      (backtrace_0_3_6.default or false);
    backtrace_0_3_6.memmap =
      (f.backtrace_0_3_6.memmap or false) ||
      (f.backtrace_0_3_6.gimli-symbolize or false) ||
      (backtrace_0_3_6.gimli-symbolize or false);
    backtrace_0_3_6.object =
      (f.backtrace_0_3_6.object or false) ||
      (f.backtrace_0_3_6.gimli-symbolize or false) ||
      (backtrace_0_3_6.gimli-symbolize or false);
    backtrace_0_3_6.rustc-serialize =
      (f.backtrace_0_3_6.rustc-serialize or false) ||
      (f.backtrace_0_3_6.serialize-rustc or false) ||
      (backtrace_0_3_6.serialize-rustc or false);
    backtrace_0_3_6.serde =
      (f.backtrace_0_3_6.serde or false) ||
      (f.backtrace_0_3_6.serialize-serde or false) ||
      (backtrace_0_3_6.serialize-serde or false);
    backtrace_0_3_6.serde_derive =
      (f.backtrace_0_3_6.serde_derive or false) ||
      (f.backtrace_0_3_6.serialize-serde or false) ||
      (backtrace_0_3_6.serialize-serde or false);
    backtrace_0_3_6.winapi =
      (f.backtrace_0_3_6.winapi or false) ||
      (f.backtrace_0_3_6.dbghelp or false) ||
      (backtrace_0_3_6.dbghelp or false);
    backtrace_sys_0_1_16.default = true;
    cfg_if_0_1_2.default = true;
    libc_0_2_40.default = true;
    rustc_demangle_0_1_7.default = true;
    winapi_0_3_4.dbghelp = true;
    winapi_0_3_4.default = true;
    winapi_0_3_4.minwindef = true;
    winapi_0_3_4.processthreadsapi = true;
    winapi_0_3_4.std = true;
    winapi_0_3_4.winnt = true;
  }) [ cfg_if_0_1_2_features rustc_demangle_0_1_7_features backtrace_sys_0_1_16_features libc_0_2_40_features winapi_0_3_4_features ];
  backtrace_sys_0_1_16 = { features?(backtrace_sys_0_1_16_features {}) }: backtrace_sys_0_1_16_ {
    dependencies = mapFeatures features ([ libc_0_2_40 ]);
    buildDependencies = mapFeatures features ([ cc_1_0_15 ]);
  };
  backtrace_sys_0_1_16_features = f: updateFeatures f (rec {
    backtrace_sys_0_1_16.default = (f.backtrace_sys_0_1_16.default or true);
    cc_1_0_15.default = true;
    libc_0_2_40.default = true;
  }) [ libc_0_2_40_features cc_1_0_15_features ];
  base64_0_6_0 = { features?(base64_0_6_0_features {}) }: base64_0_6_0_ {
    dependencies = mapFeatures features ([ byteorder_1_2_2 safemem_0_2_0 ]);
  };
  base64_0_6_0_features = f: updateFeatures f (rec {
    base64_0_6_0.default = (f.base64_0_6_0.default or true);
    byteorder_1_2_2.default = true;
    safemem_0_2_0.default = true;
  }) [ byteorder_1_2_2_features safemem_0_2_0_features ];
  base64_0_9_1 = { features?(base64_0_9_1_features {}) }: base64_0_9_1_ {
    dependencies = mapFeatures features ([ byteorder_1_2_2 safemem_0_2_0 ]);
  };
  base64_0_9_1_features = f: updateFeatures f (rec {
    base64_0_9_1.default = (f.base64_0_9_1.default or true);
    byteorder_1_2_2.default = true;
    safemem_0_2_0.default = true;
  }) [ byteorder_1_2_2_features safemem_0_2_0_features ];
  bitflags_0_9_1 = { features?(bitflags_0_9_1_features {}) }: bitflags_0_9_1_ {
    features = mkFeatures (features.bitflags_0_9_1 or {});
  };
  bitflags_0_9_1_features = f: updateFeatures f (rec {
    bitflags_0_9_1.default = (f.bitflags_0_9_1.default or true);
    bitflags_0_9_1.example_generated =
      (f.bitflags_0_9_1.example_generated or false) ||
      (f.bitflags_0_9_1.default or false) ||
      (bitflags_0_9_1.default or false);
  }) [];
  bitflags_1_0_3 = { features?(bitflags_1_0_3_features {}) }: bitflags_1_0_3_ {
    features = mkFeatures (features.bitflags_1_0_3 or {});
  };
  bitflags_1_0_3_features = f: updateFeatures f (rec {
    bitflags_1_0_3.default = (f.bitflags_1_0_3.default or true);
  }) [];
  brotli_sys_0_3_2 = { features?(brotli_sys_0_3_2_features {}) }: brotli_sys_0_3_2_ {
    dependencies = mapFeatures features ([ libc_0_2_40 ]);
    buildDependencies = mapFeatures features ([ cc_1_0_15 ]);
  };
  brotli_sys_0_3_2_features = f: updateFeatures f (rec {
    brotli_sys_0_3_2.default = (f.brotli_sys_0_3_2.default or true);
    cc_1_0_15.default = true;
    libc_0_2_40.default = true;
  }) [ libc_0_2_40_features cc_1_0_15_features ];
  brotli2_0_3_2 = { features?(brotli2_0_3_2_features {}) }: brotli2_0_3_2_ {
    dependencies = mapFeatures features ([ brotli_sys_0_3_2 libc_0_2_40 ]);
  };
  brotli2_0_3_2_features = f: updateFeatures f (rec {
    brotli2_0_3_2.default = (f.brotli2_0_3_2.default or true);
    brotli_sys_0_3_2.default = true;
    libc_0_2_40.default = true;
  }) [ brotli_sys_0_3_2_features libc_0_2_40_features ];
  build_const_0_2_1 = { features?(build_const_0_2_1_features {}) }: build_const_0_2_1_ {
    features = mkFeatures (features.build_const_0_2_1 or {});
  };
  build_const_0_2_1_features = f: updateFeatures f (rec {
    build_const_0_2_1.default = (f.build_const_0_2_1.default or true);
    build_const_0_2_1.std =
      (f.build_const_0_2_1.std or false) ||
      (f.build_const_0_2_1.default or false) ||
      (build_const_0_2_1.default or false);
  }) [];
  bytecount_0_2_0 = { features?(bytecount_0_2_0_features {}) }: bytecount_0_2_0_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.bytecount_0_2_0 or {});
  };
  bytecount_0_2_0_features = f: updateFeatures f (rec {
    bytecount_0_2_0.default = (f.bytecount_0_2_0.default or true);
    bytecount_0_2_0.simd =
      (f.bytecount_0_2_0.simd or false) ||
      (f.bytecount_0_2_0.simd-accel or false) ||
      (bytecount_0_2_0.simd-accel or false);
    bytecount_0_2_0.simd-accel =
      (f.bytecount_0_2_0.simd-accel or false) ||
      (f.bytecount_0_2_0.avx-accel or false) ||
      (bytecount_0_2_0.avx-accel or false);
  }) [];
  byteorder_1_2_2 = { features?(byteorder_1_2_2_features {}) }: byteorder_1_2_2_ {
    features = mkFeatures (features.byteorder_1_2_2 or {});
  };
  byteorder_1_2_2_features = f: updateFeatures f (rec {
    byteorder_1_2_2.default = (f.byteorder_1_2_2.default or true);
    byteorder_1_2_2.std =
      (f.byteorder_1_2_2.std or false) ||
      (f.byteorder_1_2_2.default or false) ||
      (byteorder_1_2_2.default or false);
  }) [];
  bytes_0_4_7 = { features?(bytes_0_4_7_features {}) }: bytes_0_4_7_ {
    dependencies = mapFeatures features ([ byteorder_1_2_2 iovec_0_1_2 ]);
  };
  bytes_0_4_7_features = f: updateFeatures f (rec {
    byteorder_1_2_2.default = true;
    bytes_0_4_7.default = (f.bytes_0_4_7.default or true);
    iovec_0_1_2.default = true;
  }) [ byteorder_1_2_2_features iovec_0_1_2_features ];
  cargo_metadata_0_3_3 = { features?(cargo_metadata_0_3_3_features {}) }: cargo_metadata_0_3_3_ {
    dependencies = mapFeatures features ([ error_chain_0_11_0 semver_0_8_0 serde_1_0_43 serde_derive_1_0_43 serde_json_1_0_16 ]);
  };
  cargo_metadata_0_3_3_features = f: updateFeatures f (rec {
    cargo_metadata_0_3_3.default = (f.cargo_metadata_0_3_3.default or true);
    error_chain_0_11_0.default = true;
    semver_0_8_0.default = true;
    semver_0_8_0.serde = true;
    serde_1_0_43.default = true;
    serde_derive_1_0_43.default = true;
    serde_json_1_0_16.default = true;
  }) [ error_chain_0_11_0_features semver_0_8_0_features serde_1_0_43_features serde_derive_1_0_43_features serde_json_1_0_16_features ];
  cc_1_0_15 = { features?(cc_1_0_15_features {}) }: cc_1_0_15_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.cc_1_0_15 or {});
  };
  cc_1_0_15_features = f: updateFeatures f (rec {
    cc_1_0_15.default = (f.cc_1_0_15.default or true);
    cc_1_0_15.rayon =
      (f.cc_1_0_15.rayon or false) ||
      (f.cc_1_0_15.parallel or false) ||
      (cc_1_0_15.parallel or false);
  }) [];
  cfg_if_0_1_2 = { features?(cfg_if_0_1_2_features {}) }: cfg_if_0_1_2_ {};
  cfg_if_0_1_2_features = f: updateFeatures f (rec {
    cfg_if_0_1_2.default = (f.cfg_if_0_1_2.default or true);
  }) [];
  chrono_0_4_2 = { features?(chrono_0_4_2_features {}) }: chrono_0_4_2_ {
    dependencies = mapFeatures features ([ num_integer_0_1_36 num_traits_0_2_2 ]
      ++ (if features.chrono_0_4_2.serde or false then [ serde_1_0_43 ] else [])
      ++ (if features.chrono_0_4_2.time or false then [ time_0_1_39 ] else []));
    features = mkFeatures (features.chrono_0_4_2 or {});
  };
  chrono_0_4_2_features = f: updateFeatures f (rec {
    chrono_0_4_2.clock =
      (f.chrono_0_4_2.clock or false) ||
      (f.chrono_0_4_2.default or false) ||
      (chrono_0_4_2.default or false);
    chrono_0_4_2.default = (f.chrono_0_4_2.default or true);
    chrono_0_4_2.time =
      (f.chrono_0_4_2.time or false) ||
      (f.chrono_0_4_2.clock or false) ||
      (chrono_0_4_2.clock or false);
    num_integer_0_1_36.default = (f.num_integer_0_1_36.default or false);
    num_traits_0_2_2.default = (f.num_traits_0_2_2.default or false);
    serde_1_0_43.default = true;
    time_0_1_39.default = true;
  }) [ num_integer_0_1_36_features num_traits_0_2_2_features serde_1_0_43_features time_0_1_39_features ];
  clap_2_31_2 = { features?(clap_2_31_2_features {}) }: clap_2_31_2_ {
    dependencies = mapFeatures features ([ bitflags_1_0_3 textwrap_0_9_0 unicode_width_0_1_4 ]
      ++ (if features.clap_2_31_2.atty or false then [ atty_0_2_10 ] else [])
      ++ (if features.clap_2_31_2.strsim or false then [ strsim_0_7_0 ] else [])
      ++ (if features.clap_2_31_2.vec_map or false then [ vec_map_0_8_0 ] else []))
      ++ (if !(kernel == "windows") then mapFeatures features ([ ]
      ++ (if features.clap_2_31_2.ansi_term or false then [ ansi_term_0_11_0 ] else [])) else []);
    features = mkFeatures (features.clap_2_31_2 or {});
  };
  clap_2_31_2_features = f: updateFeatures f (rec {
    ansi_term_0_11_0.default = true;
    atty_0_2_10.default = true;
    bitflags_1_0_3.default = true;
    clap_2_31_2.ansi_term =
      (f.clap_2_31_2.ansi_term or false) ||
      (f.clap_2_31_2.color or false) ||
      (clap_2_31_2.color or false);
    clap_2_31_2.atty =
      (f.clap_2_31_2.atty or false) ||
      (f.clap_2_31_2.color or false) ||
      (clap_2_31_2.color or false);
    clap_2_31_2.clippy =
      (f.clap_2_31_2.clippy or false) ||
      (f.clap_2_31_2.lints or false) ||
      (clap_2_31_2.lints or false);
    clap_2_31_2.color =
      (f.clap_2_31_2.color or false) ||
      (f.clap_2_31_2.default or false) ||
      (clap_2_31_2.default or false);
    clap_2_31_2.default = (f.clap_2_31_2.default or true);
    clap_2_31_2.strsim =
      (f.clap_2_31_2.strsim or false) ||
      (f.clap_2_31_2.suggestions or false) ||
      (clap_2_31_2.suggestions or false);
    clap_2_31_2.suggestions =
      (f.clap_2_31_2.suggestions or false) ||
      (f.clap_2_31_2.default or false) ||
      (clap_2_31_2.default or false);
    clap_2_31_2.term_size =
      (f.clap_2_31_2.term_size or false) ||
      (f.clap_2_31_2.wrap_help or false) ||
      (clap_2_31_2.wrap_help or false);
    clap_2_31_2.vec_map =
      (f.clap_2_31_2.vec_map or false) ||
      (f.clap_2_31_2.default or false) ||
      (clap_2_31_2.default or false);
    clap_2_31_2.yaml =
      (f.clap_2_31_2.yaml or false) ||
      (f.clap_2_31_2.doc or false) ||
      (clap_2_31_2.doc or false);
    clap_2_31_2.yaml-rust =
      (f.clap_2_31_2.yaml-rust or false) ||
      (f.clap_2_31_2.yaml or false) ||
      (clap_2_31_2.yaml or false);
    strsim_0_7_0.default = true;
    textwrap_0_9_0.default = true;
    textwrap_0_9_0.term_size =
      (f.textwrap_0_9_0.term_size or false) ||
      (clap_2_31_2.wrap_help or false) ||
      (f.clap_2_31_2.wrap_help or false);
    unicode_width_0_1_4.default = true;
    vec_map_0_8_0.default = true;
  }) [ atty_0_2_10_features bitflags_1_0_3_features strsim_0_7_0_features textwrap_0_9_0_features unicode_width_0_1_4_features vec_map_0_8_0_features ansi_term_0_11_0_features ];
  comrak_0_2_9 = { features?(comrak_0_2_9_features {}) }: (comrak_0_2_9_ {
    dependencies = mapFeatures features ([ entities_1_0_1 lazy_static_1_0_0 pest_1_0_6 pest_derive_1_0_7 regex_0_2_11 twoway_0_1_8 typed_arena_1_3_0 unicode_categories_0_1_1 ]
      ++ (if features.comrak_0_2_9.clap or false then [ clap_2_31_2 ] else []));
    features = mkFeatures (features.comrak_0_2_9 or {});
  }).overrideAttrs (oldAttrs: rec { CARGO_PKG_DESCRIPTION = "dummy"; });
  comrak_0_2_9_features = f: updateFeatures f (rec {
    clap_2_31_2.default = true;
    comrak_0_2_9.clap =
      (f.comrak_0_2_9.clap or false) ||
      (f.comrak_0_2_9.default or false) ||
      (comrak_0_2_9.default or false);
    comrak_0_2_9.default = (f.comrak_0_2_9.default or true);
    entities_1_0_1.default = true;
    lazy_static_1_0_0.default = true;
    pest_1_0_6.default = true;
    pest_derive_1_0_7.default = true;
    regex_0_2_11.default = true;
    twoway_0_1_8.default = true;
    typed_arena_1_3_0.default = true;
    unicode_categories_0_1_1.default = true;
  }) [ clap_2_31_2_features entities_1_0_1_features lazy_static_1_0_0_features pest_1_0_6_features pest_derive_1_0_7_features regex_0_2_11_features twoway_0_1_8_features typed_arena_1_3_0_features unicode_categories_0_1_1_features ];
  converse_0_1_0 = { features?(converse_0_1_0_features {}) }: converse_0_1_0_ {
    dependencies = mapFeatures features ([ actix_0_5_6 actix_web_0_5_6 chrono_0_4_2 comrak_0_2_9 diesel_1_2_2 env_logger_0_5_9 failure_0_1_1 futures_0_1_21 hyper_0_11_25 log_0_4_1 md5_0_3_7 r2d2_0_8_2 rand_0_4_2 reqwest_0_8_5 serde_1_0_43 serde_derive_1_0_43 serde_json_1_0_16 tera_0_11_7 tokio_0_1_5 tokio_timer_0_2_1 url_1_7_0 url_serde_0_2_0 ]);
    buildDependencies = mapFeatures features ([ pulldown_cmark_0_1_2 ]);
  };
  converse_0_1_0_features = f: updateFeatures f (rec {
    actix_0_5_6.default = true;
    actix_web_0_5_6.default = true;
    chrono_0_4_2.default = true;
    chrono_0_4_2.serde = true;
    comrak_0_2_9.default = true;
    converse_0_1_0.default = (f.converse_0_1_0.default or true);
    diesel_1_2_2.chrono = true;
    diesel_1_2_2.default = true;
    diesel_1_2_2.postgres = true;
    diesel_1_2_2.r2d2 = true;
    env_logger_0_5_9.default = true;
    failure_0_1_1.default = true;
    futures_0_1_21.default = true;
    hyper_0_11_25.default = true;
    log_0_4_1.default = true;
    md5_0_3_7.default = true;
    pulldown_cmark_0_1_2.default = true;
    r2d2_0_8_2.default = true;
    rand_0_4_2.default = true;
    reqwest_0_8_5.default = true;
    serde_1_0_43.default = true;
    serde_derive_1_0_43.default = true;
    serde_json_1_0_16.default = true;
    tera_0_11_7.default = true;
    tokio_0_1_5.default = true;
    tokio_timer_0_2_1.default = true;
    url_1_7_0.default = true;
    url_serde_0_2_0.default = true;
  }) [ actix_0_5_6_features actix_web_0_5_6_features chrono_0_4_2_features comrak_0_2_9_features diesel_1_2_2_features env_logger_0_5_9_features failure_0_1_1_features futures_0_1_21_features hyper_0_11_25_features log_0_4_1_features md5_0_3_7_features r2d2_0_8_2_features rand_0_4_2_features reqwest_0_8_5_features serde_1_0_43_features serde_derive_1_0_43_features serde_json_1_0_16_features tera_0_11_7_features tokio_0_1_5_features tokio_timer_0_2_1_features url_1_7_0_features url_serde_0_2_0_features pulldown_cmark_0_1_2_features ];
  cookie_0_10_1 = { features?(cookie_0_10_1_features {}) }: cookie_0_10_1_ {
    dependencies = mapFeatures features ([ time_0_1_39 ]
      ++ (if features.cookie_0_10_1.base64 or false then [ base64_0_6_0 ] else [])
      ++ (if features.cookie_0_10_1.ring or false then [ ring_0_12_1 ] else [])
      ++ (if features.cookie_0_10_1.url or false then [ url_1_7_0 ] else []));
    features = mkFeatures (features.cookie_0_10_1 or {});
  };
  cookie_0_10_1_features = f: updateFeatures f (rec {
    base64_0_6_0.default = true;
    cookie_0_10_1.base64 =
      (f.cookie_0_10_1.base64 or false) ||
      (f.cookie_0_10_1.secure or false) ||
      (cookie_0_10_1.secure or false);
    cookie_0_10_1.default = (f.cookie_0_10_1.default or true);
    cookie_0_10_1.ring =
      (f.cookie_0_10_1.ring or false) ||
      (f.cookie_0_10_1.secure or false) ||
      (cookie_0_10_1.secure or false);
    cookie_0_10_1.url =
      (f.cookie_0_10_1.url or false) ||
      (f.cookie_0_10_1.percent-encode or false) ||
      (cookie_0_10_1.percent-encode or false);
    ring_0_12_1.default = true;
    time_0_1_39.default = true;
    url_1_7_0.default = true;
  }) [ base64_0_6_0_features ring_0_12_1_features time_0_1_39_features url_1_7_0_features ];
  core_foundation_0_2_3 = { features?(core_foundation_0_2_3_features {}) }: core_foundation_0_2_3_ {
    dependencies = mapFeatures features ([ core_foundation_sys_0_2_3 libc_0_2_40 ]);
  };
  core_foundation_0_2_3_features = f: updateFeatures f (rec {
    core_foundation_0_2_3.default = (f.core_foundation_0_2_3.default or true);
    core_foundation_sys_0_2_3.default = true;
    libc_0_2_40.default = true;
  }) [ core_foundation_sys_0_2_3_features libc_0_2_40_features ];
  core_foundation_sys_0_2_3 = { features?(core_foundation_sys_0_2_3_features {}) }: core_foundation_sys_0_2_3_ {
    dependencies = mapFeatures features ([ libc_0_2_40 ]);
  };
  core_foundation_sys_0_2_3_features = f: updateFeatures f (rec {
    core_foundation_sys_0_2_3.default = (f.core_foundation_sys_0_2_3.default or true);
    libc_0_2_40.default = true;
  }) [ libc_0_2_40_features ];
  crc_1_8_1 = { features?(crc_1_8_1_features {}) }: crc_1_8_1_ {
    buildDependencies = mapFeatures features ([ build_const_0_2_1 ]);
    features = mkFeatures (features.crc_1_8_1 or {});
  };
  crc_1_8_1_features = f: updateFeatures f (rec {
    build_const_0_2_1.default = true;
    crc_1_8_1.default = (f.crc_1_8_1.default or true);
    crc_1_8_1.std =
      (f.crc_1_8_1.std or false) ||
      (f.crc_1_8_1.default or false) ||
      (crc_1_8_1.default or false);
  }) [ build_const_0_2_1_features ];
  crossbeam_channel_0_1_2 = { features?(crossbeam_channel_0_1_2_features {}) }: crossbeam_channel_0_1_2_ {
    dependencies = mapFeatures features ([ crossbeam_epoch_0_2_0 crossbeam_utils_0_2_2 parking_lot_0_4_8 ]);
    features = mkFeatures (features.crossbeam_channel_0_1_2 or {});
  };
  crossbeam_channel_0_1_2_features = f: updateFeatures f (rec {
    crossbeam_channel_0_1_2.default = (f.crossbeam_channel_0_1_2.default or true);
    crossbeam_epoch_0_2_0.default = true;
    crossbeam_utils_0_2_2.default = true;
    parking_lot_0_4_8.default = true;
  }) [ crossbeam_epoch_0_2_0_features crossbeam_utils_0_2_2_features parking_lot_0_4_8_features ];
  crossbeam_deque_0_2_0 = { features?(crossbeam_deque_0_2_0_features {}) }: crossbeam_deque_0_2_0_ {
    dependencies = mapFeatures features ([ crossbeam_epoch_0_3_1 crossbeam_utils_0_2_2 ]);
  };
  crossbeam_deque_0_2_0_features = f: updateFeatures f (rec {
    crossbeam_deque_0_2_0.default = (f.crossbeam_deque_0_2_0.default or true);
    crossbeam_epoch_0_3_1.default = true;
    crossbeam_utils_0_2_2.default = true;
  }) [ crossbeam_epoch_0_3_1_features crossbeam_utils_0_2_2_features ];
  crossbeam_deque_0_3_0 = { features?(crossbeam_deque_0_3_0_features {}) }: crossbeam_deque_0_3_0_ {
    dependencies = mapFeatures features ([ crossbeam_epoch_0_4_1 crossbeam_utils_0_2_2 ]);
  };
  crossbeam_deque_0_3_0_features = f: updateFeatures f (rec {
    crossbeam_deque_0_3_0.default = (f.crossbeam_deque_0_3_0.default or true);
    crossbeam_epoch_0_4_1.default = true;
    crossbeam_utils_0_2_2.default = true;
  }) [ crossbeam_epoch_0_4_1_features crossbeam_utils_0_2_2_features ];
  crossbeam_epoch_0_2_0 = { features?(crossbeam_epoch_0_2_0_features {}) }: crossbeam_epoch_0_2_0_ {
    dependencies = mapFeatures features ([ arrayvec_0_4_7 cfg_if_0_1_2 crossbeam_utils_0_2_2 memoffset_0_1_0 scopeguard_0_3_3 ]
      ++ (if features.crossbeam_epoch_0_2_0.lazy_static or false then [ lazy_static_0_2_11 ] else []));
    features = mkFeatures (features.crossbeam_epoch_0_2_0 or {});
  };
  crossbeam_epoch_0_2_0_features = f: updateFeatures f (rec {
    arrayvec_0_4_7.default = (f.arrayvec_0_4_7.default or false);
    arrayvec_0_4_7.use_union =
      (f.arrayvec_0_4_7.use_union or false) ||
      (crossbeam_epoch_0_2_0.nightly or false) ||
      (f.crossbeam_epoch_0_2_0.nightly or false);
    cfg_if_0_1_2.default = true;
    crossbeam_epoch_0_2_0.default = (f.crossbeam_epoch_0_2_0.default or true);
    crossbeam_epoch_0_2_0.lazy_static =
      (f.crossbeam_epoch_0_2_0.lazy_static or false) ||
      (f.crossbeam_epoch_0_2_0.use_std or false) ||
      (crossbeam_epoch_0_2_0.use_std or false);
    crossbeam_epoch_0_2_0.use_std =
      (f.crossbeam_epoch_0_2_0.use_std or false) ||
      (f.crossbeam_epoch_0_2_0.default or false) ||
      (crossbeam_epoch_0_2_0.default or false);
    crossbeam_utils_0_2_2.default = (f.crossbeam_utils_0_2_2.default or false);
    crossbeam_utils_0_2_2.use_std =
      (f.crossbeam_utils_0_2_2.use_std or false) ||
      (crossbeam_epoch_0_2_0.use_std or false) ||
      (f.crossbeam_epoch_0_2_0.use_std or false);
    lazy_static_0_2_11.default = true;
    memoffset_0_1_0.default = (f.memoffset_0_1_0.default or false);
    scopeguard_0_3_3.default = (f.scopeguard_0_3_3.default or false);
  }) [ arrayvec_0_4_7_features cfg_if_0_1_2_features crossbeam_utils_0_2_2_features lazy_static_0_2_11_features memoffset_0_1_0_features scopeguard_0_3_3_features ];
  crossbeam_epoch_0_3_1 = { features?(crossbeam_epoch_0_3_1_features {}) }: crossbeam_epoch_0_3_1_ {
    dependencies = mapFeatures features ([ arrayvec_0_4_7 cfg_if_0_1_2 crossbeam_utils_0_2_2 memoffset_0_2_1 nodrop_0_1_12 scopeguard_0_3_3 ]
      ++ (if features.crossbeam_epoch_0_3_1.lazy_static or false then [ lazy_static_1_0_0 ] else []));
    features = mkFeatures (features.crossbeam_epoch_0_3_1 or {});
  };
  crossbeam_epoch_0_3_1_features = f: updateFeatures f (rec {
    arrayvec_0_4_7.default = (f.arrayvec_0_4_7.default or false);
    arrayvec_0_4_7.use_union =
      (f.arrayvec_0_4_7.use_union or false) ||
      (crossbeam_epoch_0_3_1.nightly or false) ||
      (f.crossbeam_epoch_0_3_1.nightly or false);
    cfg_if_0_1_2.default = true;
    crossbeam_epoch_0_3_1.default = (f.crossbeam_epoch_0_3_1.default or true);
    crossbeam_epoch_0_3_1.lazy_static =
      (f.crossbeam_epoch_0_3_1.lazy_static or false) ||
      (f.crossbeam_epoch_0_3_1.use_std or false) ||
      (crossbeam_epoch_0_3_1.use_std or false);
    crossbeam_epoch_0_3_1.use_std =
      (f.crossbeam_epoch_0_3_1.use_std or false) ||
      (f.crossbeam_epoch_0_3_1.default or false) ||
      (crossbeam_epoch_0_3_1.default or false);
    crossbeam_utils_0_2_2.default = (f.crossbeam_utils_0_2_2.default or false);
    crossbeam_utils_0_2_2.use_std =
      (f.crossbeam_utils_0_2_2.use_std or false) ||
      (crossbeam_epoch_0_3_1.use_std or false) ||
      (f.crossbeam_epoch_0_3_1.use_std or false);
    lazy_static_1_0_0.default = true;
    memoffset_0_2_1.default = true;
    nodrop_0_1_12.default = (f.nodrop_0_1_12.default or false);
    scopeguard_0_3_3.default = (f.scopeguard_0_3_3.default or false);
  }) [ arrayvec_0_4_7_features cfg_if_0_1_2_features crossbeam_utils_0_2_2_features lazy_static_1_0_0_features memoffset_0_2_1_features nodrop_0_1_12_features scopeguard_0_3_3_features ];
  crossbeam_epoch_0_4_1 = { features?(crossbeam_epoch_0_4_1_features {}) }: crossbeam_epoch_0_4_1_ {
    dependencies = mapFeatures features ([ arrayvec_0_4_7 cfg_if_0_1_2 crossbeam_utils_0_3_2 memoffset_0_2_1 scopeguard_0_3_3 ]
      ++ (if features.crossbeam_epoch_0_4_1.lazy_static or false then [ lazy_static_1_0_0 ] else []));
    features = mkFeatures (features.crossbeam_epoch_0_4_1 or {});
  };
  crossbeam_epoch_0_4_1_features = f: updateFeatures f (rec {
    arrayvec_0_4_7.default = (f.arrayvec_0_4_7.default or false);
    arrayvec_0_4_7.use_union =
      (f.arrayvec_0_4_7.use_union or false) ||
      (crossbeam_epoch_0_4_1.nightly or false) ||
      (f.crossbeam_epoch_0_4_1.nightly or false);
    cfg_if_0_1_2.default = true;
    crossbeam_epoch_0_4_1.default = (f.crossbeam_epoch_0_4_1.default or true);
    crossbeam_epoch_0_4_1.lazy_static =
      (f.crossbeam_epoch_0_4_1.lazy_static or false) ||
      (f.crossbeam_epoch_0_4_1.use_std or false) ||
      (crossbeam_epoch_0_4_1.use_std or false);
    crossbeam_epoch_0_4_1.use_std =
      (f.crossbeam_epoch_0_4_1.use_std or false) ||
      (f.crossbeam_epoch_0_4_1.default or false) ||
      (crossbeam_epoch_0_4_1.default or false);
    crossbeam_utils_0_3_2.default = (f.crossbeam_utils_0_3_2.default or false);
    crossbeam_utils_0_3_2.use_std =
      (f.crossbeam_utils_0_3_2.use_std or false) ||
      (crossbeam_epoch_0_4_1.use_std or false) ||
      (f.crossbeam_epoch_0_4_1.use_std or false);
    lazy_static_1_0_0.default = true;
    memoffset_0_2_1.default = true;
    scopeguard_0_3_3.default = (f.scopeguard_0_3_3.default or false);
  }) [ arrayvec_0_4_7_features cfg_if_0_1_2_features crossbeam_utils_0_3_2_features lazy_static_1_0_0_features memoffset_0_2_1_features scopeguard_0_3_3_features ];
  crossbeam_utils_0_2_2 = { features?(crossbeam_utils_0_2_2_features {}) }: crossbeam_utils_0_2_2_ {
    dependencies = mapFeatures features ([ cfg_if_0_1_2 ]);
    features = mkFeatures (features.crossbeam_utils_0_2_2 or {});
  };
  crossbeam_utils_0_2_2_features = f: updateFeatures f (rec {
    cfg_if_0_1_2.default = true;
    crossbeam_utils_0_2_2.default = (f.crossbeam_utils_0_2_2.default or true);
    crossbeam_utils_0_2_2.use_std =
      (f.crossbeam_utils_0_2_2.use_std or false) ||
      (f.crossbeam_utils_0_2_2.default or false) ||
      (crossbeam_utils_0_2_2.default or false);
  }) [ cfg_if_0_1_2_features ];
  crossbeam_utils_0_3_2 = { features?(crossbeam_utils_0_3_2_features {}) }: crossbeam_utils_0_3_2_ {
    dependencies = mapFeatures features ([ cfg_if_0_1_2 ]);
    features = mkFeatures (features.crossbeam_utils_0_3_2 or {});
  };
  crossbeam_utils_0_3_2_features = f: updateFeatures f (rec {
    cfg_if_0_1_2.default = true;
    crossbeam_utils_0_3_2.default = (f.crossbeam_utils_0_3_2.default or true);
    crossbeam_utils_0_3_2.use_std =
      (f.crossbeam_utils_0_3_2.use_std or false) ||
      (f.crossbeam_utils_0_3_2.default or false) ||
      (crossbeam_utils_0_3_2.default or false);
  }) [ cfg_if_0_1_2_features ];
  dbghelp_sys_0_2_0 = { features?(dbghelp_sys_0_2_0_features {}) }: dbghelp_sys_0_2_0_ {
    dependencies = mapFeatures features ([ winapi_0_2_8 ]);
    buildDependencies = mapFeatures features ([ winapi_build_0_1_1 ]);
  };
  dbghelp_sys_0_2_0_features = f: updateFeatures f (rec {
    dbghelp_sys_0_2_0.default = (f.dbghelp_sys_0_2_0.default or true);
    winapi_0_2_8.default = true;
    winapi_build_0_1_1.default = true;
  }) [ winapi_0_2_8_features winapi_build_0_1_1_features ];
  diesel_1_2_2 = { features?(diesel_1_2_2_features {}) }: diesel_1_2_2_ {
    dependencies = mapFeatures features ([ byteorder_1_2_2 diesel_derives_1_2_0 ]
      ++ (if features.diesel_1_2_2.bitflags or false then [ bitflags_1_0_3 ] else [])
      ++ (if features.diesel_1_2_2.chrono or false then [ chrono_0_4_2 ] else [])
      ++ (if features.diesel_1_2_2.pq-sys or false then [ pq_sys_0_4_4 ] else [])
      ++ (if features.diesel_1_2_2.r2d2 or false then [ r2d2_0_8_2 ] else []));
    features = mkFeatures (features.diesel_1_2_2 or {});
  };
  diesel_1_2_2_features = f: updateFeatures f (rec {
    bitflags_1_0_3.default = true;
    byteorder_1_2_2.default = true;
    chrono_0_4_2.default = true;
    diesel_1_2_2."128-column-tables" =
      (f.diesel_1_2_2."128-column-tables" or false) ||
      (f.diesel_1_2_2.x128-column-tables or false) ||
      (diesel_1_2_2.x128-column-tables or false);
    diesel_1_2_2."32-column-tables" =
      (f.diesel_1_2_2."32-column-tables" or false) ||
      (f.diesel_1_2_2."64-column-tables" or false) ||
      (diesel_1_2_2."64-column-tables" or false) ||
      (f.diesel_1_2_2.default or false) ||
      (diesel_1_2_2.default or false) ||
      (f.diesel_1_2_2.large-tables or false) ||
      (diesel_1_2_2.large-tables or false) ||
      (f.diesel_1_2_2.x32-column-tables or false) ||
      (diesel_1_2_2.x32-column-tables or false);
    diesel_1_2_2."64-column-tables" =
      (f.diesel_1_2_2."64-column-tables" or false) ||
      (f.diesel_1_2_2."128-column-tables" or false) ||
      (diesel_1_2_2."128-column-tables" or false) ||
      (f.diesel_1_2_2.huge-tables or false) ||
      (diesel_1_2_2.huge-tables or false) ||
      (f.diesel_1_2_2.x64-column-tables or false) ||
      (diesel_1_2_2.x64-column-tables or false);
    diesel_1_2_2.bigdecimal =
      (f.diesel_1_2_2.bigdecimal or false) ||
      (f.diesel_1_2_2.numeric or false) ||
      (diesel_1_2_2.numeric or false);
    diesel_1_2_2.bitflags =
      (f.diesel_1_2_2.bitflags or false) ||
      (f.diesel_1_2_2.postgres or false) ||
      (diesel_1_2_2.postgres or false);
    diesel_1_2_2.chrono =
      (f.diesel_1_2_2.chrono or false) ||
      (f.diesel_1_2_2.extras or false) ||
      (diesel_1_2_2.extras or false);
    diesel_1_2_2.clippy =
      (f.diesel_1_2_2.clippy or false) ||
      (f.diesel_1_2_2.lint or false) ||
      (diesel_1_2_2.lint or false);
    diesel_1_2_2.default = (f.diesel_1_2_2.default or true);
    diesel_1_2_2.deprecated-time =
      (f.diesel_1_2_2.deprecated-time or false) ||
      (f.diesel_1_2_2.extras or false) ||
      (diesel_1_2_2.extras or false);
    diesel_1_2_2.ipnetwork =
      (f.diesel_1_2_2.ipnetwork or false) ||
      (f.diesel_1_2_2.network-address or false) ||
      (diesel_1_2_2.network-address or false);
    diesel_1_2_2.libc =
      (f.diesel_1_2_2.libc or false) ||
      (f.diesel_1_2_2.network-address or false) ||
      (diesel_1_2_2.network-address or false);
    diesel_1_2_2.libsqlite3-sys =
      (f.diesel_1_2_2.libsqlite3-sys or false) ||
      (f.diesel_1_2_2.sqlite or false) ||
      (diesel_1_2_2.sqlite or false);
    diesel_1_2_2.mysqlclient-sys =
      (f.diesel_1_2_2.mysqlclient-sys or false) ||
      (f.diesel_1_2_2.mysql or false) ||
      (diesel_1_2_2.mysql or false);
    diesel_1_2_2.network-address =
      (f.diesel_1_2_2.network-address or false) ||
      (f.diesel_1_2_2.extras or false) ||
      (diesel_1_2_2.extras or false);
    diesel_1_2_2.num-bigint =
      (f.diesel_1_2_2.num-bigint or false) ||
      (f.diesel_1_2_2.numeric or false) ||
      (diesel_1_2_2.numeric or false);
    diesel_1_2_2.num-integer =
      (f.diesel_1_2_2.num-integer or false) ||
      (f.diesel_1_2_2.numeric or false) ||
      (diesel_1_2_2.numeric or false);
    diesel_1_2_2.num-traits =
      (f.diesel_1_2_2.num-traits or false) ||
      (f.diesel_1_2_2.numeric or false) ||
      (diesel_1_2_2.numeric or false);
    diesel_1_2_2.numeric =
      (f.diesel_1_2_2.numeric or false) ||
      (f.diesel_1_2_2.extras or false) ||
      (diesel_1_2_2.extras or false);
    diesel_1_2_2.pq-sys =
      (f.diesel_1_2_2.pq-sys or false) ||
      (f.diesel_1_2_2.postgres or false) ||
      (diesel_1_2_2.postgres or false);
    diesel_1_2_2.r2d2 =
      (f.diesel_1_2_2.r2d2 or false) ||
      (f.diesel_1_2_2.extras or false) ||
      (diesel_1_2_2.extras or false);
    diesel_1_2_2.serde_json =
      (f.diesel_1_2_2.serde_json or false) ||
      (f.diesel_1_2_2.extras or false) ||
      (diesel_1_2_2.extras or false);
    diesel_1_2_2.time =
      (f.diesel_1_2_2.time or false) ||
      (f.diesel_1_2_2.deprecated-time or false) ||
      (diesel_1_2_2.deprecated-time or false);
    diesel_1_2_2.url =
      (f.diesel_1_2_2.url or false) ||
      (f.diesel_1_2_2.mysql or false) ||
      (diesel_1_2_2.mysql or false);
    diesel_1_2_2.uuid =
      (f.diesel_1_2_2.uuid or false) ||
      (f.diesel_1_2_2.extras or false) ||
      (diesel_1_2_2.extras or false);
    diesel_1_2_2.with-deprecated =
      (f.diesel_1_2_2.with-deprecated or false) ||
      (f.diesel_1_2_2.default or false) ||
      (diesel_1_2_2.default or false);
    diesel_derives_1_2_0.default = true;
    diesel_derives_1_2_0.mysql =
      (f.diesel_derives_1_2_0.mysql or false) ||
      (diesel_1_2_2.mysql or false) ||
      (f.diesel_1_2_2.mysql or false);
    diesel_derives_1_2_0.nightly =
      (f.diesel_derives_1_2_0.nightly or false) ||
      (diesel_1_2_2.unstable or false) ||
      (f.diesel_1_2_2.unstable or false);
    diesel_derives_1_2_0.postgres =
      (f.diesel_derives_1_2_0.postgres or false) ||
      (diesel_1_2_2.postgres or false) ||
      (f.diesel_1_2_2.postgres or false);
    diesel_derives_1_2_0.sqlite =
      (f.diesel_derives_1_2_0.sqlite or false) ||
      (diesel_1_2_2.sqlite or false) ||
      (f.diesel_1_2_2.sqlite or false);
    pq_sys_0_4_4.default = true;
    r2d2_0_8_2.default = true;
  }) [ bitflags_1_0_3_features byteorder_1_2_2_features chrono_0_4_2_features diesel_derives_1_2_0_features pq_sys_0_4_4_features r2d2_0_8_2_features ];
  diesel_derives_1_2_0 = { features?(diesel_derives_1_2_0_features {}) }: diesel_derives_1_2_0_ {
    dependencies = mapFeatures features ([ proc_macro2_0_2_3 quote_0_4_2 syn_0_12_15 ]);
    features = mkFeatures (features.diesel_derives_1_2_0 or {});
  };
  diesel_derives_1_2_0_features = f: updateFeatures f (rec {
    diesel_derives_1_2_0.clippy =
      (f.diesel_derives_1_2_0.clippy or false) ||
      (f.diesel_derives_1_2_0.lint or false) ||
      (diesel_derives_1_2_0.lint or false);
    diesel_derives_1_2_0.default = (f.diesel_derives_1_2_0.default or true);
    proc_macro2_0_2_3.default = true;
    proc_macro2_0_2_3.nightly =
      (f.proc_macro2_0_2_3.nightly or false) ||
      (diesel_derives_1_2_0.nightly or false) ||
      (f.diesel_derives_1_2_0.nightly or false);
    quote_0_4_2.default = true;
    syn_0_12_15.default = true;
    syn_0_12_15.fold = true;
    syn_0_12_15.full = true;
  }) [ proc_macro2_0_2_3_features quote_0_4_2_features syn_0_12_15_features ];
  dtoa_0_4_2 = { features?(dtoa_0_4_2_features {}) }: dtoa_0_4_2_ {};
  dtoa_0_4_2_features = f: updateFeatures f (rec {
    dtoa_0_4_2.default = (f.dtoa_0_4_2.default or true);
  }) [];
  encoding_0_2_33 = { features?(encoding_0_2_33_features {}) }: encoding_0_2_33_ {
    dependencies = mapFeatures features ([ encoding_index_japanese_1_20141219_5 encoding_index_korean_1_20141219_5 encoding_index_simpchinese_1_20141219_5 encoding_index_singlebyte_1_20141219_5 encoding_index_tradchinese_1_20141219_5 ]);
  };
  encoding_0_2_33_features = f: updateFeatures f (rec {
    encoding_0_2_33.default = (f.encoding_0_2_33.default or true);
    encoding_index_japanese_1_20141219_5.default = true;
    encoding_index_korean_1_20141219_5.default = true;
    encoding_index_simpchinese_1_20141219_5.default = true;
    encoding_index_singlebyte_1_20141219_5.default = true;
    encoding_index_tradchinese_1_20141219_5.default = true;
  }) [ encoding_index_japanese_1_20141219_5_features encoding_index_korean_1_20141219_5_features encoding_index_simpchinese_1_20141219_5_features encoding_index_singlebyte_1_20141219_5_features encoding_index_tradchinese_1_20141219_5_features ];
  encoding_index_japanese_1_20141219_5 = { features?(encoding_index_japanese_1_20141219_5_features {}) }: encoding_index_japanese_1_20141219_5_ {
    dependencies = mapFeatures features ([ encoding_index_tests_0_1_4 ]);
  };
  encoding_index_japanese_1_20141219_5_features = f: updateFeatures f (rec {
    encoding_index_japanese_1_20141219_5.default = (f.encoding_index_japanese_1_20141219_5.default or true);
    encoding_index_tests_0_1_4.default = true;
  }) [ encoding_index_tests_0_1_4_features ];
  encoding_index_korean_1_20141219_5 = { features?(encoding_index_korean_1_20141219_5_features {}) }: encoding_index_korean_1_20141219_5_ {
    dependencies = mapFeatures features ([ encoding_index_tests_0_1_4 ]);
  };
  encoding_index_korean_1_20141219_5_features = f: updateFeatures f (rec {
    encoding_index_korean_1_20141219_5.default = (f.encoding_index_korean_1_20141219_5.default or true);
    encoding_index_tests_0_1_4.default = true;
  }) [ encoding_index_tests_0_1_4_features ];
  encoding_index_simpchinese_1_20141219_5 = { features?(encoding_index_simpchinese_1_20141219_5_features {}) }: encoding_index_simpchinese_1_20141219_5_ {
    dependencies = mapFeatures features ([ encoding_index_tests_0_1_4 ]);
  };
  encoding_index_simpchinese_1_20141219_5_features = f: updateFeatures f (rec {
    encoding_index_simpchinese_1_20141219_5.default = (f.encoding_index_simpchinese_1_20141219_5.default or true);
    encoding_index_tests_0_1_4.default = true;
  }) [ encoding_index_tests_0_1_4_features ];
  encoding_index_singlebyte_1_20141219_5 = { features?(encoding_index_singlebyte_1_20141219_5_features {}) }: encoding_index_singlebyte_1_20141219_5_ {
    dependencies = mapFeatures features ([ encoding_index_tests_0_1_4 ]);
  };
  encoding_index_singlebyte_1_20141219_5_features = f: updateFeatures f (rec {
    encoding_index_singlebyte_1_20141219_5.default = (f.encoding_index_singlebyte_1_20141219_5.default or true);
    encoding_index_tests_0_1_4.default = true;
  }) [ encoding_index_tests_0_1_4_features ];
  encoding_index_tradchinese_1_20141219_5 = { features?(encoding_index_tradchinese_1_20141219_5_features {}) }: encoding_index_tradchinese_1_20141219_5_ {
    dependencies = mapFeatures features ([ encoding_index_tests_0_1_4 ]);
  };
  encoding_index_tradchinese_1_20141219_5_features = f: updateFeatures f (rec {
    encoding_index_tests_0_1_4.default = true;
    encoding_index_tradchinese_1_20141219_5.default = (f.encoding_index_tradchinese_1_20141219_5.default or true);
  }) [ encoding_index_tests_0_1_4_features ];
  encoding_index_tests_0_1_4 = { features?(encoding_index_tests_0_1_4_features {}) }: encoding_index_tests_0_1_4_ {};
  encoding_index_tests_0_1_4_features = f: updateFeatures f (rec {
    encoding_index_tests_0_1_4.default = (f.encoding_index_tests_0_1_4.default or true);
  }) [];
  encoding_rs_0_7_2 = { features?(encoding_rs_0_7_2_features {}) }: encoding_rs_0_7_2_ {
    dependencies = mapFeatures features ([ cfg_if_0_1_2 ]);
    features = mkFeatures (features.encoding_rs_0_7_2 or {});
  };
  encoding_rs_0_7_2_features = f: updateFeatures f (rec {
    cfg_if_0_1_2.default = true;
    encoding_rs_0_7_2.default = (f.encoding_rs_0_7_2.default or true);
    encoding_rs_0_7_2.simd =
      (f.encoding_rs_0_7_2.simd or false) ||
      (f.encoding_rs_0_7_2.simd-accel or false) ||
      (encoding_rs_0_7_2.simd-accel or false);
  }) [ cfg_if_0_1_2_features ];
  entities_1_0_1 = { features?(entities_1_0_1_features {}) }: entities_1_0_1_ {};
  entities_1_0_1_features = f: updateFeatures f (rec {
    entities_1_0_1.default = (f.entities_1_0_1.default or true);
  }) [];
  env_logger_0_5_9 = { features?(env_logger_0_5_9_features {}) }: env_logger_0_5_9_ {
    dependencies = mapFeatures features ([ atty_0_2_10 humantime_1_1_1 log_0_4_1 termcolor_0_3_6 ]
      ++ (if features.env_logger_0_5_9.regex or false then [ regex_0_2_11 ] else []));
    features = mkFeatures (features.env_logger_0_5_9 or {});
  };
  env_logger_0_5_9_features = f: updateFeatures f (rec {
    atty_0_2_10.default = true;
    env_logger_0_5_9.default = (f.env_logger_0_5_9.default or true);
    env_logger_0_5_9.regex =
      (f.env_logger_0_5_9.regex or false) ||
      (f.env_logger_0_5_9.default or false) ||
      (env_logger_0_5_9.default or false);
    humantime_1_1_1.default = true;
    log_0_4_1.default = true;
    log_0_4_1.std = true;
    regex_0_2_11.default = true;
    termcolor_0_3_6.default = true;
  }) [ atty_0_2_10_features humantime_1_1_1_features log_0_4_1_features regex_0_2_11_features termcolor_0_3_6_features ];
  error_chain_0_1_12 = { features?(error_chain_0_1_12_features {}) }: error_chain_0_1_12_ {
    dependencies = mapFeatures features ([ backtrace_0_2_3 ]);
  };
  error_chain_0_1_12_features = f: updateFeatures f (rec {
    backtrace_0_2_3.default = true;
    error_chain_0_1_12.default = (f.error_chain_0_1_12.default or true);
  }) [ backtrace_0_2_3_features ];
  error_chain_0_8_1 = { features?(error_chain_0_8_1_features {}) }: error_chain_0_8_1_ {
    dependencies = mapFeatures features ([ ]
      ++ (if features.error_chain_0_8_1.backtrace or false then [ backtrace_0_3_6 ] else []));
    features = mkFeatures (features.error_chain_0_8_1 or {});
  };
  error_chain_0_8_1_features = f: updateFeatures f (rec {
    backtrace_0_3_6.default = true;
    error_chain_0_8_1.backtrace =
      (f.error_chain_0_8_1.backtrace or false) ||
      (f.error_chain_0_8_1.default or false) ||
      (error_chain_0_8_1.default or false);
    error_chain_0_8_1.default = (f.error_chain_0_8_1.default or true);
    error_chain_0_8_1.example_generated =
      (f.error_chain_0_8_1.example_generated or false) ||
      (f.error_chain_0_8_1.default or false) ||
      (error_chain_0_8_1.default or false);
  }) [ backtrace_0_3_6_features ];
  error_chain_0_11_0 = { features?(error_chain_0_11_0_features {}) }: error_chain_0_11_0_ {
    dependencies = mapFeatures features ([ ]
      ++ (if features.error_chain_0_11_0.backtrace or false then [ backtrace_0_3_6 ] else []));
    features = mkFeatures (features.error_chain_0_11_0 or {});
  };
  error_chain_0_11_0_features = f: updateFeatures f (rec {
    backtrace_0_3_6.default = true;
    error_chain_0_11_0.backtrace =
      (f.error_chain_0_11_0.backtrace or false) ||
      (f.error_chain_0_11_0.default or false) ||
      (error_chain_0_11_0.default or false);
    error_chain_0_11_0.default = (f.error_chain_0_11_0.default or true);
    error_chain_0_11_0.example_generated =
      (f.error_chain_0_11_0.example_generated or false) ||
      (f.error_chain_0_11_0.default or false) ||
      (error_chain_0_11_0.default or false);
  }) [ backtrace_0_3_6_features ];
  failure_0_1_1 = { features?(failure_0_1_1_features {}) }: failure_0_1_1_ {
    dependencies = mapFeatures features ([ ]
      ++ (if features.failure_0_1_1.backtrace or false then [ backtrace_0_3_6 ] else [])
      ++ (if features.failure_0_1_1.failure_derive or false then [ failure_derive_0_1_1 ] else []));
    features = mkFeatures (features.failure_0_1_1 or {});
  };
  failure_0_1_1_features = f: updateFeatures f (rec {
    backtrace_0_3_6.default = true;
    failure_0_1_1.backtrace =
      (f.failure_0_1_1.backtrace or false) ||
      (f.failure_0_1_1.std or false) ||
      (failure_0_1_1.std or false);
    failure_0_1_1.default = (f.failure_0_1_1.default or true);
    failure_0_1_1.derive =
      (f.failure_0_1_1.derive or false) ||
      (f.failure_0_1_1.default or false) ||
      (failure_0_1_1.default or false);
    failure_0_1_1.failure_derive =
      (f.failure_0_1_1.failure_derive or false) ||
      (f.failure_0_1_1.derive or false) ||
      (failure_0_1_1.derive or false);
    failure_0_1_1.std =
      (f.failure_0_1_1.std or false) ||
      (f.failure_0_1_1.default or false) ||
      (failure_0_1_1.default or false);
    failure_derive_0_1_1.default = true;
  }) [ backtrace_0_3_6_features failure_derive_0_1_1_features ];
  failure_derive_0_1_1 = { features?(failure_derive_0_1_1_features {}) }: failure_derive_0_1_1_ {
    dependencies = mapFeatures features ([ quote_0_3_15 syn_0_11_11 synstructure_0_6_1 ]);
    features = mkFeatures (features.failure_derive_0_1_1 or {});
  };
  failure_derive_0_1_1_features = f: updateFeatures f (rec {
    failure_derive_0_1_1.default = (f.failure_derive_0_1_1.default or true);
    failure_derive_0_1_1.std =
      (f.failure_derive_0_1_1.std or false) ||
      (f.failure_derive_0_1_1.default or false) ||
      (failure_derive_0_1_1.default or false);
    quote_0_3_15.default = true;
    syn_0_11_11.default = true;
    synstructure_0_6_1.default = true;
  }) [ quote_0_3_15_features syn_0_11_11_features synstructure_0_6_1_features ];
  flate2_1_0_1 = { features?(flate2_1_0_1_features {}) }: flate2_1_0_1_ {
    dependencies = mapFeatures features ([ libc_0_2_40 ]
      ++ (if features.flate2_1_0_1.miniz-sys or false then [ miniz_sys_0_1_10 ] else []));
    features = mkFeatures (features.flate2_1_0_1 or {});
  };
  flate2_1_0_1_features = f: updateFeatures f (rec {
    flate2_1_0_1.default = (f.flate2_1_0_1.default or true);
    flate2_1_0_1.futures =
      (f.flate2_1_0_1.futures or false) ||
      (f.flate2_1_0_1.tokio or false) ||
      (flate2_1_0_1.tokio or false);
    flate2_1_0_1.libz-sys =
      (f.flate2_1_0_1.libz-sys or false) ||
      (f.flate2_1_0_1.zlib or false) ||
      (flate2_1_0_1.zlib or false);
    flate2_1_0_1.miniz-sys =
      (f.flate2_1_0_1.miniz-sys or false) ||
      (f.flate2_1_0_1.default or false) ||
      (flate2_1_0_1.default or false);
    flate2_1_0_1.miniz_oxide_c_api =
      (f.flate2_1_0_1.miniz_oxide_c_api or false) ||
      (f.flate2_1_0_1.rust_backend or false) ||
      (flate2_1_0_1.rust_backend or false);
    flate2_1_0_1.tokio-io =
      (f.flate2_1_0_1.tokio-io or false) ||
      (f.flate2_1_0_1.tokio or false) ||
      (flate2_1_0_1.tokio or false);
    libc_0_2_40.default = true;
    miniz_sys_0_1_10.default = true;
  }) [ libc_0_2_40_features miniz_sys_0_1_10_features ];
  fnv_1_0_6 = { features?(fnv_1_0_6_features {}) }: fnv_1_0_6_ {};
  fnv_1_0_6_features = f: updateFeatures f (rec {
    fnv_1_0_6.default = (f.fnv_1_0_6.default or true);
  }) [];
  foreign_types_0_3_2 = { features?(foreign_types_0_3_2_features {}) }: foreign_types_0_3_2_ {
    dependencies = mapFeatures features ([ foreign_types_shared_0_1_1 ]);
  };
  foreign_types_0_3_2_features = f: updateFeatures f (rec {
    foreign_types_0_3_2.default = (f.foreign_types_0_3_2.default or true);
    foreign_types_shared_0_1_1.default = true;
  }) [ foreign_types_shared_0_1_1_features ];
  foreign_types_shared_0_1_1 = { features?(foreign_types_shared_0_1_1_features {}) }: foreign_types_shared_0_1_1_ {};
  foreign_types_shared_0_1_1_features = f: updateFeatures f (rec {
    foreign_types_shared_0_1_1.default = (f.foreign_types_shared_0_1_1.default or true);
  }) [];
  fuchsia_zircon_0_3_3 = { features?(fuchsia_zircon_0_3_3_features {}) }: fuchsia_zircon_0_3_3_ {
    dependencies = mapFeatures features ([ bitflags_1_0_3 fuchsia_zircon_sys_0_3_3 ]);
  };
  fuchsia_zircon_0_3_3_features = f: updateFeatures f (rec {
    bitflags_1_0_3.default = true;
    fuchsia_zircon_0_3_3.default = (f.fuchsia_zircon_0_3_3.default or true);
    fuchsia_zircon_sys_0_3_3.default = true;
  }) [ bitflags_1_0_3_features fuchsia_zircon_sys_0_3_3_features ];
  fuchsia_zircon_sys_0_3_3 = { features?(fuchsia_zircon_sys_0_3_3_features {}) }: fuchsia_zircon_sys_0_3_3_ {};
  fuchsia_zircon_sys_0_3_3_features = f: updateFeatures f (rec {
    fuchsia_zircon_sys_0_3_3.default = (f.fuchsia_zircon_sys_0_3_3.default or true);
  }) [];
  futures_0_1_21 = { features?(futures_0_1_21_features {}) }: futures_0_1_21_ {
    features = mkFeatures (features.futures_0_1_21 or {});
  };
  futures_0_1_21_features = f: updateFeatures f (rec {
    futures_0_1_21.default = (f.futures_0_1_21.default or true);
    futures_0_1_21.use_std =
      (f.futures_0_1_21.use_std or false) ||
      (f.futures_0_1_21.default or false) ||
      (futures_0_1_21.default or false);
    futures_0_1_21.with-deprecated =
      (f.futures_0_1_21.with-deprecated or false) ||
      (f.futures_0_1_21.default or false) ||
      (futures_0_1_21.default or false);
  }) [];
  futures_cpupool_0_1_8 = { features?(futures_cpupool_0_1_8_features {}) }: futures_cpupool_0_1_8_ {
    dependencies = mapFeatures features ([ futures_0_1_21 num_cpus_1_8_0 ]);
    features = mkFeatures (features.futures_cpupool_0_1_8 or {});
  };
  futures_cpupool_0_1_8_features = f: updateFeatures f (rec {
    futures_0_1_21.default = (f.futures_0_1_21.default or false);
    futures_0_1_21.use_std = true;
    futures_0_1_21.with-deprecated =
      (f.futures_0_1_21.with-deprecated or false) ||
      (futures_cpupool_0_1_8.with-deprecated or false) ||
      (f.futures_cpupool_0_1_8.with-deprecated or false);
    futures_cpupool_0_1_8.default = (f.futures_cpupool_0_1_8.default or true);
    futures_cpupool_0_1_8.with-deprecated =
      (f.futures_cpupool_0_1_8.with-deprecated or false) ||
      (f.futures_cpupool_0_1_8.default or false) ||
      (futures_cpupool_0_1_8.default or false);
    num_cpus_1_8_0.default = true;
  }) [ futures_0_1_21_features num_cpus_1_8_0_features ];
  gcc_0_3_54 = { features?(gcc_0_3_54_features {}) }: gcc_0_3_54_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.gcc_0_3_54 or {});
  };
  gcc_0_3_54_features = f: updateFeatures f (rec {
    gcc_0_3_54.default = (f.gcc_0_3_54.default or true);
    gcc_0_3_54.rayon =
      (f.gcc_0_3_54.rayon or false) ||
      (f.gcc_0_3_54.parallel or false) ||
      (gcc_0_3_54.parallel or false);
  }) [];
  getopts_0_2_17 = { features?(getopts_0_2_17_features {}) }: getopts_0_2_17_ {};
  getopts_0_2_17_features = f: updateFeatures f (rec {
    getopts_0_2_17.default = (f.getopts_0_2_17.default or true);
  }) [];
  glob_0_2_11 = { features?(glob_0_2_11_features {}) }: glob_0_2_11_ {};
  glob_0_2_11_features = f: updateFeatures f (rec {
    glob_0_2_11.default = (f.glob_0_2_11.default or true);
  }) [];
  h2_0_1_6 = { features?(h2_0_1_6_features {}) }: h2_0_1_6_ {
    dependencies = mapFeatures features ([ byteorder_1_2_2 bytes_0_4_7 fnv_1_0_6 futures_0_1_21 http_0_1_5 indexmap_1_0_1 log_0_4_1 slab_0_4_0 string_0_1_0 tokio_io_0_1_6 ]);
    features = mkFeatures (features.h2_0_1_6 or {});
  };
  h2_0_1_6_features = f: updateFeatures f (rec {
    byteorder_1_2_2.default = true;
    bytes_0_4_7.default = true;
    fnv_1_0_6.default = true;
    futures_0_1_21.default = true;
    h2_0_1_6.default = (f.h2_0_1_6.default or true);
    http_0_1_5.default = true;
    indexmap_1_0_1.default = true;
    log_0_4_1.default = true;
    slab_0_4_0.default = true;
    string_0_1_0.default = true;
    tokio_io_0_1_6.default = true;
  }) [ byteorder_1_2_2_features bytes_0_4_7_features fnv_1_0_6_features futures_0_1_21_features http_0_1_5_features indexmap_1_0_1_features log_0_4_1_features slab_0_4_0_features string_0_1_0_features tokio_io_0_1_6_features ];
  hostname_0_1_4 = { features?(hostname_0_1_4_features {}) }: hostname_0_1_4_ {
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ winutil_0_1_1 ]) else []);
    features = mkFeatures (features.hostname_0_1_4 or {});
  };
  hostname_0_1_4_features = f: updateFeatures f (rec {
    hostname_0_1_4.default = (f.hostname_0_1_4.default or true);
    libc_0_2_40.default = true;
    winutil_0_1_1.default = true;
  }) [ libc_0_2_40_features winutil_0_1_1_features ];
  http_0_1_5 = { features?(http_0_1_5_features {}) }: http_0_1_5_ {
    dependencies = mapFeatures features ([ bytes_0_4_7 fnv_1_0_6 ]);
  };
  http_0_1_5_features = f: updateFeatures f (rec {
    bytes_0_4_7.default = true;
    fnv_1_0_6.default = true;
    http_0_1_5.default = (f.http_0_1_5.default or true);
  }) [ bytes_0_4_7_features fnv_1_0_6_features ];
  http_range_0_1_1 = { features?(http_range_0_1_1_features {}) }: http_range_0_1_1_ {};
  http_range_0_1_1_features = f: updateFeatures f (rec {
    http_range_0_1_1.default = (f.http_range_0_1_1.default or true);
  }) [];
  httparse_1_2_4 = { features?(httparse_1_2_4_features {}) }: httparse_1_2_4_ {
    features = mkFeatures (features.httparse_1_2_4 or {});
  };
  httparse_1_2_4_features = f: updateFeatures f (rec {
    httparse_1_2_4.default = (f.httparse_1_2_4.default or true);
    httparse_1_2_4.std =
      (f.httparse_1_2_4.std or false) ||
      (f.httparse_1_2_4.default or false) ||
      (httparse_1_2_4.default or false);
  }) [];
  humansize_1_1_0 = { features?(humansize_1_1_0_features {}) }: humansize_1_1_0_ {};
  humansize_1_1_0_features = f: updateFeatures f (rec {
    humansize_1_1_0.default = (f.humansize_1_1_0.default or true);
  }) [];
  humantime_1_1_1 = { features?(humantime_1_1_1_features {}) }: humantime_1_1_1_ {
    dependencies = mapFeatures features ([ quick_error_1_2_1 ]);
  };
  humantime_1_1_1_features = f: updateFeatures f (rec {
    humantime_1_1_1.default = (f.humantime_1_1_1.default or true);
    quick_error_1_2_1.default = true;
  }) [ quick_error_1_2_1_features ];
  hyper_0_11_25 = { features?(hyper_0_11_25_features {}) }: hyper_0_11_25_ {
    dependencies = mapFeatures features ([ base64_0_9_1 bytes_0_4_7 futures_0_1_21 futures_cpupool_0_1_8 httparse_1_2_4 iovec_0_1_2 language_tags_0_2_2 log_0_4_1 mime_0_3_5 percent_encoding_1_0_1 relay_0_1_1 time_0_1_39 tokio_core_0_1_17 tokio_io_0_1_6 tokio_service_0_1_0 unicase_2_1_0 ]
      ++ (if features.hyper_0_11_25.tokio-proto or false then [ tokio_proto_0_1_1 ] else []));
    features = mkFeatures (features.hyper_0_11_25 or {});
  };
  hyper_0_11_25_features = f: updateFeatures f (rec {
    base64_0_9_1.default = true;
    bytes_0_4_7.default = true;
    futures_0_1_21.default = true;
    futures_cpupool_0_1_8.default = true;
    httparse_1_2_4.default = true;
    hyper_0_11_25.default = (f.hyper_0_11_25.default or true);
    hyper_0_11_25.http =
      (f.hyper_0_11_25.http or false) ||
      (f.hyper_0_11_25.compat or false) ||
      (hyper_0_11_25.compat or false);
    hyper_0_11_25.server-proto =
      (f.hyper_0_11_25.server-proto or false) ||
      (f.hyper_0_11_25.default or false) ||
      (hyper_0_11_25.default or false);
    hyper_0_11_25.tokio-proto =
      (f.hyper_0_11_25.tokio-proto or false) ||
      (f.hyper_0_11_25.server-proto or false) ||
      (hyper_0_11_25.server-proto or false);
    iovec_0_1_2.default = true;
    language_tags_0_2_2.default = true;
    log_0_4_1.default = true;
    mime_0_3_5.default = true;
    percent_encoding_1_0_1.default = true;
    relay_0_1_1.default = true;
    time_0_1_39.default = true;
    tokio_core_0_1_17.default = true;
    tokio_io_0_1_6.default = true;
    tokio_proto_0_1_1.default = true;
    tokio_service_0_1_0.default = true;
    unicase_2_1_0.default = true;
  }) [ base64_0_9_1_features bytes_0_4_7_features futures_0_1_21_features futures_cpupool_0_1_8_features httparse_1_2_4_features iovec_0_1_2_features language_tags_0_2_2_features log_0_4_1_features mime_0_3_5_features percent_encoding_1_0_1_features relay_0_1_1_features time_0_1_39_features tokio_core_0_1_17_features tokio_io_0_1_6_features tokio_proto_0_1_1_features tokio_service_0_1_0_features unicase_2_1_0_features ];
  hyper_tls_0_1_3 = { features?(hyper_tls_0_1_3_features {}) }: hyper_tls_0_1_3_ {
    dependencies = mapFeatures features ([ futures_0_1_21 hyper_0_11_25 native_tls_0_1_5 tokio_core_0_1_17 tokio_io_0_1_6 tokio_service_0_1_0 tokio_tls_0_1_4 ]);
  };
  hyper_tls_0_1_3_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    hyper_0_11_25.default = true;
    hyper_tls_0_1_3.default = (f.hyper_tls_0_1_3.default or true);
    native_tls_0_1_5.default = true;
    tokio_core_0_1_17.default = true;
    tokio_io_0_1_6.default = true;
    tokio_service_0_1_0.default = true;
    tokio_tls_0_1_4.default = true;
  }) [ futures_0_1_21_features hyper_0_11_25_features native_tls_0_1_5_features tokio_core_0_1_17_features tokio_io_0_1_6_features tokio_service_0_1_0_features tokio_tls_0_1_4_features ];
  idna_0_1_4 = { features?(idna_0_1_4_features {}) }: idna_0_1_4_ {
    dependencies = mapFeatures features ([ matches_0_1_6 unicode_bidi_0_3_4 unicode_normalization_0_1_5 ]);
  };
  idna_0_1_4_features = f: updateFeatures f (rec {
    idna_0_1_4.default = (f.idna_0_1_4.default or true);
    matches_0_1_6.default = true;
    unicode_bidi_0_3_4.default = true;
    unicode_normalization_0_1_5.default = true;
  }) [ matches_0_1_6_features unicode_bidi_0_3_4_features unicode_normalization_0_1_5_features ];
  indexmap_1_0_1 = { features?(indexmap_1_0_1_features {}) }: indexmap_1_0_1_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.indexmap_1_0_1 or {});
  };
  indexmap_1_0_1_features = f: updateFeatures f (rec {
    indexmap_1_0_1.default = (f.indexmap_1_0_1.default or true);
    indexmap_1_0_1.serde =
      (f.indexmap_1_0_1.serde or false) ||
      (f.indexmap_1_0_1.serde-1 or false) ||
      (indexmap_1_0_1.serde-1 or false);
  }) [];
  iovec_0_1_2 = { features?(iovec_0_1_2_features {}) }: iovec_0_1_2_ {
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ winapi_0_2_8 ]) else []);
  };
  iovec_0_1_2_features = f: updateFeatures f (rec {
    iovec_0_1_2.default = (f.iovec_0_1_2.default or true);
    libc_0_2_40.default = true;
    winapi_0_2_8.default = true;
  }) [ libc_0_2_40_features winapi_0_2_8_features ];
  ipconfig_0_1_6 = { features?(ipconfig_0_1_6_features {}) }: ipconfig_0_1_6_ {
    dependencies = (if kernel == "windows" then mapFeatures features ([ error_chain_0_8_1 socket2_0_3_5 widestring_0_2_2 winapi_0_3_4 winreg_0_5_0 ]) else []);
  };
  ipconfig_0_1_6_features = f: updateFeatures f (rec {
    error_chain_0_8_1.default = true;
    ipconfig_0_1_6.default = (f.ipconfig_0_1_6.default or true);
    socket2_0_3_5.default = true;
    widestring_0_2_2.default = true;
    winapi_0_3_4.default = true;
    winreg_0_5_0.default = true;
  }) [ error_chain_0_8_1_features socket2_0_3_5_features widestring_0_2_2_features winapi_0_3_4_features winreg_0_5_0_features ];
  itoa_0_3_4 = { features?(itoa_0_3_4_features {}) }: itoa_0_3_4_ {
    features = mkFeatures (features.itoa_0_3_4 or {});
  };
  itoa_0_3_4_features = f: updateFeatures f (rec {
    itoa_0_3_4.default = (f.itoa_0_3_4.default or true);
  }) [];
  itoa_0_4_1 = { features?(itoa_0_4_1_features {}) }: itoa_0_4_1_ {
    features = mkFeatures (features.itoa_0_4_1 or {});
  };
  itoa_0_4_1_features = f: updateFeatures f (rec {
    itoa_0_4_1.default = (f.itoa_0_4_1.default or true);
    itoa_0_4_1.std =
      (f.itoa_0_4_1.std or false) ||
      (f.itoa_0_4_1.default or false) ||
      (itoa_0_4_1.default or false);
  }) [];
  kernel32_sys_0_2_2 = { features?(kernel32_sys_0_2_2_features {}) }: kernel32_sys_0_2_2_ {
    dependencies = mapFeatures features ([ winapi_0_2_8 ]);
    buildDependencies = mapFeatures features ([ winapi_build_0_1_1 ]);
  };
  kernel32_sys_0_2_2_features = f: updateFeatures f (rec {
    kernel32_sys_0_2_2.default = (f.kernel32_sys_0_2_2.default or true);
    winapi_0_2_8.default = true;
    winapi_build_0_1_1.default = true;
  }) [ winapi_0_2_8_features winapi_build_0_1_1_features ];
  language_tags_0_2_2 = { features?(language_tags_0_2_2_features {}) }: language_tags_0_2_2_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.language_tags_0_2_2 or {});
  };
  language_tags_0_2_2_features = f: updateFeatures f (rec {
    language_tags_0_2_2.default = (f.language_tags_0_2_2.default or true);
    language_tags_0_2_2.heapsize =
      (f.language_tags_0_2_2.heapsize or false) ||
      (f.language_tags_0_2_2.heap_size or false) ||
      (language_tags_0_2_2.heap_size or false);
    language_tags_0_2_2.heapsize_plugin =
      (f.language_tags_0_2_2.heapsize_plugin or false) ||
      (f.language_tags_0_2_2.heap_size or false) ||
      (language_tags_0_2_2.heap_size or false);
  }) [];
  lazy_static_0_2_11 = { features?(lazy_static_0_2_11_features {}) }: lazy_static_0_2_11_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.lazy_static_0_2_11 or {});
  };
  lazy_static_0_2_11_features = f: updateFeatures f (rec {
    lazy_static_0_2_11.compiletest_rs =
      (f.lazy_static_0_2_11.compiletest_rs or false) ||
      (f.lazy_static_0_2_11.compiletest or false) ||
      (lazy_static_0_2_11.compiletest or false);
    lazy_static_0_2_11.default = (f.lazy_static_0_2_11.default or true);
    lazy_static_0_2_11.nightly =
      (f.lazy_static_0_2_11.nightly or false) ||
      (f.lazy_static_0_2_11.spin_no_std or false) ||
      (lazy_static_0_2_11.spin_no_std or false);
    lazy_static_0_2_11.spin =
      (f.lazy_static_0_2_11.spin or false) ||
      (f.lazy_static_0_2_11.spin_no_std or false) ||
      (lazy_static_0_2_11.spin_no_std or false);
  }) [];
  lazy_static_1_0_0 = { features?(lazy_static_1_0_0_features {}) }: lazy_static_1_0_0_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.lazy_static_1_0_0 or {});
  };
  lazy_static_1_0_0_features = f: updateFeatures f (rec {
    lazy_static_1_0_0.compiletest_rs =
      (f.lazy_static_1_0_0.compiletest_rs or false) ||
      (f.lazy_static_1_0_0.compiletest or false) ||
      (lazy_static_1_0_0.compiletest or false);
    lazy_static_1_0_0.default = (f.lazy_static_1_0_0.default or true);
    lazy_static_1_0_0.nightly =
      (f.lazy_static_1_0_0.nightly or false) ||
      (f.lazy_static_1_0_0.spin_no_std or false) ||
      (lazy_static_1_0_0.spin_no_std or false);
    lazy_static_1_0_0.spin =
      (f.lazy_static_1_0_0.spin or false) ||
      (f.lazy_static_1_0_0.spin_no_std or false) ||
      (lazy_static_1_0_0.spin_no_std or false);
  }) [];
  lazycell_0_6_0 = { features?(lazycell_0_6_0_features {}) }: lazycell_0_6_0_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.lazycell_0_6_0 or {});
  };
  lazycell_0_6_0_features = f: updateFeatures f (rec {
    lazycell_0_6_0.clippy =
      (f.lazycell_0_6_0.clippy or false) ||
      (f.lazycell_0_6_0.nightly-testing or false) ||
      (lazycell_0_6_0.nightly-testing or false);
    lazycell_0_6_0.default = (f.lazycell_0_6_0.default or true);
    lazycell_0_6_0.nightly =
      (f.lazycell_0_6_0.nightly or false) ||
      (f.lazycell_0_6_0.nightly-testing or false) ||
      (lazycell_0_6_0.nightly-testing or false);
  }) [];
  libc_0_2_40 = { features?(libc_0_2_40_features {}) }: libc_0_2_40_ {
    features = mkFeatures (features.libc_0_2_40 or {});
  };
  libc_0_2_40_features = f: updateFeatures f (rec {
    libc_0_2_40.default = (f.libc_0_2_40.default or true);
    libc_0_2_40.use_std =
      (f.libc_0_2_40.use_std or false) ||
      (f.libc_0_2_40.default or false) ||
      (libc_0_2_40.default or false);
  }) [];
  libflate_0_1_14 = { features?(libflate_0_1_14_features {}) }: libflate_0_1_14_ {
    dependencies = mapFeatures features ([ adler32_1_0_2 byteorder_1_2_2 crc_1_8_1 ]);
  };
  libflate_0_1_14_features = f: updateFeatures f (rec {
    adler32_1_0_2.default = true;
    byteorder_1_2_2.default = true;
    crc_1_8_1.default = true;
    libflate_0_1_14.default = (f.libflate_0_1_14.default or true);
  }) [ adler32_1_0_2_features byteorder_1_2_2_features crc_1_8_1_features ];
  linked_hash_map_0_4_2 = { features?(linked_hash_map_0_4_2_features {}) }: linked_hash_map_0_4_2_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.linked_hash_map_0_4_2 or {});
  };
  linked_hash_map_0_4_2_features = f: updateFeatures f (rec {
    linked_hash_map_0_4_2.default = (f.linked_hash_map_0_4_2.default or true);
    linked_hash_map_0_4_2.heapsize =
      (f.linked_hash_map_0_4_2.heapsize or false) ||
      (f.linked_hash_map_0_4_2.heapsize_impl or false) ||
      (linked_hash_map_0_4_2.heapsize_impl or false);
    linked_hash_map_0_4_2.serde =
      (f.linked_hash_map_0_4_2.serde or false) ||
      (f.linked_hash_map_0_4_2.serde_impl or false) ||
      (linked_hash_map_0_4_2.serde_impl or false);
    linked_hash_map_0_4_2.serde_test =
      (f.linked_hash_map_0_4_2.serde_test or false) ||
      (f.linked_hash_map_0_4_2.serde_impl or false) ||
      (linked_hash_map_0_4_2.serde_impl or false);
  }) [];
  log_0_3_9 = { features?(log_0_3_9_features {}) }: log_0_3_9_ {
    dependencies = mapFeatures features ([ log_0_4_1 ]);
    features = mkFeatures (features.log_0_3_9 or {});
  };
  log_0_3_9_features = f: updateFeatures f (rec {
    log_0_3_9.default = (f.log_0_3_9.default or true);
    log_0_3_9.use_std =
      (f.log_0_3_9.use_std or false) ||
      (f.log_0_3_9.default or false) ||
      (log_0_3_9.default or false);
    log_0_4_1.default = true;
    log_0_4_1.max_level_debug =
      (f.log_0_4_1.max_level_debug or false) ||
      (log_0_3_9.max_level_debug or false) ||
      (f.log_0_3_9.max_level_debug or false);
    log_0_4_1.max_level_error =
      (f.log_0_4_1.max_level_error or false) ||
      (log_0_3_9.max_level_error or false) ||
      (f.log_0_3_9.max_level_error or false);
    log_0_4_1.max_level_info =
      (f.log_0_4_1.max_level_info or false) ||
      (log_0_3_9.max_level_info or false) ||
      (f.log_0_3_9.max_level_info or false);
    log_0_4_1.max_level_off =
      (f.log_0_4_1.max_level_off or false) ||
      (log_0_3_9.max_level_off or false) ||
      (f.log_0_3_9.max_level_off or false);
    log_0_4_1.max_level_trace =
      (f.log_0_4_1.max_level_trace or false) ||
      (log_0_3_9.max_level_trace or false) ||
      (f.log_0_3_9.max_level_trace or false);
    log_0_4_1.max_level_warn =
      (f.log_0_4_1.max_level_warn or false) ||
      (log_0_3_9.max_level_warn or false) ||
      (f.log_0_3_9.max_level_warn or false);
    log_0_4_1.release_max_level_debug =
      (f.log_0_4_1.release_max_level_debug or false) ||
      (log_0_3_9.release_max_level_debug or false) ||
      (f.log_0_3_9.release_max_level_debug or false);
    log_0_4_1.release_max_level_error =
      (f.log_0_4_1.release_max_level_error or false) ||
      (log_0_3_9.release_max_level_error or false) ||
      (f.log_0_3_9.release_max_level_error or false);
    log_0_4_1.release_max_level_info =
      (f.log_0_4_1.release_max_level_info or false) ||
      (log_0_3_9.release_max_level_info or false) ||
      (f.log_0_3_9.release_max_level_info or false);
    log_0_4_1.release_max_level_off =
      (f.log_0_4_1.release_max_level_off or false) ||
      (log_0_3_9.release_max_level_off or false) ||
      (f.log_0_3_9.release_max_level_off or false);
    log_0_4_1.release_max_level_trace =
      (f.log_0_4_1.release_max_level_trace or false) ||
      (log_0_3_9.release_max_level_trace or false) ||
      (f.log_0_3_9.release_max_level_trace or false);
    log_0_4_1.release_max_level_warn =
      (f.log_0_4_1.release_max_level_warn or false) ||
      (log_0_3_9.release_max_level_warn or false) ||
      (f.log_0_3_9.release_max_level_warn or false);
    log_0_4_1.std =
      (f.log_0_4_1.std or false) ||
      (log_0_3_9.use_std or false) ||
      (f.log_0_3_9.use_std or false);
  }) [ log_0_4_1_features ];
  log_0_4_1 = { features?(log_0_4_1_features {}) }: log_0_4_1_ {
    dependencies = mapFeatures features ([ cfg_if_0_1_2 ]);
    features = mkFeatures (features.log_0_4_1 or {});
  };
  log_0_4_1_features = f: updateFeatures f (rec {
    cfg_if_0_1_2.default = true;
    log_0_4_1.default = (f.log_0_4_1.default or true);
  }) [ cfg_if_0_1_2_features ];
  lru_cache_0_1_1 = { features?(lru_cache_0_1_1_features {}) }: lru_cache_0_1_1_ {
    dependencies = mapFeatures features ([ linked_hash_map_0_4_2 ]);
    features = mkFeatures (features.lru_cache_0_1_1 or {});
  };
  lru_cache_0_1_1_features = f: updateFeatures f (rec {
    linked_hash_map_0_4_2.default = true;
    linked_hash_map_0_4_2.heapsize_impl =
      (f.linked_hash_map_0_4_2.heapsize_impl or false) ||
      (lru_cache_0_1_1.heapsize_impl or false) ||
      (f.lru_cache_0_1_1.heapsize_impl or false);
    lru_cache_0_1_1.default = (f.lru_cache_0_1_1.default or true);
    lru_cache_0_1_1.heapsize =
      (f.lru_cache_0_1_1.heapsize or false) ||
      (f.lru_cache_0_1_1.heapsize_impl or false) ||
      (lru_cache_0_1_1.heapsize_impl or false);
  }) [ linked_hash_map_0_4_2_features ];
  matches_0_1_6 = { features?(matches_0_1_6_features {}) }: matches_0_1_6_ {};
  matches_0_1_6_features = f: updateFeatures f (rec {
    matches_0_1_6.default = (f.matches_0_1_6.default or true);
  }) [];
  md5_0_3_7 = { features?(md5_0_3_7_features {}) }: md5_0_3_7_ {};
  md5_0_3_7_features = f: updateFeatures f (rec {
    md5_0_3_7.default = (f.md5_0_3_7.default or true);
  }) [];
  memchr_2_0_1 = { features?(memchr_2_0_1_features {}) }: memchr_2_0_1_ {
    dependencies = mapFeatures features ([ ]
      ++ (if features.memchr_2_0_1.libc or false then [ libc_0_2_40 ] else []));
    features = mkFeatures (features.memchr_2_0_1 or {});
  };
  memchr_2_0_1_features = f: updateFeatures f (rec {
    libc_0_2_40.default = (f.libc_0_2_40.default or false);
    libc_0_2_40.use_std =
      (f.libc_0_2_40.use_std or false) ||
      (memchr_2_0_1.use_std or false) ||
      (f.memchr_2_0_1.use_std or false);
    memchr_2_0_1.default = (f.memchr_2_0_1.default or true);
    memchr_2_0_1.libc =
      (f.memchr_2_0_1.libc or false) ||
      (f.memchr_2_0_1.default or false) ||
      (memchr_2_0_1.default or false) ||
      (f.memchr_2_0_1.use_std or false) ||
      (memchr_2_0_1.use_std or false);
    memchr_2_0_1.use_std =
      (f.memchr_2_0_1.use_std or false) ||
      (f.memchr_2_0_1.default or false) ||
      (memchr_2_0_1.default or false);
  }) [ libc_0_2_40_features ];
  memoffset_0_1_0 = { features?(memoffset_0_1_0_features {}) }: memoffset_0_1_0_ {
    features = mkFeatures (features.memoffset_0_1_0 or {});
  };
  memoffset_0_1_0_features = f: updateFeatures f (rec {
    memoffset_0_1_0.default = (f.memoffset_0_1_0.default or true);
    memoffset_0_1_0.std =
      (f.memoffset_0_1_0.std or false) ||
      (f.memoffset_0_1_0.default or false) ||
      (memoffset_0_1_0.default or false);
  }) [];
  memoffset_0_2_1 = { features?(memoffset_0_2_1_features {}) }: memoffset_0_2_1_ {};
  memoffset_0_2_1_features = f: updateFeatures f (rec {
    memoffset_0_2_1.default = (f.memoffset_0_2_1.default or true);
  }) [];
  mime_0_3_5 = { features?(mime_0_3_5_features {}) }: mime_0_3_5_ {
    dependencies = mapFeatures features ([ unicase_2_1_0 ]);
  };
  mime_0_3_5_features = f: updateFeatures f (rec {
    mime_0_3_5.default = (f.mime_0_3_5.default or true);
    unicase_2_1_0.default = true;
  }) [ unicase_2_1_0_features ];
  mime_guess_2_0_0_alpha_4 = { features?(mime_guess_2_0_0_alpha_4_features {}) }: mime_guess_2_0_0_alpha_4_ {
    dependencies = mapFeatures features ([ mime_0_3_5 phf_0_7_22 unicase_1_4_2 ]);
    buildDependencies = mapFeatures features ([ phf_codegen_0_7_22 unicase_1_4_2 ]);
    features = mkFeatures (features.mime_guess_2_0_0_alpha_4 or {});
  };
  mime_guess_2_0_0_alpha_4_features = f: updateFeatures f (rec {
    mime_0_3_5.default = true;
    mime_guess_2_0_0_alpha_4.default = (f.mime_guess_2_0_0_alpha_4.default or true);
    phf_0_7_22.default = true;
    phf_0_7_22.unicase = true;
    phf_codegen_0_7_22.default = true;
    unicase_1_4_2.default = true;
  }) [ mime_0_3_5_features phf_0_7_22_features unicase_1_4_2_features phf_codegen_0_7_22_features unicase_1_4_2_features ];
  miniz_sys_0_1_10 = { features?(miniz_sys_0_1_10_features {}) }: miniz_sys_0_1_10_ {
    dependencies = mapFeatures features ([ libc_0_2_40 ]);
    buildDependencies = mapFeatures features ([ cc_1_0_15 ]);
  };
  miniz_sys_0_1_10_features = f: updateFeatures f (rec {
    cc_1_0_15.default = true;
    libc_0_2_40.default = true;
    miniz_sys_0_1_10.default = (f.miniz_sys_0_1_10.default or true);
  }) [ libc_0_2_40_features cc_1_0_15_features ];
  mio_0_6_14 = { features?(mio_0_6_14_features {}) }: mio_0_6_14_ {
    dependencies = mapFeatures features ([ iovec_0_1_2 lazycell_0_6_0 log_0_4_1 net2_0_2_32 slab_0_4_0 ])
      ++ (if kernel == "fuchsia" then mapFeatures features ([ fuchsia_zircon_0_3_3 fuchsia_zircon_sys_0_3_3 ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ kernel32_sys_0_2_2 miow_0_2_1 winapi_0_2_8 ]) else []);
    features = mkFeatures (features.mio_0_6_14 or {});
  };
  mio_0_6_14_features = f: updateFeatures f (rec {
    fuchsia_zircon_0_3_3.default = true;
    fuchsia_zircon_sys_0_3_3.default = true;
    iovec_0_1_2.default = true;
    kernel32_sys_0_2_2.default = true;
    lazycell_0_6_0.default = true;
    libc_0_2_40.default = true;
    log_0_4_1.default = true;
    mio_0_6_14.default = (f.mio_0_6_14.default or true);
    mio_0_6_14.with-deprecated =
      (f.mio_0_6_14.with-deprecated or false) ||
      (f.mio_0_6_14.default or false) ||
      (mio_0_6_14.default or false);
    miow_0_2_1.default = true;
    net2_0_2_32.default = true;
    slab_0_4_0.default = true;
    winapi_0_2_8.default = true;
  }) [ iovec_0_1_2_features lazycell_0_6_0_features log_0_4_1_features net2_0_2_32_features slab_0_4_0_features fuchsia_zircon_0_3_3_features fuchsia_zircon_sys_0_3_3_features libc_0_2_40_features kernel32_sys_0_2_2_features miow_0_2_1_features winapi_0_2_8_features ];
  mio_uds_0_6_4 = { features?(mio_uds_0_6_4_features {}) }: mio_uds_0_6_4_ {
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ libc_0_2_40 mio_0_6_14 ]) else []);
  };
  mio_uds_0_6_4_features = f: updateFeatures f (rec {
    libc_0_2_40.default = true;
    mio_0_6_14.default = true;
    mio_uds_0_6_4.default = (f.mio_uds_0_6_4.default or true);
  }) [ libc_0_2_40_features mio_0_6_14_features ];
  miow_0_2_1 = { features?(miow_0_2_1_features {}) }: miow_0_2_1_ {
    dependencies = mapFeatures features ([ kernel32_sys_0_2_2 net2_0_2_32 winapi_0_2_8 ws2_32_sys_0_2_1 ]);
  };
  miow_0_2_1_features = f: updateFeatures f (rec {
    kernel32_sys_0_2_2.default = true;
    miow_0_2_1.default = (f.miow_0_2_1.default or true);
    net2_0_2_32.default = (f.net2_0_2_32.default or false);
    winapi_0_2_8.default = true;
    ws2_32_sys_0_2_1.default = true;
  }) [ kernel32_sys_0_2_2_features net2_0_2_32_features winapi_0_2_8_features ws2_32_sys_0_2_1_features ];
  native_tls_0_1_5 = { features?(native_tls_0_1_5_features {}) }: native_tls_0_1_5_ {
    dependencies = mapFeatures features ([ lazy_static_0_2_11 ])
      ++ (if kernel == "darwin" || kernel == "ios" then mapFeatures features ([ libc_0_2_40 security_framework_0_1_16 security_framework_sys_0_1_16 tempdir_0_3_7 ]) else [])
      ++ (if !(kernel == "windows" || kernel == "darwin" || kernel == "ios") then mapFeatures features ([ openssl_0_9_24 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ schannel_0_1_12 ]) else []);
  };
  native_tls_0_1_5_features = f: updateFeatures f (rec {
    lazy_static_0_2_11.default = true;
    libc_0_2_40.default = true;
    native_tls_0_1_5.default = (f.native_tls_0_1_5.default or true);
    openssl_0_9_24.default = true;
    schannel_0_1_12.default = true;
    security_framework_0_1_16.OSX_10_8 = true;
    security_framework_0_1_16.default = true;
    security_framework_sys_0_1_16.default = true;
    tempdir_0_3_7.default = true;
  }) [ lazy_static_0_2_11_features libc_0_2_40_features security_framework_0_1_16_features security_framework_sys_0_1_16_features tempdir_0_3_7_features openssl_0_9_24_features schannel_0_1_12_features ];
  net2_0_2_32 = { features?(net2_0_2_32_features {}) }: net2_0_2_32_ {
    dependencies = mapFeatures features ([ cfg_if_0_1_2 ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else [])
      ++ (if kernel == "i686-apple-darwin" then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "i686-unknown-linux-gnu" then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "x86_64-apple-darwin" then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "x86_64-unknown-linux-gnu" then mapFeatures features ([ libc_0_2_40 ]) else []);
    features = mkFeatures (features.net2_0_2_32 or {});
  };
  net2_0_2_32_features = f: updateFeatures f (rec {
    cfg_if_0_1_2.default = true;
    libc_0_2_40.default = true;
    net2_0_2_32.default = (f.net2_0_2_32.default or true);
    net2_0_2_32.duration =
      (f.net2_0_2_32.duration or false) ||
      (f.net2_0_2_32.default or false) ||
      (net2_0_2_32.default or false);
    winapi_0_3_4.default = true;
    winapi_0_3_4.handleapi = true;
    winapi_0_3_4.winsock2 = true;
    winapi_0_3_4.ws2def = true;
    winapi_0_3_4.ws2ipdef = true;
    winapi_0_3_4.ws2tcpip = true;
  }) [ cfg_if_0_1_2_features libc_0_2_40_features winapi_0_3_4_features libc_0_2_40_features libc_0_2_40_features libc_0_2_40_features libc_0_2_40_features ];
  nodrop_0_1_12 = { features?(nodrop_0_1_12_features {}) }: nodrop_0_1_12_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.nodrop_0_1_12 or {});
  };
  nodrop_0_1_12_features = f: updateFeatures f (rec {
    nodrop_0_1_12.default = (f.nodrop_0_1_12.default or true);
    nodrop_0_1_12.nodrop-union =
      (f.nodrop_0_1_12.nodrop-union or false) ||
      (f.nodrop_0_1_12.use_union or false) ||
      (nodrop_0_1_12.use_union or false);
    nodrop_0_1_12.std =
      (f.nodrop_0_1_12.std or false) ||
      (f.nodrop_0_1_12.default or false) ||
      (nodrop_0_1_12.default or false);
  }) [];
  num_integer_0_1_36 = { features?(num_integer_0_1_36_features {}) }: num_integer_0_1_36_ {
    dependencies = mapFeatures features ([ num_traits_0_2_2 ]);
    features = mkFeatures (features.num_integer_0_1_36 or {});
  };
  num_integer_0_1_36_features = f: updateFeatures f (rec {
    num_integer_0_1_36.default = (f.num_integer_0_1_36.default or true);
    num_integer_0_1_36.std =
      (f.num_integer_0_1_36.std or false) ||
      (f.num_integer_0_1_36.default or false) ||
      (num_integer_0_1_36.default or false);
    num_traits_0_2_2.default = (f.num_traits_0_2_2.default or false);
  }) [ num_traits_0_2_2_features ];
  num_traits_0_2_2 = { features?(num_traits_0_2_2_features {}) }: num_traits_0_2_2_ {
    features = mkFeatures (features.num_traits_0_2_2 or {});
  };
  num_traits_0_2_2_features = f: updateFeatures f (rec {
    num_traits_0_2_2.default = (f.num_traits_0_2_2.default or true);
    num_traits_0_2_2.std =
      (f.num_traits_0_2_2.std or false) ||
      (f.num_traits_0_2_2.default or false) ||
      (num_traits_0_2_2.default or false);
  }) [];
  num_cpus_1_8_0 = { features?(num_cpus_1_8_0_features {}) }: num_cpus_1_8_0_ {
    dependencies = mapFeatures features ([ libc_0_2_40 ]);
  };
  num_cpus_1_8_0_features = f: updateFeatures f (rec {
    libc_0_2_40.default = true;
    num_cpus_1_8_0.default = (f.num_cpus_1_8_0.default or true);
  }) [ libc_0_2_40_features ];
  openssl_0_9_24 = { features?(openssl_0_9_24_features {}) }: openssl_0_9_24_ {
    dependencies = mapFeatures features ([ bitflags_0_9_1 foreign_types_0_3_2 lazy_static_1_0_0 libc_0_2_40 openssl_sys_0_9_30 ]);
    features = mkFeatures (features.openssl_0_9_24 or {});
  };
  openssl_0_9_24_features = f: updateFeatures f (rec {
    bitflags_0_9_1.default = true;
    foreign_types_0_3_2.default = true;
    lazy_static_1_0_0.default = true;
    libc_0_2_40.default = true;
    openssl_0_9_24.default = (f.openssl_0_9_24.default or true);
    openssl_sys_0_9_30.default = true;
  }) [ bitflags_0_9_1_features foreign_types_0_3_2_features lazy_static_1_0_0_features libc_0_2_40_features openssl_sys_0_9_30_features ];
  openssl_sys_0_9_30 = { features?(openssl_sys_0_9_30_features {}) }: openssl_sys_0_9_30_ {
    dependencies = mapFeatures features ([ libc_0_2_40 ])
      ++ (if abi == "msvc" then mapFeatures features ([]) else []);
    buildDependencies = mapFeatures features ([ cc_1_0_15 pkg_config_0_3_11 ]);
  };
  openssl_sys_0_9_30_features = f: updateFeatures f (rec {
    cc_1_0_15.default = true;
    libc_0_2_40.default = true;
    openssl_sys_0_9_30.default = (f.openssl_sys_0_9_30.default or true);
    pkg_config_0_3_11.default = true;
  }) [ libc_0_2_40_features cc_1_0_15_features pkg_config_0_3_11_features ];
  owning_ref_0_3_3 = { features?(owning_ref_0_3_3_features {}) }: owning_ref_0_3_3_ {
    dependencies = mapFeatures features ([ stable_deref_trait_1_0_0 ]);
  };
  owning_ref_0_3_3_features = f: updateFeatures f (rec {
    owning_ref_0_3_3.default = (f.owning_ref_0_3_3.default or true);
    stable_deref_trait_1_0_0.default = true;
  }) [ stable_deref_trait_1_0_0_features ];
  parking_lot_0_4_8 = { features?(parking_lot_0_4_8_features {}) }: parking_lot_0_4_8_ {
    dependencies = mapFeatures features ([ parking_lot_core_0_2_14 ]
      ++ (if features.parking_lot_0_4_8.owning_ref or false then [ owning_ref_0_3_3 ] else []));
    features = mkFeatures (features.parking_lot_0_4_8 or {});
  };
  parking_lot_0_4_8_features = f: updateFeatures f (rec {
    owning_ref_0_3_3.default = true;
    parking_lot_0_4_8.default = (f.parking_lot_0_4_8.default or true);
    parking_lot_0_4_8.owning_ref =
      (f.parking_lot_0_4_8.owning_ref or false) ||
      (f.parking_lot_0_4_8.default or false) ||
      (parking_lot_0_4_8.default or false);
    parking_lot_core_0_2_14.deadlock_detection =
      (f.parking_lot_core_0_2_14.deadlock_detection or false) ||
      (parking_lot_0_4_8.deadlock_detection or false) ||
      (f.parking_lot_0_4_8.deadlock_detection or false);
    parking_lot_core_0_2_14.default = true;
    parking_lot_core_0_2_14.nightly =
      (f.parking_lot_core_0_2_14.nightly or false) ||
      (parking_lot_0_4_8.nightly or false) ||
      (f.parking_lot_0_4_8.nightly or false);
  }) [ owning_ref_0_3_3_features parking_lot_core_0_2_14_features ];
  parking_lot_core_0_2_14 = { features?(parking_lot_core_0_2_14_features {}) }: parking_lot_core_0_2_14_ {
    dependencies = mapFeatures features ([ rand_0_4_2 smallvec_0_6_1 ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else []);
    features = mkFeatures (features.parking_lot_core_0_2_14 or {});
  };
  parking_lot_core_0_2_14_features = f: updateFeatures f (rec {
    libc_0_2_40.default = true;
    parking_lot_core_0_2_14.backtrace =
      (f.parking_lot_core_0_2_14.backtrace or false) ||
      (f.parking_lot_core_0_2_14.deadlock_detection or false) ||
      (parking_lot_core_0_2_14.deadlock_detection or false);
    parking_lot_core_0_2_14.default = (f.parking_lot_core_0_2_14.default or true);
    parking_lot_core_0_2_14.petgraph =
      (f.parking_lot_core_0_2_14.petgraph or false) ||
      (f.parking_lot_core_0_2_14.deadlock_detection or false) ||
      (parking_lot_core_0_2_14.deadlock_detection or false);
    parking_lot_core_0_2_14.thread-id =
      (f.parking_lot_core_0_2_14.thread-id or false) ||
      (f.parking_lot_core_0_2_14.deadlock_detection or false) ||
      (parking_lot_core_0_2_14.deadlock_detection or false);
    rand_0_4_2.default = true;
    smallvec_0_6_1.default = true;
    winapi_0_3_4.default = true;
    winapi_0_3_4.errhandlingapi = true;
    winapi_0_3_4.handleapi = true;
    winapi_0_3_4.minwindef = true;
    winapi_0_3_4.ntstatus = true;
    winapi_0_3_4.winbase = true;
    winapi_0_3_4.winerror = true;
    winapi_0_3_4.winnt = true;
  }) [ rand_0_4_2_features smallvec_0_6_1_features libc_0_2_40_features winapi_0_3_4_features ];
  percent_encoding_1_0_1 = { features?(percent_encoding_1_0_1_features {}) }: percent_encoding_1_0_1_ {};
  percent_encoding_1_0_1_features = f: updateFeatures f (rec {
    percent_encoding_1_0_1.default = (f.percent_encoding_1_0_1.default or true);
  }) [];
  pest_1_0_6 = { features?(pest_1_0_6_features {}) }: pest_1_0_6_ {};
  pest_1_0_6_features = f: updateFeatures f (rec {
    pest_1_0_6.default = (f.pest_1_0_6.default or true);
  }) [];
  pest_derive_1_0_7 = { features?(pest_derive_1_0_7_features {}) }: pest_derive_1_0_7_ {
    dependencies = mapFeatures features ([ pest_1_0_6 quote_0_3_15 syn_0_11_11 ]);
  };
  pest_derive_1_0_7_features = f: updateFeatures f (rec {
    pest_1_0_6.default = true;
    pest_derive_1_0_7.default = (f.pest_derive_1_0_7.default or true);
    quote_0_3_15.default = true;
    syn_0_11_11.default = true;
  }) [ pest_1_0_6_features quote_0_3_15_features syn_0_11_11_features ];
  phf_0_7_22 = { features?(phf_0_7_22_features {}) }: phf_0_7_22_ {
    dependencies = mapFeatures features ([ phf_shared_0_7_22 ]);
    features = mkFeatures (features.phf_0_7_22 or {});
  };
  phf_0_7_22_features = f: updateFeatures f (rec {
    phf_0_7_22.default = (f.phf_0_7_22.default or true);
    phf_shared_0_7_22.core =
      (f.phf_shared_0_7_22.core or false) ||
      (phf_0_7_22.core or false) ||
      (f.phf_0_7_22.core or false);
    phf_shared_0_7_22.default = true;
    phf_shared_0_7_22.unicase =
      (f.phf_shared_0_7_22.unicase or false) ||
      (phf_0_7_22.unicase or false) ||
      (f.phf_0_7_22.unicase or false);
  }) [ phf_shared_0_7_22_features ];
  phf_codegen_0_7_22 = { features?(phf_codegen_0_7_22_features {}) }: phf_codegen_0_7_22_ {
    dependencies = mapFeatures features ([ phf_generator_0_7_22 phf_shared_0_7_22 ]);
  };
  phf_codegen_0_7_22_features = f: updateFeatures f (rec {
    phf_codegen_0_7_22.default = (f.phf_codegen_0_7_22.default or true);
    phf_generator_0_7_22.default = true;
    phf_shared_0_7_22.default = true;
  }) [ phf_generator_0_7_22_features phf_shared_0_7_22_features ];
  phf_generator_0_7_22 = { features?(phf_generator_0_7_22_features {}) }: phf_generator_0_7_22_ {
    dependencies = mapFeatures features ([ phf_shared_0_7_22 rand_0_4_2 ]);
  };
  phf_generator_0_7_22_features = f: updateFeatures f (rec {
    phf_generator_0_7_22.default = (f.phf_generator_0_7_22.default or true);
    phf_shared_0_7_22.default = true;
    rand_0_4_2.default = true;
  }) [ phf_shared_0_7_22_features rand_0_4_2_features ];
  phf_shared_0_7_22 = { features?(phf_shared_0_7_22_features {}) }: phf_shared_0_7_22_ {
    dependencies = mapFeatures features ([ siphasher_0_2_2 ]
      ++ (if features.phf_shared_0_7_22.unicase or false then [ unicase_1_4_2 ] else []));
    features = mkFeatures (features.phf_shared_0_7_22 or {});
  };
  phf_shared_0_7_22_features = f: updateFeatures f (rec {
    phf_shared_0_7_22.default = (f.phf_shared_0_7_22.default or true);
    siphasher_0_2_2.default = true;
    unicase_1_4_2.default = true;
  }) [ siphasher_0_2_2_features unicase_1_4_2_features ];
  pkg_config_0_3_11 = { features?(pkg_config_0_3_11_features {}) }: pkg_config_0_3_11_ {};
  pkg_config_0_3_11_features = f: updateFeatures f (rec {
    pkg_config_0_3_11.default = (f.pkg_config_0_3_11.default or true);
  }) [];
  pq_sys_0_4_4 = { features?(pq_sys_0_4_4_features {}) }: pq_sys_0_4_4_ {
    dependencies = (if abi == "msvc" then mapFeatures features ([]) else []);
    buildDependencies = mapFeatures features ([]);
  };
  pq_sys_0_4_4_features = f: updateFeatures f (rec {
    pq_sys_0_4_4.default = (f.pq_sys_0_4_4.default or true);
  }) [];
  proc_macro2_0_2_3 = { features?(proc_macro2_0_2_3_features {}) }: proc_macro2_0_2_3_ {
    dependencies = mapFeatures features ([ unicode_xid_0_1_0 ]);
    features = mkFeatures (features.proc_macro2_0_2_3 or {});
  };
  proc_macro2_0_2_3_features = f: updateFeatures f (rec {
    proc_macro2_0_2_3.default = (f.proc_macro2_0_2_3.default or true);
    proc_macro2_0_2_3.proc-macro =
      (f.proc_macro2_0_2_3.proc-macro or false) ||
      (f.proc_macro2_0_2_3.default or false) ||
      (proc_macro2_0_2_3.default or false) ||
      (f.proc_macro2_0_2_3.nightly or false) ||
      (proc_macro2_0_2_3.nightly or false);
    unicode_xid_0_1_0.default = true;
  }) [ unicode_xid_0_1_0_features ];
  proc_macro2_0_3_8 = { features?(proc_macro2_0_3_8_features {}) }: proc_macro2_0_3_8_ {
    dependencies = mapFeatures features ([ unicode_xid_0_1_0 ]);
    features = mkFeatures (features.proc_macro2_0_3_8 or {});
  };
  proc_macro2_0_3_8_features = f: updateFeatures f (rec {
    proc_macro2_0_3_8.default = (f.proc_macro2_0_3_8.default or true);
    proc_macro2_0_3_8.proc-macro =
      (f.proc_macro2_0_3_8.proc-macro or false) ||
      (f.proc_macro2_0_3_8.default or false) ||
      (proc_macro2_0_3_8.default or false) ||
      (f.proc_macro2_0_3_8.nightly or false) ||
      (proc_macro2_0_3_8.nightly or false);
    unicode_xid_0_1_0.default = true;
  }) [ unicode_xid_0_1_0_features ];
  pulldown_cmark_0_1_2 = { features?(pulldown_cmark_0_1_2_features {}) }: pulldown_cmark_0_1_2_ {
    dependencies = mapFeatures features ([ bitflags_0_9_1 ]
      ++ (if features.pulldown_cmark_0_1_2.getopts or false then [ getopts_0_2_17 ] else []));
    features = mkFeatures (features.pulldown_cmark_0_1_2 or {});
  };
  pulldown_cmark_0_1_2_features = f: updateFeatures f (rec {
    bitflags_0_9_1.default = true;
    getopts_0_2_17.default = true;
    pulldown_cmark_0_1_2.default = (f.pulldown_cmark_0_1_2.default or true);
    pulldown_cmark_0_1_2.getopts =
      (f.pulldown_cmark_0_1_2.getopts or false) ||
      (f.pulldown_cmark_0_1_2.default or false) ||
      (pulldown_cmark_0_1_2.default or false);
  }) [ bitflags_0_9_1_features getopts_0_2_17_features ];
  quick_error_1_2_1 = { features?(quick_error_1_2_1_features {}) }: quick_error_1_2_1_ {};
  quick_error_1_2_1_features = f: updateFeatures f (rec {
    quick_error_1_2_1.default = (f.quick_error_1_2_1.default or true);
  }) [];
  quote_0_3_15 = { features?(quote_0_3_15_features {}) }: quote_0_3_15_ {};
  quote_0_3_15_features = f: updateFeatures f (rec {
    quote_0_3_15.default = (f.quote_0_3_15.default or true);
  }) [];
  quote_0_4_2 = { features?(quote_0_4_2_features {}) }: quote_0_4_2_ {
    dependencies = mapFeatures features ([ proc_macro2_0_2_3 ]);
  };
  quote_0_4_2_features = f: updateFeatures f (rec {
    proc_macro2_0_2_3.default = true;
    quote_0_4_2.default = (f.quote_0_4_2.default or true);
  }) [ proc_macro2_0_2_3_features ];
  quote_0_5_2 = { features?(quote_0_5_2_features {}) }: quote_0_5_2_ {
    dependencies = mapFeatures features ([ proc_macro2_0_3_8 ]);
    features = mkFeatures (features.quote_0_5_2 or {});
  };
  quote_0_5_2_features = f: updateFeatures f (rec {
    proc_macro2_0_3_8.default = (f.proc_macro2_0_3_8.default or false);
    proc_macro2_0_3_8.proc-macro =
      (f.proc_macro2_0_3_8.proc-macro or false) ||
      (quote_0_5_2.proc-macro or false) ||
      (f.quote_0_5_2.proc-macro or false);
    quote_0_5_2.default = (f.quote_0_5_2.default or true);
    quote_0_5_2.proc-macro =
      (f.quote_0_5_2.proc-macro or false) ||
      (f.quote_0_5_2.default or false) ||
      (quote_0_5_2.default or false);
  }) [ proc_macro2_0_3_8_features ];
  r2d2_0_8_2 = { features?(r2d2_0_8_2_features {}) }: r2d2_0_8_2_ {
    dependencies = mapFeatures features ([ antidote_1_0_0 log_0_4_1 scheduled_thread_pool_0_2_0 ]);
  };
  r2d2_0_8_2_features = f: updateFeatures f (rec {
    antidote_1_0_0.default = true;
    log_0_4_1.default = true;
    r2d2_0_8_2.default = (f.r2d2_0_8_2.default or true);
    scheduled_thread_pool_0_2_0.default = true;
  }) [ antidote_1_0_0_features log_0_4_1_features scheduled_thread_pool_0_2_0_features ];
  rand_0_3_22 = { features?(rand_0_3_22_features {}) }: rand_0_3_22_ {
    dependencies = mapFeatures features ([ libc_0_2_40 rand_0_4_2 ])
      ++ (if kernel == "fuchsia" then mapFeatures features ([ fuchsia_zircon_0_3_3 ]) else []);
    features = mkFeatures (features.rand_0_3_22 or {});
  };
  rand_0_3_22_features = f: updateFeatures f (rec {
    fuchsia_zircon_0_3_3.default = true;
    libc_0_2_40.default = true;
    rand_0_3_22.default = (f.rand_0_3_22.default or true);
    rand_0_3_22.i128_support =
      (f.rand_0_3_22.i128_support or false) ||
      (f.rand_0_3_22.nightly or false) ||
      (rand_0_3_22.nightly or false);
    rand_0_4_2.default = true;
  }) [ libc_0_2_40_features rand_0_4_2_features fuchsia_zircon_0_3_3_features ];
  rand_0_4_2 = { features?(rand_0_4_2_features {}) }: rand_0_4_2_ {
    dependencies = (if kernel == "fuchsia" then mapFeatures features ([ fuchsia_zircon_0_3_3 ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ ]
      ++ (if features.rand_0_4_2.libc or false then [ libc_0_2_40 ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else []);
    features = mkFeatures (features.rand_0_4_2 or {});
  };
  rand_0_4_2_features = f: updateFeatures f (rec {
    fuchsia_zircon_0_3_3.default = true;
    libc_0_2_40.default = true;
    rand_0_4_2.default = (f.rand_0_4_2.default or true);
    rand_0_4_2.i128_support =
      (f.rand_0_4_2.i128_support or false) ||
      (f.rand_0_4_2.nightly or false) ||
      (rand_0_4_2.nightly or false);
    rand_0_4_2.libc =
      (f.rand_0_4_2.libc or false) ||
      (f.rand_0_4_2.std or false) ||
      (rand_0_4_2.std or false);
    rand_0_4_2.std =
      (f.rand_0_4_2.std or false) ||
      (f.rand_0_4_2.default or false) ||
      (rand_0_4_2.default or false);
    winapi_0_3_4.default = true;
    winapi_0_3_4.minwindef = true;
    winapi_0_3_4.ntsecapi = true;
    winapi_0_3_4.profileapi = true;
    winapi_0_3_4.winnt = true;
  }) [ fuchsia_zircon_0_3_3_features libc_0_2_40_features winapi_0_3_4_features ];
  rayon_0_8_2 = { features?(rayon_0_8_2_features {}) }: rayon_0_8_2_ {
    dependencies = mapFeatures features ([ rayon_core_1_4_0 ]);
  };
  rayon_0_8_2_features = f: updateFeatures f (rec {
    rayon_0_8_2.default = (f.rayon_0_8_2.default or true);
    rayon_core_1_4_0.default = true;
  }) [ rayon_core_1_4_0_features ];
  rayon_core_1_4_0 = { features?(rayon_core_1_4_0_features {}) }: rayon_core_1_4_0_ {
    dependencies = mapFeatures features ([ crossbeam_deque_0_2_0 lazy_static_1_0_0 libc_0_2_40 num_cpus_1_8_0 rand_0_4_2 ]);
  };
  rayon_core_1_4_0_features = f: updateFeatures f (rec {
    crossbeam_deque_0_2_0.default = true;
    lazy_static_1_0_0.default = true;
    libc_0_2_40.default = true;
    num_cpus_1_8_0.default = true;
    rand_0_4_2.default = true;
    rayon_core_1_4_0.default = (f.rayon_core_1_4_0.default or true);
  }) [ crossbeam_deque_0_2_0_features lazy_static_1_0_0_features libc_0_2_40_features num_cpus_1_8_0_features rand_0_4_2_features ];
  redox_syscall_0_1_37 = { features?(redox_syscall_0_1_37_features {}) }: redox_syscall_0_1_37_ {};
  redox_syscall_0_1_37_features = f: updateFeatures f (rec {
    redox_syscall_0_1_37.default = (f.redox_syscall_0_1_37.default or true);
  }) [];
  redox_termios_0_1_1 = { features?(redox_termios_0_1_1_features {}) }: redox_termios_0_1_1_ {
    dependencies = mapFeatures features ([ redox_syscall_0_1_37 ]);
  };
  redox_termios_0_1_1_features = f: updateFeatures f (rec {
    redox_syscall_0_1_37.default = true;
    redox_termios_0_1_1.default = (f.redox_termios_0_1_1.default or true);
  }) [ redox_syscall_0_1_37_features ];
  regex_0_2_11 = { features?(regex_0_2_11_features {}) }: regex_0_2_11_ {
    dependencies = mapFeatures features ([ aho_corasick_0_6_4 memchr_2_0_1 regex_syntax_0_5_6 thread_local_0_3_5 utf8_ranges_1_0_0 ]);
    features = mkFeatures (features.regex_0_2_11 or {});
  };
  regex_0_2_11_features = f: updateFeatures f (rec {
    aho_corasick_0_6_4.default = true;
    memchr_2_0_1.default = true;
    regex_0_2_11.default = (f.regex_0_2_11.default or true);
    regex_0_2_11.pattern =
      (f.regex_0_2_11.pattern or false) ||
      (f.regex_0_2_11.unstable or false) ||
      (regex_0_2_11.unstable or false);
    regex_syntax_0_5_6.default = true;
    thread_local_0_3_5.default = true;
    utf8_ranges_1_0_0.default = true;
  }) [ aho_corasick_0_6_4_features memchr_2_0_1_features regex_syntax_0_5_6_features thread_local_0_3_5_features utf8_ranges_1_0_0_features ];
  regex_syntax_0_5_6 = { features?(regex_syntax_0_5_6_features {}) }: regex_syntax_0_5_6_ {
    dependencies = mapFeatures features ([ ucd_util_0_1_1 ]);
  };
  regex_syntax_0_5_6_features = f: updateFeatures f (rec {
    regex_syntax_0_5_6.default = (f.regex_syntax_0_5_6.default or true);
    ucd_util_0_1_1.default = true;
  }) [ ucd_util_0_1_1_features ];
  relay_0_1_1 = { features?(relay_0_1_1_features {}) }: relay_0_1_1_ {
    dependencies = mapFeatures features ([ futures_0_1_21 ]);
  };
  relay_0_1_1_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    relay_0_1_1.default = (f.relay_0_1_1.default or true);
  }) [ futures_0_1_21_features ];
  remove_dir_all_0_5_1 = { features?(remove_dir_all_0_5_1_features {}) }: remove_dir_all_0_5_1_ {
    dependencies = (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else []);
  };
  remove_dir_all_0_5_1_features = f: updateFeatures f (rec {
    remove_dir_all_0_5_1.default = (f.remove_dir_all_0_5_1.default or true);
    winapi_0_3_4.default = true;
    winapi_0_3_4.errhandlingapi = true;
    winapi_0_3_4.fileapi = true;
    winapi_0_3_4.std = true;
    winapi_0_3_4.winbase = true;
    winapi_0_3_4.winerror = true;
  }) [ winapi_0_3_4_features ];
  reqwest_0_8_5 = { features?(reqwest_0_8_5_features {}) }: reqwest_0_8_5_ {
    dependencies = mapFeatures features ([ bytes_0_4_7 encoding_rs_0_7_2 futures_0_1_21 hyper_0_11_25 hyper_tls_0_1_3 libflate_0_1_14 log_0_4_1 mime_guess_2_0_0_alpha_4 native_tls_0_1_5 serde_1_0_43 serde_json_1_0_16 serde_urlencoded_0_5_1 tokio_core_0_1_17 tokio_io_0_1_6 tokio_tls_0_1_4 url_1_7_0 uuid_0_5_1 ]);
    features = mkFeatures (features.reqwest_0_8_5 or {});
  };
  reqwest_0_8_5_features = f: updateFeatures f (rec {
    bytes_0_4_7.default = true;
    encoding_rs_0_7_2.default = true;
    futures_0_1_21.default = true;
    hyper_0_11_25.default = true;
    hyper_tls_0_1_3.default = true;
    libflate_0_1_14.default = true;
    log_0_4_1.default = true;
    mime_guess_2_0_0_alpha_4.default = true;
    native_tls_0_1_5.default = true;
    reqwest_0_8_5.default = (f.reqwest_0_8_5.default or true);
    serde_1_0_43.default = true;
    serde_json_1_0_16.default = true;
    serde_urlencoded_0_5_1.default = true;
    tokio_core_0_1_17.default = true;
    tokio_io_0_1_6.default = true;
    tokio_tls_0_1_4.default = true;
    url_1_7_0.default = true;
    uuid_0_5_1.default = true;
    uuid_0_5_1.v4 = true;
  }) [ bytes_0_4_7_features encoding_rs_0_7_2_features futures_0_1_21_features hyper_0_11_25_features hyper_tls_0_1_3_features libflate_0_1_14_features log_0_4_1_features mime_guess_2_0_0_alpha_4_features native_tls_0_1_5_features serde_1_0_43_features serde_json_1_0_16_features serde_urlencoded_0_5_1_features tokio_core_0_1_17_features tokio_io_0_1_6_features tokio_tls_0_1_4_features url_1_7_0_features uuid_0_5_1_features ];
  resolv_conf_0_6_0 = { features?(resolv_conf_0_6_0_features {}) }: resolv_conf_0_6_0_ {
    dependencies = mapFeatures features ([ quick_error_1_2_1 ]
      ++ (if features.resolv_conf_0_6_0.hostname or false then [ hostname_0_1_4 ] else []));
    features = mkFeatures (features.resolv_conf_0_6_0 or {});
  };
  resolv_conf_0_6_0_features = f: updateFeatures f (rec {
    hostname_0_1_4.default = true;
    quick_error_1_2_1.default = true;
    resolv_conf_0_6_0.default = (f.resolv_conf_0_6_0.default or true);
    resolv_conf_0_6_0.hostname =
      (f.resolv_conf_0_6_0.hostname or false) ||
      (f.resolv_conf_0_6_0.system or false) ||
      (resolv_conf_0_6_0.system or false);
  }) [ hostname_0_1_4_features quick_error_1_2_1_features ];
  ring_0_12_1 = { features?(ring_0_12_1_features {}) }: ring_0_12_1_ {
    dependencies = mapFeatures features ([ libc_0_2_40 untrusted_0_5_1 ])
      ++ (if kernel == "redox" || (kernel == "linux" || kernel == "darwin") && !(kernel == "darwin" || kernel == "ios") then mapFeatures features ([ lazy_static_0_2_11 ]) else []);
    buildDependencies = mapFeatures features ([ gcc_0_3_54 rayon_0_8_2 ]);
    features = mkFeatures (features.ring_0_12_1 or {});
  };
  ring_0_12_1_features = f: updateFeatures f (rec {
    gcc_0_3_54.default = true;
    lazy_static_0_2_11.default = true;
    libc_0_2_40.default = true;
    rayon_0_8_2.default = true;
    ring_0_12_1.default = (f.ring_0_12_1.default or true);
    ring_0_12_1.dev_urandom_fallback =
      (f.ring_0_12_1.dev_urandom_fallback or false) ||
      (f.ring_0_12_1.default or false) ||
      (ring_0_12_1.default or false);
    ring_0_12_1.use_heap =
      (f.ring_0_12_1.use_heap or false) ||
      (f.ring_0_12_1.default or false) ||
      (ring_0_12_1.default or false) ||
      (f.ring_0_12_1.rsa_signing or false) ||
      (ring_0_12_1.rsa_signing or false);
    untrusted_0_5_1.default = true;
  }) [ libc_0_2_40_features untrusted_0_5_1_features gcc_0_3_54_features rayon_0_8_2_features lazy_static_0_2_11_features ];
  rustc_demangle_0_1_7 = { features?(rustc_demangle_0_1_7_features {}) }: rustc_demangle_0_1_7_ {};
  rustc_demangle_0_1_7_features = f: updateFeatures f (rec {
    rustc_demangle_0_1_7.default = (f.rustc_demangle_0_1_7.default or true);
  }) [];
  safemem_0_2_0 = { features?(safemem_0_2_0_features {}) }: safemem_0_2_0_ {};
  safemem_0_2_0_features = f: updateFeatures f (rec {
    safemem_0_2_0.default = (f.safemem_0_2_0.default or true);
  }) [];
  same_file_0_1_3 = { features?(same_file_0_1_3_features {}) }: same_file_0_1_3_ {
    dependencies = (if kernel == "windows" then mapFeatures features ([ kernel32_sys_0_2_2 winapi_0_2_8 ]) else []);
  };
  same_file_0_1_3_features = f: updateFeatures f (rec {
    kernel32_sys_0_2_2.default = true;
    same_file_0_1_3.default = (f.same_file_0_1_3.default or true);
    winapi_0_2_8.default = true;
  }) [ kernel32_sys_0_2_2_features winapi_0_2_8_features ];
  schannel_0_1_12 = { features?(schannel_0_1_12_features {}) }: schannel_0_1_12_ {
    dependencies = mapFeatures features ([ lazy_static_1_0_0 winapi_0_3_4 ]);
  };
  schannel_0_1_12_features = f: updateFeatures f (rec {
    lazy_static_1_0_0.default = true;
    schannel_0_1_12.default = (f.schannel_0_1_12.default or true);
    winapi_0_3_4.default = true;
    winapi_0_3_4.lmcons = true;
    winapi_0_3_4.minschannel = true;
    winapi_0_3_4.schannel = true;
    winapi_0_3_4.securitybaseapi = true;
    winapi_0_3_4.sysinfoapi = true;
    winapi_0_3_4.timezoneapi = true;
    winapi_0_3_4.winbase = true;
    winapi_0_3_4.wincrypt = true;
    winapi_0_3_4.winerror = true;
  }) [ lazy_static_1_0_0_features winapi_0_3_4_features ];
  scheduled_thread_pool_0_2_0 = { features?(scheduled_thread_pool_0_2_0_features {}) }: scheduled_thread_pool_0_2_0_ {
    dependencies = mapFeatures features ([ antidote_1_0_0 ]);
  };
  scheduled_thread_pool_0_2_0_features = f: updateFeatures f (rec {
    antidote_1_0_0.default = true;
    scheduled_thread_pool_0_2_0.default = (f.scheduled_thread_pool_0_2_0.default or true);
  }) [ antidote_1_0_0_features ];
  scoped_tls_0_1_1 = { features?(scoped_tls_0_1_1_features {}) }: scoped_tls_0_1_1_ {
    features = mkFeatures (features.scoped_tls_0_1_1 or {});
  };
  scoped_tls_0_1_1_features = f: updateFeatures f (rec {
    scoped_tls_0_1_1.default = (f.scoped_tls_0_1_1.default or true);
  }) [];
  scopeguard_0_3_3 = { features?(scopeguard_0_3_3_features {}) }: scopeguard_0_3_3_ {
    features = mkFeatures (features.scopeguard_0_3_3 or {});
  };
  scopeguard_0_3_3_features = f: updateFeatures f (rec {
    scopeguard_0_3_3.default = (f.scopeguard_0_3_3.default or true);
    scopeguard_0_3_3.use_std =
      (f.scopeguard_0_3_3.use_std or false) ||
      (f.scopeguard_0_3_3.default or false) ||
      (scopeguard_0_3_3.default or false);
  }) [];
  security_framework_0_1_16 = { features?(security_framework_0_1_16_features {}) }: security_framework_0_1_16_ {
    dependencies = mapFeatures features ([ core_foundation_0_2_3 core_foundation_sys_0_2_3 libc_0_2_40 security_framework_sys_0_1_16 ]);
    features = mkFeatures (features.security_framework_0_1_16 or {});
  };
  security_framework_0_1_16_features = f: updateFeatures f (rec {
    core_foundation_0_2_3.default = true;
    core_foundation_sys_0_2_3.default = true;
    libc_0_2_40.default = true;
    security_framework_0_1_16.OSX_10_10 =
      (f.security_framework_0_1_16.OSX_10_10 or false) ||
      (f.security_framework_0_1_16.OSX_10_11 or false) ||
      (security_framework_0_1_16.OSX_10_11 or false);
    security_framework_0_1_16.OSX_10_11 =
      (f.security_framework_0_1_16.OSX_10_11 or false) ||
      (f.security_framework_0_1_16.OSX_10_12 or false) ||
      (security_framework_0_1_16.OSX_10_12 or false);
    security_framework_0_1_16.OSX_10_8 =
      (f.security_framework_0_1_16.OSX_10_8 or false) ||
      (f.security_framework_0_1_16.OSX_10_9 or false) ||
      (security_framework_0_1_16.OSX_10_9 or false);
    security_framework_0_1_16.OSX_10_9 =
      (f.security_framework_0_1_16.OSX_10_9 or false) ||
      (f.security_framework_0_1_16.OSX_10_10 or false) ||
      (security_framework_0_1_16.OSX_10_10 or false);
    security_framework_0_1_16.default = (f.security_framework_0_1_16.default or true);
    security_framework_sys_0_1_16.OSX_10_10 =
      (f.security_framework_sys_0_1_16.OSX_10_10 or false) ||
      (security_framework_0_1_16.OSX_10_10 or false) ||
      (f.security_framework_0_1_16.OSX_10_10 or false);
    security_framework_sys_0_1_16.OSX_10_11 =
      (f.security_framework_sys_0_1_16.OSX_10_11 or false) ||
      (security_framework_0_1_16.OSX_10_11 or false) ||
      (f.security_framework_0_1_16.OSX_10_11 or false) ||
      (security_framework_0_1_16.OSX_10_12 or false) ||
      (f.security_framework_0_1_16.OSX_10_12 or false);
    security_framework_sys_0_1_16.OSX_10_8 =
      (f.security_framework_sys_0_1_16.OSX_10_8 or false) ||
      (security_framework_0_1_16.OSX_10_8 or false) ||
      (f.security_framework_0_1_16.OSX_10_8 or false);
    security_framework_sys_0_1_16.OSX_10_9 =
      (f.security_framework_sys_0_1_16.OSX_10_9 or false) ||
      (security_framework_0_1_16.OSX_10_9 or false) ||
      (f.security_framework_0_1_16.OSX_10_9 or false);
    security_framework_sys_0_1_16.default = true;
  }) [ core_foundation_0_2_3_features core_foundation_sys_0_2_3_features libc_0_2_40_features security_framework_sys_0_1_16_features ];
  security_framework_sys_0_1_16 = { features?(security_framework_sys_0_1_16_features {}) }: security_framework_sys_0_1_16_ {
    dependencies = mapFeatures features ([ core_foundation_sys_0_2_3 libc_0_2_40 ]);
    features = mkFeatures (features.security_framework_sys_0_1_16 or {});
  };
  security_framework_sys_0_1_16_features = f: updateFeatures f (rec {
    core_foundation_sys_0_2_3.default = true;
    libc_0_2_40.default = true;
    security_framework_sys_0_1_16.OSX_10_10 =
      (f.security_framework_sys_0_1_16.OSX_10_10 or false) ||
      (f.security_framework_sys_0_1_16.OSX_10_11 or false) ||
      (security_framework_sys_0_1_16.OSX_10_11 or false);
    security_framework_sys_0_1_16.OSX_10_11 =
      (f.security_framework_sys_0_1_16.OSX_10_11 or false) ||
      (f.security_framework_sys_0_1_16.OSX_10_12 or false) ||
      (security_framework_sys_0_1_16.OSX_10_12 or false);
    security_framework_sys_0_1_16.OSX_10_8 =
      (f.security_framework_sys_0_1_16.OSX_10_8 or false) ||
      (f.security_framework_sys_0_1_16.OSX_10_9 or false) ||
      (security_framework_sys_0_1_16.OSX_10_9 or false);
    security_framework_sys_0_1_16.OSX_10_9 =
      (f.security_framework_sys_0_1_16.OSX_10_9 or false) ||
      (f.security_framework_sys_0_1_16.OSX_10_10 or false) ||
      (security_framework_sys_0_1_16.OSX_10_10 or false);
    security_framework_sys_0_1_16.default = (f.security_framework_sys_0_1_16.default or true);
  }) [ core_foundation_sys_0_2_3_features libc_0_2_40_features ];
  semver_0_8_0 = { features?(semver_0_8_0_features {}) }: semver_0_8_0_ {
    dependencies = mapFeatures features ([ semver_parser_0_7_0 ]
      ++ (if features.semver_0_8_0.serde or false then [ serde_1_0_43 ] else []));
    features = mkFeatures (features.semver_0_8_0 or {});
  };
  semver_0_8_0_features = f: updateFeatures f (rec {
    semver_0_8_0.default = (f.semver_0_8_0.default or true);
    semver_0_8_0.serde =
      (f.semver_0_8_0.serde or false) ||
      (f.semver_0_8_0.ci or false) ||
      (semver_0_8_0.ci or false);
    semver_parser_0_7_0.default = true;
    serde_1_0_43.default = true;
  }) [ semver_parser_0_7_0_features serde_1_0_43_features ];
  semver_parser_0_7_0 = { features?(semver_parser_0_7_0_features {}) }: semver_parser_0_7_0_ {};
  semver_parser_0_7_0_features = f: updateFeatures f (rec {
    semver_parser_0_7_0.default = (f.semver_parser_0_7_0.default or true);
  }) [];
  serde_1_0_43 = { features?(serde_1_0_43_features {}) }: serde_1_0_43_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.serde_1_0_43 or {});
  };
  serde_1_0_43_features = f: updateFeatures f (rec {
    serde_1_0_43.default = (f.serde_1_0_43.default or true);
    serde_1_0_43.serde_derive =
      (f.serde_1_0_43.serde_derive or false) ||
      (f.serde_1_0_43.derive or false) ||
      (serde_1_0_43.derive or false) ||
      (f.serde_1_0_43.playground or false) ||
      (serde_1_0_43.playground or false);
    serde_1_0_43.std =
      (f.serde_1_0_43.std or false) ||
      (f.serde_1_0_43.default or false) ||
      (serde_1_0_43.default or false);
    serde_1_0_43.unstable =
      (f.serde_1_0_43.unstable or false) ||
      (f.serde_1_0_43.alloc or false) ||
      (serde_1_0_43.alloc or false);
  }) [];
  serde_derive_1_0_43 = { features?(serde_derive_1_0_43_features {}) }: serde_derive_1_0_43_ {
    dependencies = mapFeatures features ([ proc_macro2_0_3_8 quote_0_5_2 serde_derive_internals_0_23_1 syn_0_13_4 ]);
    features = mkFeatures (features.serde_derive_1_0_43 or {});
  };
  serde_derive_1_0_43_features = f: updateFeatures f (rec {
    proc_macro2_0_3_8.default = true;
    quote_0_5_2.default = true;
    serde_derive_1_0_43.default = (f.serde_derive_1_0_43.default or true);
    serde_derive_internals_0_23_1.default = (f.serde_derive_internals_0_23_1.default or false);
    syn_0_13_4.default = true;
    syn_0_13_4.visit = true;
  }) [ proc_macro2_0_3_8_features quote_0_5_2_features serde_derive_internals_0_23_1_features syn_0_13_4_features ];
  serde_derive_internals_0_23_1 = { features?(serde_derive_internals_0_23_1_features {}) }: serde_derive_internals_0_23_1_ {
    dependencies = mapFeatures features ([ proc_macro2_0_3_8 syn_0_13_4 ]);
  };
  serde_derive_internals_0_23_1_features = f: updateFeatures f (rec {
    proc_macro2_0_3_8.default = true;
    serde_derive_internals_0_23_1.default = (f.serde_derive_internals_0_23_1.default or true);
    syn_0_13_4.clone-impls = true;
    syn_0_13_4.default = (f.syn_0_13_4.default or false);
    syn_0_13_4.derive = true;
    syn_0_13_4.parsing = true;
  }) [ proc_macro2_0_3_8_features syn_0_13_4_features ];
  serde_json_1_0_16 = { features?(serde_json_1_0_16_features {}) }: serde_json_1_0_16_ {
    dependencies = mapFeatures features ([ dtoa_0_4_2 itoa_0_4_1 serde_1_0_43 ]);
    features = mkFeatures (features.serde_json_1_0_16 or {});
  };
  serde_json_1_0_16_features = f: updateFeatures f (rec {
    dtoa_0_4_2.default = true;
    itoa_0_4_1.default = true;
    serde_1_0_43.default = true;
    serde_json_1_0_16.default = (f.serde_json_1_0_16.default or true);
    serde_json_1_0_16.linked-hash-map =
      (f.serde_json_1_0_16.linked-hash-map or false) ||
      (f.serde_json_1_0_16.preserve_order or false) ||
      (serde_json_1_0_16.preserve_order or false);
  }) [ dtoa_0_4_2_features itoa_0_4_1_features serde_1_0_43_features ];
  serde_urlencoded_0_5_1 = { features?(serde_urlencoded_0_5_1_features {}) }: serde_urlencoded_0_5_1_ {
    dependencies = mapFeatures features ([ dtoa_0_4_2 itoa_0_3_4 serde_1_0_43 url_1_7_0 ]);
  };
  serde_urlencoded_0_5_1_features = f: updateFeatures f (rec {
    dtoa_0_4_2.default = true;
    itoa_0_3_4.default = true;
    serde_1_0_43.default = true;
    serde_urlencoded_0_5_1.default = (f.serde_urlencoded_0_5_1.default or true);
    url_1_7_0.default = true;
  }) [ dtoa_0_4_2_features itoa_0_3_4_features serde_1_0_43_features url_1_7_0_features ];
  sha1_0_6_0 = { features?(sha1_0_6_0_features {}) }: sha1_0_6_0_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.sha1_0_6_0 or {});
  };
  sha1_0_6_0_features = f: updateFeatures f (rec {
    sha1_0_6_0.default = (f.sha1_0_6_0.default or true);
  }) [];
  siphasher_0_2_2 = { features?(siphasher_0_2_2_features {}) }: siphasher_0_2_2_ {
    dependencies = mapFeatures features ([]);
  };
  siphasher_0_2_2_features = f: updateFeatures f (rec {
    siphasher_0_2_2.default = (f.siphasher_0_2_2.default or true);
  }) [];
  skeptic_0_13_2 = { features?(skeptic_0_13_2_features {}) }: skeptic_0_13_2_ {
    dependencies = mapFeatures features ([ bytecount_0_2_0 cargo_metadata_0_3_3 error_chain_0_11_0 glob_0_2_11 pulldown_cmark_0_1_2 serde_json_1_0_16 tempdir_0_3_7 walkdir_1_0_7 ]);
  };
  skeptic_0_13_2_features = f: updateFeatures f (rec {
    bytecount_0_2_0.default = true;
    cargo_metadata_0_3_3.default = true;
    error_chain_0_11_0.default = (f.error_chain_0_11_0.default or false);
    glob_0_2_11.default = true;
    pulldown_cmark_0_1_2.default = (f.pulldown_cmark_0_1_2.default or false);
    serde_json_1_0_16.default = true;
    skeptic_0_13_2.default = (f.skeptic_0_13_2.default or true);
    tempdir_0_3_7.default = true;
    walkdir_1_0_7.default = true;
  }) [ bytecount_0_2_0_features cargo_metadata_0_3_3_features error_chain_0_11_0_features glob_0_2_11_features pulldown_cmark_0_1_2_features serde_json_1_0_16_features tempdir_0_3_7_features walkdir_1_0_7_features ];
  slab_0_3_0 = { features?(slab_0_3_0_features {}) }: slab_0_3_0_ {};
  slab_0_3_0_features = f: updateFeatures f (rec {
    slab_0_3_0.default = (f.slab_0_3_0.default or true);
  }) [];
  slab_0_4_0 = { features?(slab_0_4_0_features {}) }: slab_0_4_0_ {};
  slab_0_4_0_features = f: updateFeatures f (rec {
    slab_0_4_0.default = (f.slab_0_4_0.default or true);
  }) [];
  slug_0_1_3 = { features?(slug_0_1_3_features {}) }: slug_0_1_3_ {
    dependencies = mapFeatures features ([ unidecode_0_3_0 ]);
  };
  slug_0_1_3_features = f: updateFeatures f (rec {
    slug_0_1_3.default = (f.slug_0_1_3.default or true);
    unidecode_0_3_0.default = true;
  }) [ unidecode_0_3_0_features ];
  smallvec_0_2_1 = { features?(smallvec_0_2_1_features {}) }: smallvec_0_2_1_ {};
  smallvec_0_2_1_features = f: updateFeatures f (rec {
    smallvec_0_2_1.default = (f.smallvec_0_2_1.default or true);
  }) [];
  smallvec_0_6_1 = { features?(smallvec_0_6_1_features {}) }: smallvec_0_6_1_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.smallvec_0_6_1 or {});
  };
  smallvec_0_6_1_features = f: updateFeatures f (rec {
    smallvec_0_6_1.default = (f.smallvec_0_6_1.default or true);
    smallvec_0_6_1.std =
      (f.smallvec_0_6_1.std or false) ||
      (f.smallvec_0_6_1.default or false) ||
      (smallvec_0_6_1.default or false);
  }) [];
  socket2_0_3_5 = { features?(socket2_0_3_5_features {}) }: socket2_0_3_5_ {
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ cfg_if_0_1_2 libc_0_2_40 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else []);
    features = mkFeatures (features.socket2_0_3_5 or {});
  };
  socket2_0_3_5_features = f: updateFeatures f (rec {
    cfg_if_0_1_2.default = true;
    libc_0_2_40.default = true;
    socket2_0_3_5.default = (f.socket2_0_3_5.default or true);
    winapi_0_3_4.default = true;
    winapi_0_3_4.handleapi = true;
    winapi_0_3_4.minwindef = true;
    winapi_0_3_4.ws2def = true;
    winapi_0_3_4.ws2ipdef = true;
    winapi_0_3_4.ws2tcpip = true;
  }) [ cfg_if_0_1_2_features libc_0_2_40_features winapi_0_3_4_features ];
  stable_deref_trait_1_0_0 = { features?(stable_deref_trait_1_0_0_features {}) }: stable_deref_trait_1_0_0_ {
    features = mkFeatures (features.stable_deref_trait_1_0_0 or {});
  };
  stable_deref_trait_1_0_0_features = f: updateFeatures f (rec {
    stable_deref_trait_1_0_0.default = (f.stable_deref_trait_1_0_0.default or true);
    stable_deref_trait_1_0_0.std =
      (f.stable_deref_trait_1_0_0.std or false) ||
      (f.stable_deref_trait_1_0_0.default or false) ||
      (stable_deref_trait_1_0_0.default or false);
  }) [];
  string_0_1_0 = { features?(string_0_1_0_features {}) }: string_0_1_0_ {};
  string_0_1_0_features = f: updateFeatures f (rec {
    string_0_1_0.default = (f.string_0_1_0.default or true);
  }) [];
  strsim_0_7_0 = { features?(strsim_0_7_0_features {}) }: strsim_0_7_0_ {};
  strsim_0_7_0_features = f: updateFeatures f (rec {
    strsim_0_7_0.default = (f.strsim_0_7_0.default or true);
  }) [];
  syn_0_11_11 = { features?(syn_0_11_11_features {}) }: syn_0_11_11_ {
    dependencies = mapFeatures features ([ ]
      ++ (if features.syn_0_11_11.quote or false then [ quote_0_3_15 ] else [])
      ++ (if features.syn_0_11_11.synom or false then [ synom_0_11_3 ] else [])
      ++ (if features.syn_0_11_11.unicode-xid or false then [ unicode_xid_0_0_4 ] else []));
    features = mkFeatures (features.syn_0_11_11 or {});
  };
  syn_0_11_11_features = f: updateFeatures f (rec {
    quote_0_3_15.default = true;
    syn_0_11_11.default = (f.syn_0_11_11.default or true);
    syn_0_11_11.parsing =
      (f.syn_0_11_11.parsing or false) ||
      (f.syn_0_11_11.default or false) ||
      (syn_0_11_11.default or false);
    syn_0_11_11.printing =
      (f.syn_0_11_11.printing or false) ||
      (f.syn_0_11_11.default or false) ||
      (syn_0_11_11.default or false);
    syn_0_11_11.quote =
      (f.syn_0_11_11.quote or false) ||
      (f.syn_0_11_11.printing or false) ||
      (syn_0_11_11.printing or false);
    syn_0_11_11.synom =
      (f.syn_0_11_11.synom or false) ||
      (f.syn_0_11_11.parsing or false) ||
      (syn_0_11_11.parsing or false);
    syn_0_11_11.unicode-xid =
      (f.syn_0_11_11.unicode-xid or false) ||
      (f.syn_0_11_11.parsing or false) ||
      (syn_0_11_11.parsing or false);
    synom_0_11_3.default = true;
    unicode_xid_0_0_4.default = true;
  }) [ quote_0_3_15_features synom_0_11_3_features unicode_xid_0_0_4_features ];
  syn_0_12_15 = { features?(syn_0_12_15_features {}) }: syn_0_12_15_ {
    dependencies = mapFeatures features ([ proc_macro2_0_2_3 unicode_xid_0_1_0 ]
      ++ (if features.syn_0_12_15.quote or false then [ quote_0_4_2 ] else []));
    features = mkFeatures (features.syn_0_12_15 or {});
  };
  syn_0_12_15_features = f: updateFeatures f (rec {
    proc_macro2_0_2_3.default = true;
    quote_0_4_2.default = true;
    syn_0_12_15.clone-impls =
      (f.syn_0_12_15.clone-impls or false) ||
      (f.syn_0_12_15.default or false) ||
      (syn_0_12_15.default or false);
    syn_0_12_15.default = (f.syn_0_12_15.default or true);
    syn_0_12_15.derive =
      (f.syn_0_12_15.derive or false) ||
      (f.syn_0_12_15.default or false) ||
      (syn_0_12_15.default or false);
    syn_0_12_15.parsing =
      (f.syn_0_12_15.parsing or false) ||
      (f.syn_0_12_15.default or false) ||
      (syn_0_12_15.default or false);
    syn_0_12_15.printing =
      (f.syn_0_12_15.printing or false) ||
      (f.syn_0_12_15.default or false) ||
      (syn_0_12_15.default or false);
    syn_0_12_15.quote =
      (f.syn_0_12_15.quote or false) ||
      (f.syn_0_12_15.printing or false) ||
      (syn_0_12_15.printing or false);
    unicode_xid_0_1_0.default = true;
  }) [ proc_macro2_0_2_3_features quote_0_4_2_features unicode_xid_0_1_0_features ];
  syn_0_13_4 = { features?(syn_0_13_4_features {}) }: syn_0_13_4_ {
    dependencies = mapFeatures features ([ proc_macro2_0_3_8 unicode_xid_0_1_0 ]
      ++ (if features.syn_0_13_4.quote or false then [ quote_0_5_2 ] else []));
    features = mkFeatures (features.syn_0_13_4 or {});
  };
  syn_0_13_4_features = f: updateFeatures f (rec {
    proc_macro2_0_3_8.default = (f.proc_macro2_0_3_8.default or false);
    proc_macro2_0_3_8.proc-macro =
      (f.proc_macro2_0_3_8.proc-macro or false) ||
      (syn_0_13_4.proc-macro or false) ||
      (f.syn_0_13_4.proc-macro or false);
    quote_0_5_2.default = (f.quote_0_5_2.default or false);
    quote_0_5_2.proc-macro =
      (f.quote_0_5_2.proc-macro or false) ||
      (syn_0_13_4.proc-macro or false) ||
      (f.syn_0_13_4.proc-macro or false);
    syn_0_13_4.clone-impls =
      (f.syn_0_13_4.clone-impls or false) ||
      (f.syn_0_13_4.default or false) ||
      (syn_0_13_4.default or false);
    syn_0_13_4.default = (f.syn_0_13_4.default or true);
    syn_0_13_4.derive =
      (f.syn_0_13_4.derive or false) ||
      (f.syn_0_13_4.default or false) ||
      (syn_0_13_4.default or false);
    syn_0_13_4.parsing =
      (f.syn_0_13_4.parsing or false) ||
      (f.syn_0_13_4.default or false) ||
      (syn_0_13_4.default or false);
    syn_0_13_4.printing =
      (f.syn_0_13_4.printing or false) ||
      (f.syn_0_13_4.default or false) ||
      (syn_0_13_4.default or false);
    syn_0_13_4.proc-macro =
      (f.syn_0_13_4.proc-macro or false) ||
      (f.syn_0_13_4.default or false) ||
      (syn_0_13_4.default or false);
    syn_0_13_4.quote =
      (f.syn_0_13_4.quote or false) ||
      (f.syn_0_13_4.printing or false) ||
      (syn_0_13_4.printing or false);
    unicode_xid_0_1_0.default = true;
  }) [ proc_macro2_0_3_8_features quote_0_5_2_features unicode_xid_0_1_0_features ];
  synom_0_11_3 = { features?(synom_0_11_3_features {}) }: synom_0_11_3_ {
    dependencies = mapFeatures features ([ unicode_xid_0_0_4 ]);
  };
  synom_0_11_3_features = f: updateFeatures f (rec {
    synom_0_11_3.default = (f.synom_0_11_3.default or true);
    unicode_xid_0_0_4.default = true;
  }) [ unicode_xid_0_0_4_features ];
  synstructure_0_6_1 = { features?(synstructure_0_6_1_features {}) }: synstructure_0_6_1_ {
    dependencies = mapFeatures features ([ quote_0_3_15 syn_0_11_11 ]);
    features = mkFeatures (features.synstructure_0_6_1 or {});
  };
  synstructure_0_6_1_features = f: updateFeatures f (rec {
    quote_0_3_15.default = true;
    syn_0_11_11.default = true;
    syn_0_11_11.visit = true;
    synstructure_0_6_1.default = (f.synstructure_0_6_1.default or true);
  }) [ quote_0_3_15_features syn_0_11_11_features ];
  take_0_1_0 = { features?(take_0_1_0_features {}) }: take_0_1_0_ {};
  take_0_1_0_features = f: updateFeatures f (rec {
    take_0_1_0.default = (f.take_0_1_0.default or true);
  }) [];
  tempdir_0_3_7 = { features?(tempdir_0_3_7_features {}) }: tempdir_0_3_7_ {
    dependencies = mapFeatures features ([ rand_0_4_2 remove_dir_all_0_5_1 ]);
  };
  tempdir_0_3_7_features = f: updateFeatures f (rec {
    rand_0_4_2.default = true;
    remove_dir_all_0_5_1.default = true;
    tempdir_0_3_7.default = (f.tempdir_0_3_7.default or true);
  }) [ rand_0_4_2_features remove_dir_all_0_5_1_features ];
  tera_0_11_7 = { features?(tera_0_11_7_features {}) }: tera_0_11_7_ {
    dependencies = mapFeatures features ([ chrono_0_4_2 error_chain_0_11_0 glob_0_2_11 humansize_1_1_0 lazy_static_1_0_0 pest_1_0_6 pest_derive_1_0_7 regex_0_2_11 serde_1_0_43 serde_json_1_0_16 slug_0_1_3 url_1_7_0 ]);
  };
  tera_0_11_7_features = f: updateFeatures f (rec {
    chrono_0_4_2.default = true;
    error_chain_0_11_0.default = true;
    glob_0_2_11.default = true;
    humansize_1_1_0.default = true;
    lazy_static_1_0_0.default = true;
    pest_1_0_6.default = true;
    pest_derive_1_0_7.default = true;
    regex_0_2_11.default = true;
    serde_1_0_43.default = true;
    serde_json_1_0_16.default = true;
    slug_0_1_3.default = true;
    tera_0_11_7.default = (f.tera_0_11_7.default or true);
    url_1_7_0.default = true;
  }) [ chrono_0_4_2_features error_chain_0_11_0_features glob_0_2_11_features humansize_1_1_0_features lazy_static_1_0_0_features pest_1_0_6_features pest_derive_1_0_7_features regex_0_2_11_features serde_1_0_43_features serde_json_1_0_16_features slug_0_1_3_features url_1_7_0_features ];
  termcolor_0_3_6 = { features?(termcolor_0_3_6_features {}) }: termcolor_0_3_6_ {
    dependencies = (if kernel == "windows" then mapFeatures features ([ wincolor_0_1_6 ]) else []);
  };
  termcolor_0_3_6_features = f: updateFeatures f (rec {
    termcolor_0_3_6.default = (f.termcolor_0_3_6.default or true);
    wincolor_0_1_6.default = true;
  }) [ wincolor_0_1_6_features ];
  termion_1_5_1 = { features?(termion_1_5_1_features {}) }: termion_1_5_1_ {
    dependencies = (if !(kernel == "redox") then mapFeatures features ([ libc_0_2_40 ]) else [])
      ++ (if kernel == "redox" then mapFeatures features ([ redox_syscall_0_1_37 redox_termios_0_1_1 ]) else []);
  };
  termion_1_5_1_features = f: updateFeatures f (rec {
    libc_0_2_40.default = true;
    redox_syscall_0_1_37.default = true;
    redox_termios_0_1_1.default = true;
    termion_1_5_1.default = (f.termion_1_5_1.default or true);
  }) [ libc_0_2_40_features redox_syscall_0_1_37_features redox_termios_0_1_1_features ];
  textwrap_0_9_0 = { features?(textwrap_0_9_0_features {}) }: textwrap_0_9_0_ {
    dependencies = mapFeatures features ([ unicode_width_0_1_4 ]);
  };
  textwrap_0_9_0_features = f: updateFeatures f (rec {
    textwrap_0_9_0.default = (f.textwrap_0_9_0.default or true);
    unicode_width_0_1_4.default = true;
  }) [ unicode_width_0_1_4_features ];
  thread_local_0_3_5 = { features?(thread_local_0_3_5_features {}) }: thread_local_0_3_5_ {
    dependencies = mapFeatures features ([ lazy_static_1_0_0 unreachable_1_0_0 ]);
  };
  thread_local_0_3_5_features = f: updateFeatures f (rec {
    lazy_static_1_0_0.default = true;
    thread_local_0_3_5.default = (f.thread_local_0_3_5.default or true);
    unreachable_1_0_0.default = true;
  }) [ lazy_static_1_0_0_features unreachable_1_0_0_features ];
  time_0_1_39 = { features?(time_0_1_39_features {}) }: time_0_1_39_ {
    dependencies = mapFeatures features ([ libc_0_2_40 ])
      ++ (if kernel == "redox" then mapFeatures features ([ redox_syscall_0_1_37 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else []);
  };
  time_0_1_39_features = f: updateFeatures f (rec {
    libc_0_2_40.default = true;
    redox_syscall_0_1_37.default = true;
    time_0_1_39.default = (f.time_0_1_39.default or true);
    winapi_0_3_4.default = true;
    winapi_0_3_4.minwinbase = true;
    winapi_0_3_4.minwindef = true;
    winapi_0_3_4.ntdef = true;
    winapi_0_3_4.profileapi = true;
    winapi_0_3_4.std = true;
    winapi_0_3_4.sysinfoapi = true;
    winapi_0_3_4.timezoneapi = true;
  }) [ libc_0_2_40_features redox_syscall_0_1_37_features winapi_0_3_4_features ];
  tokio_0_1_5 = { features?(tokio_0_1_5_features {}) }: tokio_0_1_5_ {
    dependencies = mapFeatures features ([ futures_0_1_21 mio_0_6_14 tokio_executor_0_1_2 tokio_io_0_1_6 tokio_reactor_0_1_1 tokio_tcp_0_1_0 tokio_threadpool_0_1_2 tokio_timer_0_2_1 tokio_udp_0_1_0 ]);
    features = mkFeatures (features.tokio_0_1_5 or {});
  };
  tokio_0_1_5_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    mio_0_6_14.default = true;
    tokio_0_1_5.default = (f.tokio_0_1_5.default or true);
    tokio_0_1_5.futures2 =
      (f.tokio_0_1_5.futures2 or false) ||
      (f.tokio_0_1_5.unstable-futures or false) ||
      (tokio_0_1_5.unstable-futures or false);
    tokio_executor_0_1_2.default = true;
    tokio_executor_0_1_2.unstable-futures =
      (f.tokio_executor_0_1_2.unstable-futures or false) ||
      (tokio_0_1_5.unstable-futures or false) ||
      (f.tokio_0_1_5.unstable-futures or false);
    tokio_io_0_1_6.default = true;
    tokio_reactor_0_1_1.default = true;
    tokio_reactor_0_1_1.unstable-futures =
      (f.tokio_reactor_0_1_1.unstable-futures or false) ||
      (tokio_0_1_5.unstable-futures or false) ||
      (f.tokio_0_1_5.unstable-futures or false);
    tokio_tcp_0_1_0.default = true;
    tokio_tcp_0_1_0.unstable-futures =
      (f.tokio_tcp_0_1_0.unstable-futures or false) ||
      (tokio_0_1_5.unstable-futures or false) ||
      (f.tokio_0_1_5.unstable-futures or false);
    tokio_threadpool_0_1_2.default = true;
    tokio_threadpool_0_1_2.unstable-futures =
      (f.tokio_threadpool_0_1_2.unstable-futures or false) ||
      (tokio_0_1_5.unstable-futures or false) ||
      (f.tokio_0_1_5.unstable-futures or false);
    tokio_timer_0_2_1.default = true;
    tokio_udp_0_1_0.default = true;
    tokio_udp_0_1_0.unstable-futures =
      (f.tokio_udp_0_1_0.unstable-futures or false) ||
      (tokio_0_1_5.unstable-futures or false) ||
      (f.tokio_0_1_5.unstable-futures or false);
  }) [ futures_0_1_21_features mio_0_6_14_features tokio_executor_0_1_2_features tokio_io_0_1_6_features tokio_reactor_0_1_1_features tokio_tcp_0_1_0_features tokio_threadpool_0_1_2_features tokio_timer_0_2_1_features tokio_udp_0_1_0_features ];
  tokio_core_0_1_17 = { features?(tokio_core_0_1_17_features {}) }: tokio_core_0_1_17_ {
    dependencies = mapFeatures features ([ bytes_0_4_7 futures_0_1_21 iovec_0_1_2 log_0_4_1 mio_0_6_14 scoped_tls_0_1_1 tokio_0_1_5 tokio_executor_0_1_2 tokio_io_0_1_6 tokio_reactor_0_1_1 tokio_timer_0_2_1 ]);
  };
  tokio_core_0_1_17_features = f: updateFeatures f (rec {
    bytes_0_4_7.default = true;
    futures_0_1_21.default = true;
    iovec_0_1_2.default = true;
    log_0_4_1.default = true;
    mio_0_6_14.default = true;
    scoped_tls_0_1_1.default = true;
    tokio_0_1_5.default = true;
    tokio_core_0_1_17.default = (f.tokio_core_0_1_17.default or true);
    tokio_executor_0_1_2.default = true;
    tokio_io_0_1_6.default = true;
    tokio_reactor_0_1_1.default = true;
    tokio_timer_0_2_1.default = true;
  }) [ bytes_0_4_7_features futures_0_1_21_features iovec_0_1_2_features log_0_4_1_features mio_0_6_14_features scoped_tls_0_1_1_features tokio_0_1_5_features tokio_executor_0_1_2_features tokio_io_0_1_6_features tokio_reactor_0_1_1_features tokio_timer_0_2_1_features ];
  tokio_executor_0_1_2 = { features?(tokio_executor_0_1_2_features {}) }: tokio_executor_0_1_2_ {
    dependencies = mapFeatures features ([ futures_0_1_21 ]);
    features = mkFeatures (features.tokio_executor_0_1_2 or {});
  };
  tokio_executor_0_1_2_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    tokio_executor_0_1_2.default = (f.tokio_executor_0_1_2.default or true);
    tokio_executor_0_1_2.futures2 =
      (f.tokio_executor_0_1_2.futures2 or false) ||
      (f.tokio_executor_0_1_2.unstable-futures or false) ||
      (tokio_executor_0_1_2.unstable-futures or false);
  }) [ futures_0_1_21_features ];
  tokio_io_0_1_6 = { features?(tokio_io_0_1_6_features {}) }: tokio_io_0_1_6_ {
    dependencies = mapFeatures features ([ bytes_0_4_7 futures_0_1_21 log_0_4_1 ]);
  };
  tokio_io_0_1_6_features = f: updateFeatures f (rec {
    bytes_0_4_7.default = true;
    futures_0_1_21.default = true;
    log_0_4_1.default = true;
    tokio_io_0_1_6.default = (f.tokio_io_0_1_6.default or true);
  }) [ bytes_0_4_7_features futures_0_1_21_features log_0_4_1_features ];
  tokio_proto_0_1_1 = { features?(tokio_proto_0_1_1_features {}) }: tokio_proto_0_1_1_ {
    dependencies = mapFeatures features ([ futures_0_1_21 log_0_3_9 net2_0_2_32 rand_0_3_22 slab_0_3_0 smallvec_0_2_1 take_0_1_0 tokio_core_0_1_17 tokio_io_0_1_6 tokio_service_0_1_0 ]);
  };
  tokio_proto_0_1_1_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    log_0_3_9.default = true;
    net2_0_2_32.default = true;
    rand_0_3_22.default = true;
    slab_0_3_0.default = true;
    smallvec_0_2_1.default = true;
    take_0_1_0.default = true;
    tokio_core_0_1_17.default = true;
    tokio_io_0_1_6.default = true;
    tokio_proto_0_1_1.default = (f.tokio_proto_0_1_1.default or true);
    tokio_service_0_1_0.default = true;
  }) [ futures_0_1_21_features log_0_3_9_features net2_0_2_32_features rand_0_3_22_features slab_0_3_0_features smallvec_0_2_1_features take_0_1_0_features tokio_core_0_1_17_features tokio_io_0_1_6_features tokio_service_0_1_0_features ];
  tokio_reactor_0_1_1 = { features?(tokio_reactor_0_1_1_features {}) }: tokio_reactor_0_1_1_ {
    dependencies = mapFeatures features ([ futures_0_1_21 log_0_4_1 mio_0_6_14 slab_0_4_0 tokio_executor_0_1_2 tokio_io_0_1_6 ]);
    features = mkFeatures (features.tokio_reactor_0_1_1 or {});
  };
  tokio_reactor_0_1_1_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    log_0_4_1.default = true;
    mio_0_6_14.default = true;
    slab_0_4_0.default = true;
    tokio_executor_0_1_2.default = true;
    tokio_io_0_1_6.default = true;
    tokio_reactor_0_1_1.default = (f.tokio_reactor_0_1_1.default or true);
    tokio_reactor_0_1_1.futures2 =
      (f.tokio_reactor_0_1_1.futures2 or false) ||
      (f.tokio_reactor_0_1_1.unstable-futures or false) ||
      (tokio_reactor_0_1_1.unstable-futures or false);
  }) [ futures_0_1_21_features log_0_4_1_features mio_0_6_14_features slab_0_4_0_features tokio_executor_0_1_2_features tokio_io_0_1_6_features ];
  tokio_service_0_1_0 = { features?(tokio_service_0_1_0_features {}) }: tokio_service_0_1_0_ {
    dependencies = mapFeatures features ([ futures_0_1_21 ]);
  };
  tokio_service_0_1_0_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    tokio_service_0_1_0.default = (f.tokio_service_0_1_0.default or true);
  }) [ futures_0_1_21_features ];
  tokio_signal_0_1_5 = { features?(tokio_signal_0_1_5_features {}) }: tokio_signal_0_1_5_ {
    dependencies = mapFeatures features ([ futures_0_1_21 mio_0_6_14 tokio_core_0_1_17 tokio_io_0_1_6 ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([ libc_0_2_40 mio_uds_0_6_4 ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else []);
  };
  tokio_signal_0_1_5_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    libc_0_2_40.default = true;
    mio_0_6_14.default = true;
    mio_uds_0_6_4.default = true;
    tokio_core_0_1_17.default = true;
    tokio_io_0_1_6.default = true;
    tokio_signal_0_1_5.default = (f.tokio_signal_0_1_5.default or true);
    winapi_0_3_4.default = true;
    winapi_0_3_4.minwindef = true;
    winapi_0_3_4.wincon = true;
  }) [ futures_0_1_21_features mio_0_6_14_features tokio_core_0_1_17_features tokio_io_0_1_6_features libc_0_2_40_features mio_uds_0_6_4_features winapi_0_3_4_features ];
  tokio_tcp_0_1_0 = { features?(tokio_tcp_0_1_0_features {}) }: tokio_tcp_0_1_0_ {
    dependencies = mapFeatures features ([ bytes_0_4_7 futures_0_1_21 iovec_0_1_2 mio_0_6_14 tokio_io_0_1_6 tokio_reactor_0_1_1 ]);
    features = mkFeatures (features.tokio_tcp_0_1_0 or {});
  };
  tokio_tcp_0_1_0_features = f: updateFeatures f (rec {
    bytes_0_4_7.default = true;
    futures_0_1_21.default = true;
    iovec_0_1_2.default = true;
    mio_0_6_14.default = true;
    tokio_io_0_1_6.default = true;
    tokio_reactor_0_1_1.default = true;
    tokio_tcp_0_1_0.default = (f.tokio_tcp_0_1_0.default or true);
    tokio_tcp_0_1_0.futures2 =
      (f.tokio_tcp_0_1_0.futures2 or false) ||
      (f.tokio_tcp_0_1_0.unstable-futures or false) ||
      (tokio_tcp_0_1_0.unstable-futures or false);
  }) [ bytes_0_4_7_features futures_0_1_21_features iovec_0_1_2_features mio_0_6_14_features tokio_io_0_1_6_features tokio_reactor_0_1_1_features ];
  tokio_threadpool_0_1_2 = { features?(tokio_threadpool_0_1_2_features {}) }: tokio_threadpool_0_1_2_ {
    dependencies = mapFeatures features ([ crossbeam_deque_0_3_0 futures_0_1_21 log_0_4_1 num_cpus_1_8_0 rand_0_4_2 tokio_executor_0_1_2 ]);
    features = mkFeatures (features.tokio_threadpool_0_1_2 or {});
  };
  tokio_threadpool_0_1_2_features = f: updateFeatures f (rec {
    crossbeam_deque_0_3_0.default = true;
    futures_0_1_21.default = true;
    log_0_4_1.default = true;
    num_cpus_1_8_0.default = true;
    rand_0_4_2.default = true;
    tokio_executor_0_1_2.default = true;
    tokio_executor_0_1_2.unstable-futures =
      (f.tokio_executor_0_1_2.unstable-futures or false) ||
      (tokio_threadpool_0_1_2.unstable-futures or false) ||
      (f.tokio_threadpool_0_1_2.unstable-futures or false);
    tokio_threadpool_0_1_2.default = (f.tokio_threadpool_0_1_2.default or true);
    tokio_threadpool_0_1_2.futures2 =
      (f.tokio_threadpool_0_1_2.futures2 or false) ||
      (f.tokio_threadpool_0_1_2.unstable-futures or false) ||
      (tokio_threadpool_0_1_2.unstable-futures or false);
  }) [ crossbeam_deque_0_3_0_features futures_0_1_21_features log_0_4_1_features num_cpus_1_8_0_features rand_0_4_2_features tokio_executor_0_1_2_features ];
  tokio_timer_0_2_1 = { features?(tokio_timer_0_2_1_features {}) }: tokio_timer_0_2_1_ {
    dependencies = mapFeatures features ([ futures_0_1_21 tokio_executor_0_1_2 ]);
  };
  tokio_timer_0_2_1_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    tokio_executor_0_1_2.default = true;
    tokio_timer_0_2_1.default = (f.tokio_timer_0_2_1.default or true);
  }) [ futures_0_1_21_features tokio_executor_0_1_2_features ];
  tokio_tls_0_1_4 = { features?(tokio_tls_0_1_4_features {}) }: tokio_tls_0_1_4_ {
    dependencies = mapFeatures features ([ futures_0_1_21 native_tls_0_1_5 tokio_core_0_1_17 tokio_io_0_1_6 ])
      ++ (if !(kernel == "darwin") && !(kernel == "windows") && !(kernel == "ios") then mapFeatures features ([]) else [])
      ++ (if kernel == "darwin" || kernel == "ios" then mapFeatures features ([]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([]) else []);
  };
  tokio_tls_0_1_4_features = f: updateFeatures f (rec {
    futures_0_1_21.default = true;
    native_tls_0_1_5.default = true;
    tokio_core_0_1_17.default = true;
    tokio_io_0_1_6.default = true;
    tokio_tls_0_1_4.default = (f.tokio_tls_0_1_4.default or true);
  }) [ futures_0_1_21_features native_tls_0_1_5_features tokio_core_0_1_17_features tokio_io_0_1_6_features ];
  tokio_udp_0_1_0 = { features?(tokio_udp_0_1_0_features {}) }: tokio_udp_0_1_0_ {
    dependencies = mapFeatures features ([ bytes_0_4_7 futures_0_1_21 log_0_4_1 mio_0_6_14 tokio_io_0_1_6 tokio_reactor_0_1_1 ]);
    features = mkFeatures (features.tokio_udp_0_1_0 or {});
  };
  tokio_udp_0_1_0_features = f: updateFeatures f (rec {
    bytes_0_4_7.default = true;
    futures_0_1_21.default = true;
    log_0_4_1.default = true;
    mio_0_6_14.default = true;
    tokio_io_0_1_6.default = true;
    tokio_reactor_0_1_1.default = true;
    tokio_udp_0_1_0.default = (f.tokio_udp_0_1_0.default or true);
    tokio_udp_0_1_0.futures2 =
      (f.tokio_udp_0_1_0.futures2 or false) ||
      (f.tokio_udp_0_1_0.unstable-futures or false) ||
      (tokio_udp_0_1_0.unstable-futures or false);
  }) [ bytes_0_4_7_features futures_0_1_21_features log_0_4_1_features mio_0_6_14_features tokio_io_0_1_6_features tokio_reactor_0_1_1_features ];
  trust_dns_proto_0_3_3 = { features?(trust_dns_proto_0_3_3_features {}) }: trust_dns_proto_0_3_3_ {
    dependencies = mapFeatures features ([ byteorder_1_2_2 error_chain_0_1_12 futures_0_1_21 idna_0_1_4 lazy_static_1_0_0 log_0_4_1 rand_0_4_2 tokio_core_0_1_17 tokio_io_0_1_6 url_1_7_0 ]);
    features = mkFeatures (features.trust_dns_proto_0_3_3 or {});
  };
  trust_dns_proto_0_3_3_features = f: updateFeatures f (rec {
    byteorder_1_2_2.default = true;
    error_chain_0_1_12.default = (f.error_chain_0_1_12.default or false);
    futures_0_1_21.default = true;
    idna_0_1_4.default = true;
    lazy_static_1_0_0.default = true;
    log_0_4_1.default = true;
    rand_0_4_2.default = true;
    tokio_core_0_1_17.default = true;
    tokio_io_0_1_6.default = true;
    trust_dns_proto_0_3_3.data-encoding =
      (f.trust_dns_proto_0_3_3.data-encoding or false) ||
      (f.trust_dns_proto_0_3_3.dnssec or false) ||
      (trust_dns_proto_0_3_3.dnssec or false);
    trust_dns_proto_0_3_3.default = (f.trust_dns_proto_0_3_3.default or true);
    trust_dns_proto_0_3_3.dnssec =
      (f.trust_dns_proto_0_3_3.dnssec or false) ||
      (f.trust_dns_proto_0_3_3.dnssec-openssl or false) ||
      (trust_dns_proto_0_3_3.dnssec-openssl or false) ||
      (f.trust_dns_proto_0_3_3.dnssec-ring or false) ||
      (trust_dns_proto_0_3_3.dnssec-ring or false);
    trust_dns_proto_0_3_3.openssl =
      (f.trust_dns_proto_0_3_3.openssl or false) ||
      (f.trust_dns_proto_0_3_3.dnssec-openssl or false) ||
      (trust_dns_proto_0_3_3.dnssec-openssl or false);
    trust_dns_proto_0_3_3.ring =
      (f.trust_dns_proto_0_3_3.ring or false) ||
      (f.trust_dns_proto_0_3_3.dnssec-ring or false) ||
      (trust_dns_proto_0_3_3.dnssec-ring or false);
    trust_dns_proto_0_3_3.untrusted =
      (f.trust_dns_proto_0_3_3.untrusted or false) ||
      (f.trust_dns_proto_0_3_3.dnssec-ring or false) ||
      (trust_dns_proto_0_3_3.dnssec-ring or false);
    url_1_7_0.default = true;
  }) [ byteorder_1_2_2_features error_chain_0_1_12_features futures_0_1_21_features idna_0_1_4_features lazy_static_1_0_0_features log_0_4_1_features rand_0_4_2_features tokio_core_0_1_17_features tokio_io_0_1_6_features url_1_7_0_features ];
  trust_dns_resolver_0_8_2 = { features?(trust_dns_resolver_0_8_2_features {}) }: trust_dns_resolver_0_8_2_ {
    dependencies = mapFeatures features ([ error_chain_0_1_12 futures_0_1_21 lazy_static_1_0_0 log_0_4_1 lru_cache_0_1_1 resolv_conf_0_6_0 tokio_core_0_1_17 trust_dns_proto_0_3_3 ])
      ++ (if kernel == "windows" then mapFeatures features ([ ipconfig_0_1_6 ]) else []);
    features = mkFeatures (features.trust_dns_resolver_0_8_2 or {});
  };
  trust_dns_resolver_0_8_2_features = f: updateFeatures f (rec {
    error_chain_0_1_12.default = (f.error_chain_0_1_12.default or false);
    futures_0_1_21.default = true;
    ipconfig_0_1_6.default = true;
    lazy_static_1_0_0.default = true;
    log_0_4_1.default = true;
    lru_cache_0_1_1.default = true;
    resolv_conf_0_6_0.default = true;
    resolv_conf_0_6_0.system = true;
    tokio_core_0_1_17.default = true;
    trust_dns_proto_0_3_3.default = true;
    trust_dns_proto_0_3_3.dnssec-openssl =
      (f.trust_dns_proto_0_3_3.dnssec-openssl or false) ||
      (trust_dns_resolver_0_8_2.dnssec-openssl or false) ||
      (f.trust_dns_resolver_0_8_2.dnssec-openssl or false);
    trust_dns_proto_0_3_3.dnssec-ring =
      (f.trust_dns_proto_0_3_3.dnssec-ring or false) ||
      (trust_dns_resolver_0_8_2.dnssec-ring or false) ||
      (f.trust_dns_resolver_0_8_2.dnssec-ring or false);
    trust_dns_resolver_0_8_2.default = (f.trust_dns_resolver_0_8_2.default or true);
    trust_dns_resolver_0_8_2.dnssec =
      (f.trust_dns_resolver_0_8_2.dnssec or false) ||
      (f.trust_dns_resolver_0_8_2.dnssec-openssl or false) ||
      (trust_dns_resolver_0_8_2.dnssec-openssl or false) ||
      (f.trust_dns_resolver_0_8_2.dnssec-ring or false) ||
      (trust_dns_resolver_0_8_2.dnssec-ring or false);
  }) [ error_chain_0_1_12_features futures_0_1_21_features lazy_static_1_0_0_features log_0_4_1_features lru_cache_0_1_1_features resolv_conf_0_6_0_features tokio_core_0_1_17_features trust_dns_proto_0_3_3_features ipconfig_0_1_6_features ];
  twoway_0_1_8 = { features?(twoway_0_1_8_features {}) }: twoway_0_1_8_ {
    dependencies = mapFeatures features ([ memchr_2_0_1 ]);
    features = mkFeatures (features.twoway_0_1_8 or {});
  };
  twoway_0_1_8_features = f: updateFeatures f (rec {
    memchr_2_0_1.default = (f.memchr_2_0_1.default or false);
    memchr_2_0_1.use_std =
      (f.memchr_2_0_1.use_std or false) ||
      (twoway_0_1_8.use_std or false) ||
      (f.twoway_0_1_8.use_std or false);
    twoway_0_1_8.default = (f.twoway_0_1_8.default or true);
    twoway_0_1_8.galil-seiferas =
      (f.twoway_0_1_8.galil-seiferas or false) ||
      (f.twoway_0_1_8.benchmarks or false) ||
      (twoway_0_1_8.benchmarks or false);
    twoway_0_1_8.jetscii =
      (f.twoway_0_1_8.jetscii or false) ||
      (f.twoway_0_1_8.all or false) ||
      (twoway_0_1_8.all or false);
    twoway_0_1_8.pattern =
      (f.twoway_0_1_8.pattern or false) ||
      (f.twoway_0_1_8.all or false) ||
      (twoway_0_1_8.all or false) ||
      (f.twoway_0_1_8.benchmarks or false) ||
      (twoway_0_1_8.benchmarks or false);
    twoway_0_1_8.pcmp =
      (f.twoway_0_1_8.pcmp or false) ||
      (f.twoway_0_1_8.all or false) ||
      (twoway_0_1_8.all or false);
    twoway_0_1_8.test-set =
      (f.twoway_0_1_8.test-set or false) ||
      (f.twoway_0_1_8.all or false) ||
      (twoway_0_1_8.all or false);
    twoway_0_1_8.unchecked-index =
      (f.twoway_0_1_8.unchecked-index or false) ||
      (f.twoway_0_1_8.benchmarks or false) ||
      (twoway_0_1_8.benchmarks or false) ||
      (f.twoway_0_1_8.pcmp or false) ||
      (twoway_0_1_8.pcmp or false);
    twoway_0_1_8.use_std =
      (f.twoway_0_1_8.use_std or false) ||
      (f.twoway_0_1_8.default or false) ||
      (twoway_0_1_8.default or false);
  }) [ memchr_2_0_1_features ];
  typed_arena_1_3_0 = { features?(typed_arena_1_3_0_features {}) }: typed_arena_1_3_0_ {};
  typed_arena_1_3_0_features = f: updateFeatures f (rec {
    typed_arena_1_3_0.default = (f.typed_arena_1_3_0.default or true);
  }) [];
  ucd_util_0_1_1 = { features?(ucd_util_0_1_1_features {}) }: ucd_util_0_1_1_ {};
  ucd_util_0_1_1_features = f: updateFeatures f (rec {
    ucd_util_0_1_1.default = (f.ucd_util_0_1_1.default or true);
  }) [];
  unicase_1_4_2 = { features?(unicase_1_4_2_features {}) }: unicase_1_4_2_ {
    dependencies = mapFeatures features ([]);
    buildDependencies = mapFeatures features ([ version_check_0_1_3 ]);
    features = mkFeatures (features.unicase_1_4_2 or {});
  };
  unicase_1_4_2_features = f: updateFeatures f (rec {
    unicase_1_4_2.default = (f.unicase_1_4_2.default or true);
    unicase_1_4_2.heapsize =
      (f.unicase_1_4_2.heapsize or false) ||
      (f.unicase_1_4_2.heap_size or false) ||
      (unicase_1_4_2.heap_size or false);
    unicase_1_4_2.heapsize_plugin =
      (f.unicase_1_4_2.heapsize_plugin or false) ||
      (f.unicase_1_4_2.heap_size or false) ||
      (unicase_1_4_2.heap_size or false);
    version_check_0_1_3.default = true;
  }) [ version_check_0_1_3_features ];
  unicase_2_1_0 = { features?(unicase_2_1_0_features {}) }: unicase_2_1_0_ {
    buildDependencies = mapFeatures features ([ version_check_0_1_3 ]);
    features = mkFeatures (features.unicase_2_1_0 or {});
  };
  unicase_2_1_0_features = f: updateFeatures f (rec {
    unicase_2_1_0.default = (f.unicase_2_1_0.default or true);
    version_check_0_1_3.default = true;
  }) [ version_check_0_1_3_features ];
  unicode_bidi_0_3_4 = { features?(unicode_bidi_0_3_4_features {}) }: unicode_bidi_0_3_4_ {
    dependencies = mapFeatures features ([ matches_0_1_6 ]);
    features = mkFeatures (features.unicode_bidi_0_3_4 or {});
  };
  unicode_bidi_0_3_4_features = f: updateFeatures f (rec {
    matches_0_1_6.default = true;
    unicode_bidi_0_3_4.default = (f.unicode_bidi_0_3_4.default or true);
    unicode_bidi_0_3_4.flame =
      (f.unicode_bidi_0_3_4.flame or false) ||
      (f.unicode_bidi_0_3_4.flame_it or false) ||
      (unicode_bidi_0_3_4.flame_it or false);
    unicode_bidi_0_3_4.flamer =
      (f.unicode_bidi_0_3_4.flamer or false) ||
      (f.unicode_bidi_0_3_4.flame_it or false) ||
      (unicode_bidi_0_3_4.flame_it or false);
    unicode_bidi_0_3_4.serde =
      (f.unicode_bidi_0_3_4.serde or false) ||
      (f.unicode_bidi_0_3_4.with_serde or false) ||
      (unicode_bidi_0_3_4.with_serde or false);
  }) [ matches_0_1_6_features ];
  unicode_normalization_0_1_5 = { features?(unicode_normalization_0_1_5_features {}) }: unicode_normalization_0_1_5_ {};
  unicode_normalization_0_1_5_features = f: updateFeatures f (rec {
    unicode_normalization_0_1_5.default = (f.unicode_normalization_0_1_5.default or true);
  }) [];
  unicode_width_0_1_4 = { features?(unicode_width_0_1_4_features {}) }: unicode_width_0_1_4_ {
    features = mkFeatures (features.unicode_width_0_1_4 or {});
  };
  unicode_width_0_1_4_features = f: updateFeatures f (rec {
    unicode_width_0_1_4.default = (f.unicode_width_0_1_4.default or true);
  }) [];
  unicode_xid_0_0_4 = { features?(unicode_xid_0_0_4_features {}) }: unicode_xid_0_0_4_ {
    features = mkFeatures (features.unicode_xid_0_0_4 or {});
  };
  unicode_xid_0_0_4_features = f: updateFeatures f (rec {
    unicode_xid_0_0_4.default = (f.unicode_xid_0_0_4.default or true);
  }) [];
  unicode_xid_0_1_0 = { features?(unicode_xid_0_1_0_features {}) }: unicode_xid_0_1_0_ {
    features = mkFeatures (features.unicode_xid_0_1_0 or {});
  };
  unicode_xid_0_1_0_features = f: updateFeatures f (rec {
    unicode_xid_0_1_0.default = (f.unicode_xid_0_1_0.default or true);
  }) [];
  unicode_categories_0_1_1 = { features?(unicode_categories_0_1_1_features {}) }: unicode_categories_0_1_1_ {};
  unicode_categories_0_1_1_features = f: updateFeatures f (rec {
    unicode_categories_0_1_1.default = (f.unicode_categories_0_1_1.default or true);
  }) [];
  unidecode_0_3_0 = { features?(unidecode_0_3_0_features {}) }: unidecode_0_3_0_ {};
  unidecode_0_3_0_features = f: updateFeatures f (rec {
    unidecode_0_3_0.default = (f.unidecode_0_3_0.default or true);
  }) [];
  unreachable_1_0_0 = { features?(unreachable_1_0_0_features {}) }: unreachable_1_0_0_ {
    dependencies = mapFeatures features ([ void_1_0_2 ]);
  };
  unreachable_1_0_0_features = f: updateFeatures f (rec {
    unreachable_1_0_0.default = (f.unreachable_1_0_0.default or true);
    void_1_0_2.default = (f.void_1_0_2.default or false);
  }) [ void_1_0_2_features ];
  untrusted_0_5_1 = { features?(untrusted_0_5_1_features {}) }: untrusted_0_5_1_ {};
  untrusted_0_5_1_features = f: updateFeatures f (rec {
    untrusted_0_5_1.default = (f.untrusted_0_5_1.default or true);
  }) [];
  url_1_7_0 = { features?(url_1_7_0_features {}) }: url_1_7_0_ {
    dependencies = mapFeatures features ([ idna_0_1_4 matches_0_1_6 percent_encoding_1_0_1 ]
      ++ (if features.url_1_7_0.encoding or false then [ encoding_0_2_33 ] else []));
    features = mkFeatures (features.url_1_7_0 or {});
  };
  url_1_7_0_features = f: updateFeatures f (rec {
    encoding_0_2_33.default = true;
    idna_0_1_4.default = true;
    matches_0_1_6.default = true;
    percent_encoding_1_0_1.default = true;
    url_1_7_0.default = (f.url_1_7_0.default or true);
    url_1_7_0.encoding =
      (f.url_1_7_0.encoding or false) ||
      (f.url_1_7_0.query_encoding or false) ||
      (url_1_7_0.query_encoding or false);
    url_1_7_0.heapsize =
      (f.url_1_7_0.heapsize or false) ||
      (f.url_1_7_0.heap_size or false) ||
      (url_1_7_0.heap_size or false);
  }) [ encoding_0_2_33_features idna_0_1_4_features matches_0_1_6_features percent_encoding_1_0_1_features ];
  url_serde_0_2_0 = { features?(url_serde_0_2_0_features {}) }: url_serde_0_2_0_ {
    dependencies = mapFeatures features ([ serde_1_0_43 url_1_7_0 ]);
  };
  url_serde_0_2_0_features = f: updateFeatures f (rec {
    serde_1_0_43.default = true;
    url_1_7_0.default = true;
    url_serde_0_2_0.default = (f.url_serde_0_2_0.default or true);
  }) [ serde_1_0_43_features url_1_7_0_features ];
  utf8_ranges_1_0_0 = { features?(utf8_ranges_1_0_0_features {}) }: utf8_ranges_1_0_0_ {};
  utf8_ranges_1_0_0_features = f: updateFeatures f (rec {
    utf8_ranges_1_0_0.default = (f.utf8_ranges_1_0_0.default or true);
  }) [];
  uuid_0_5_1 = { features?(uuid_0_5_1_features {}) }: uuid_0_5_1_ {
    dependencies = mapFeatures features ([ ]
      ++ (if features.uuid_0_5_1.rand or false then [ rand_0_3_22 ] else []));
    features = mkFeatures (features.uuid_0_5_1 or {});
  };
  uuid_0_5_1_features = f: updateFeatures f (rec {
    rand_0_3_22.default = true;
    uuid_0_5_1.default = (f.uuid_0_5_1.default or true);
    uuid_0_5_1.md5 =
      (f.uuid_0_5_1.md5 or false) ||
      (f.uuid_0_5_1.v3 or false) ||
      (uuid_0_5_1.v3 or false);
    uuid_0_5_1.rand =
      (f.uuid_0_5_1.rand or false) ||
      (f.uuid_0_5_1.v1 or false) ||
      (uuid_0_5_1.v1 or false) ||
      (f.uuid_0_5_1.v4 or false) ||
      (uuid_0_5_1.v4 or false);
    uuid_0_5_1.sha1 =
      (f.uuid_0_5_1.sha1 or false) ||
      (f.uuid_0_5_1.v5 or false) ||
      (uuid_0_5_1.v5 or false);
  }) [ rand_0_3_22_features ];
  uuid_0_6_3 = { features?(uuid_0_6_3_features {}) }: uuid_0_6_3_ {
    dependencies = mapFeatures features ([ cfg_if_0_1_2 ]
      ++ (if features.uuid_0_6_3.rand or false then [ rand_0_4_2 ] else []));
    features = mkFeatures (features.uuid_0_6_3 or {});
  };
  uuid_0_6_3_features = f: updateFeatures f (rec {
    cfg_if_0_1_2.default = true;
    rand_0_4_2.default = true;
    uuid_0_6_3.default = (f.uuid_0_6_3.default or true);
    uuid_0_6_3.md5 =
      (f.uuid_0_6_3.md5 or false) ||
      (f.uuid_0_6_3.v3 or false) ||
      (uuid_0_6_3.v3 or false);
    uuid_0_6_3.rand =
      (f.uuid_0_6_3.rand or false) ||
      (f.uuid_0_6_3.v3 or false) ||
      (uuid_0_6_3.v3 or false) ||
      (f.uuid_0_6_3.v4 or false) ||
      (uuid_0_6_3.v4 or false) ||
      (f.uuid_0_6_3.v5 or false) ||
      (uuid_0_6_3.v5 or false);
    uuid_0_6_3.serde =
      (f.uuid_0_6_3.serde or false) ||
      (f.uuid_0_6_3.playground or false) ||
      (uuid_0_6_3.playground or false);
    uuid_0_6_3.sha1 =
      (f.uuid_0_6_3.sha1 or false) ||
      (f.uuid_0_6_3.v5 or false) ||
      (uuid_0_6_3.v5 or false);
    uuid_0_6_3.std =
      (f.uuid_0_6_3.std or false) ||
      (f.uuid_0_6_3.default or false) ||
      (uuid_0_6_3.default or false) ||
      (f.uuid_0_6_3.use_std or false) ||
      (uuid_0_6_3.use_std or false);
    uuid_0_6_3.v1 =
      (f.uuid_0_6_3.v1 or false) ||
      (f.uuid_0_6_3.playground or false) ||
      (uuid_0_6_3.playground or false);
    uuid_0_6_3.v3 =
      (f.uuid_0_6_3.v3 or false) ||
      (f.uuid_0_6_3.playground or false) ||
      (uuid_0_6_3.playground or false);
    uuid_0_6_3.v4 =
      (f.uuid_0_6_3.v4 or false) ||
      (f.uuid_0_6_3.playground or false) ||
      (uuid_0_6_3.playground or false);
    uuid_0_6_3.v5 =
      (f.uuid_0_6_3.v5 or false) ||
      (f.uuid_0_6_3.playground or false) ||
      (uuid_0_6_3.playground or false);
  }) [ cfg_if_0_1_2_features rand_0_4_2_features ];
  vcpkg_0_2_3 = { features?(vcpkg_0_2_3_features {}) }: vcpkg_0_2_3_ {};
  vcpkg_0_2_3_features = f: updateFeatures f (rec {
    vcpkg_0_2_3.default = (f.vcpkg_0_2_3.default or true);
  }) [];
  vec_map_0_8_0 = { features?(vec_map_0_8_0_features {}) }: vec_map_0_8_0_ {
    dependencies = mapFeatures features ([]);
    features = mkFeatures (features.vec_map_0_8_0 or {});
  };
  vec_map_0_8_0_features = f: updateFeatures f (rec {
    vec_map_0_8_0.default = (f.vec_map_0_8_0.default or true);
    vec_map_0_8_0.serde =
      (f.vec_map_0_8_0.serde or false) ||
      (f.vec_map_0_8_0.eders or false) ||
      (vec_map_0_8_0.eders or false);
    vec_map_0_8_0.serde_derive =
      (f.vec_map_0_8_0.serde_derive or false) ||
      (f.vec_map_0_8_0.eders or false) ||
      (vec_map_0_8_0.eders or false);
  }) [];
  version_check_0_1_3 = { features?(version_check_0_1_3_features {}) }: version_check_0_1_3_ {};
  version_check_0_1_3_features = f: updateFeatures f (rec {
    version_check_0_1_3.default = (f.version_check_0_1_3.default or true);
  }) [];
  void_1_0_2 = { features?(void_1_0_2_features {}) }: void_1_0_2_ {
    features = mkFeatures (features.void_1_0_2 or {});
  };
  void_1_0_2_features = f: updateFeatures f (rec {
    void_1_0_2.default = (f.void_1_0_2.default or true);
    void_1_0_2.std =
      (f.void_1_0_2.std or false) ||
      (f.void_1_0_2.default or false) ||
      (void_1_0_2.default or false);
  }) [];
  walkdir_1_0_7 = { features?(walkdir_1_0_7_features {}) }: walkdir_1_0_7_ {
    dependencies = mapFeatures features ([ same_file_0_1_3 ])
      ++ (if kernel == "windows" then mapFeatures features ([ kernel32_sys_0_2_2 winapi_0_2_8 ]) else []);
  };
  walkdir_1_0_7_features = f: updateFeatures f (rec {
    kernel32_sys_0_2_2.default = true;
    same_file_0_1_3.default = true;
    walkdir_1_0_7.default = (f.walkdir_1_0_7.default or true);
    winapi_0_2_8.default = true;
  }) [ same_file_0_1_3_features kernel32_sys_0_2_2_features winapi_0_2_8_features ];
  widestring_0_2_2 = { features?(widestring_0_2_2_features {}) }: widestring_0_2_2_ {};
  widestring_0_2_2_features = f: updateFeatures f (rec {
    widestring_0_2_2.default = (f.widestring_0_2_2.default or true);
  }) [];
  winapi_0_2_8 = { features?(winapi_0_2_8_features {}) }: winapi_0_2_8_ {};
  winapi_0_2_8_features = f: updateFeatures f (rec {
    winapi_0_2_8.default = (f.winapi_0_2_8.default or true);
  }) [];
  winapi_0_3_4 = { features?(winapi_0_3_4_features {}) }: winapi_0_3_4_ {
    dependencies = (if kernel == "i686-pc-windows-gnu" then mapFeatures features ([ winapi_i686_pc_windows_gnu_0_4_0 ]) else [])
      ++ (if kernel == "x86_64-pc-windows-gnu" then mapFeatures features ([ winapi_x86_64_pc_windows_gnu_0_4_0 ]) else []);
    features = mkFeatures (features.winapi_0_3_4 or {});
  };
  winapi_0_3_4_features = f: updateFeatures f (rec {
    winapi_0_3_4.default = (f.winapi_0_3_4.default or true);
    winapi_i686_pc_windows_gnu_0_4_0.default = true;
    winapi_x86_64_pc_windows_gnu_0_4_0.default = true;
  }) [ winapi_i686_pc_windows_gnu_0_4_0_features winapi_x86_64_pc_windows_gnu_0_4_0_features ];
  winapi_build_0_1_1 = { features?(winapi_build_0_1_1_features {}) }: winapi_build_0_1_1_ {};
  winapi_build_0_1_1_features = f: updateFeatures f (rec {
    winapi_build_0_1_1.default = (f.winapi_build_0_1_1.default or true);
  }) [];
  winapi_i686_pc_windows_gnu_0_4_0 = { features?(winapi_i686_pc_windows_gnu_0_4_0_features {}) }: winapi_i686_pc_windows_gnu_0_4_0_ {};
  winapi_i686_pc_windows_gnu_0_4_0_features = f: updateFeatures f (rec {
    winapi_i686_pc_windows_gnu_0_4_0.default = (f.winapi_i686_pc_windows_gnu_0_4_0.default or true);
  }) [];
  winapi_x86_64_pc_windows_gnu_0_4_0 = { features?(winapi_x86_64_pc_windows_gnu_0_4_0_features {}) }: winapi_x86_64_pc_windows_gnu_0_4_0_ {};
  winapi_x86_64_pc_windows_gnu_0_4_0_features = f: updateFeatures f (rec {
    winapi_x86_64_pc_windows_gnu_0_4_0.default = (f.winapi_x86_64_pc_windows_gnu_0_4_0.default or true);
  }) [];
  wincolor_0_1_6 = { features?(wincolor_0_1_6_features {}) }: wincolor_0_1_6_ {
    dependencies = mapFeatures features ([ winapi_0_3_4 ]);
  };
  wincolor_0_1_6_features = f: updateFeatures f (rec {
    winapi_0_3_4.consoleapi = true;
    winapi_0_3_4.default = true;
    winapi_0_3_4.minwindef = true;
    winapi_0_3_4.processenv = true;
    winapi_0_3_4.winbase = true;
    winapi_0_3_4.wincon = true;
    wincolor_0_1_6.default = (f.wincolor_0_1_6.default or true);
  }) [ winapi_0_3_4_features ];
  winreg_0_5_0 = { features?(winreg_0_5_0_features {}) }: winreg_0_5_0_ {
    dependencies = mapFeatures features ([ winapi_0_3_4 ]);
    features = mkFeatures (features.winreg_0_5_0 or {});
  };
  winreg_0_5_0_features = f: updateFeatures f (rec {
    winapi_0_3_4.default = true;
    winapi_0_3_4.handleapi = true;
    winapi_0_3_4.ktmw32 =
      (f.winapi_0_3_4.ktmw32 or false) ||
      (winreg_0_5_0.transactions or false) ||
      (f.winreg_0_5_0.transactions or false);
    winapi_0_3_4.minwindef = true;
    winapi_0_3_4.winerror = true;
    winapi_0_3_4.winnt = true;
    winapi_0_3_4.winreg = true;
    winreg_0_5_0.default = (f.winreg_0_5_0.default or true);
    winreg_0_5_0.serde =
      (f.winreg_0_5_0.serde or false) ||
      (f.winreg_0_5_0.serialization-serde or false) ||
      (winreg_0_5_0.serialization-serde or false);
    winreg_0_5_0.transactions =
      (f.winreg_0_5_0.transactions or false) ||
      (f.winreg_0_5_0.serialization-serde or false) ||
      (winreg_0_5_0.serialization-serde or false);
  }) [ winapi_0_3_4_features ];
  winutil_0_1_1 = { features?(winutil_0_1_1_features {}) }: winutil_0_1_1_ {
    dependencies = (if kernel == "windows" then mapFeatures features ([ winapi_0_3_4 ]) else []);
  };
  winutil_0_1_1_features = f: updateFeatures f (rec {
    winapi_0_3_4.default = true;
    winapi_0_3_4.processthreadsapi = true;
    winapi_0_3_4.winbase = true;
    winapi_0_3_4.wow64apiset = true;
    winutil_0_1_1.default = (f.winutil_0_1_1.default or true);
  }) [ winapi_0_3_4_features ];
  ws2_32_sys_0_2_1 = { features?(ws2_32_sys_0_2_1_features {}) }: ws2_32_sys_0_2_1_ {
    dependencies = mapFeatures features ([ winapi_0_2_8 ]);
    buildDependencies = mapFeatures features ([ winapi_build_0_1_1 ]);
  };
  ws2_32_sys_0_2_1_features = f: updateFeatures f (rec {
    winapi_0_2_8.default = true;
    winapi_build_0_1_1.default = true;
    ws2_32_sys_0_2_1.default = (f.ws2_32_sys_0_2_1.default or true);
  }) [ winapi_0_2_8_features winapi_build_0_1_1_features ];
}.converse_0_1_0 {}
