# Your overlays should go here (https://nixos.wiki/wiki/Overlays)
final: prev: {
  # example = prev.example.overrideAttrs (oldAttrs: rec {
  # ...
  # });
  python39 = prev.python39.override (oldAttrs: rec {
    packageOverrides = final: prev: {
      pyopenssl = prev.pyopenssl.overrideAttrs (old: {meta = old.meta // { broken = false; };});
    };
  });
} // import ../pkgs { pkgs = final; }
# This line adds your custom packages into the overlay.
