{ pkgs, ... }:
{
  boot.kernelPatches = [
    # https://github.com/NixOS/nixpkgs/issues/382612
    {
      name = "chromium-acceleration-revert";
      patch = pkgs.fetchpatch {
        url = "https://github.com/torvalds/linux/commit/b9b588f22a0c049a14885399e27625635ae6ef91.diff";
        hash = "sha256-1uFTfVEoTHlRkaIQ/VuzBV6hstZPgngHHRL05rkwuNY=";
        revert = true;
      };
    }
  ];
}
