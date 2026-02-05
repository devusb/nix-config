{ pkgs, lib, ... }:
''
  set -l site_id 7

  if test (count $argv) -ne 1
      echo "usage: 4to6 <hostname|ip>" >&2
      return 1
  end

  set -l host $argv[1]

  # Resolve to IPv4 if not already an IP
  set -l ip
  if string match -qr '^\d+\.\d+\.\d+\.\d+$' -- $host
      set ip $host
  else
      set ip (command ${lib.getExe pkgs.dig} +short $host | string match -r '^\d+\.\d+\.\d+\.\d+$' | ${lib.getExe' pkgs.coreutils "head"} -1)
      if test -z "$ip"
          echo "4to6: could not resolve '$host'" >&2
          return 1
      end
  end

  echo (string replace -a '.' '-' -- $ip)"-via-$site_id"
''
