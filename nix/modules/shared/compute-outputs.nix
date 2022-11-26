let
  pkgs = import <nixpkgs> {
    config.allowBroken = true;
    config.allowUnfree = true;
  };
  lib = import <nixpkgs/lib>;
  tryEval = builtins.tryEval;
in
  lib.mapAttrs (k: v:
    let name = (tryEval v.name or "");
    out = (tryEval v.outPath or "");
    in {
      name = name.value;
      out  = out.value;
    }
  ) pkgs
