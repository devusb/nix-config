{ pkgs }: with pkgs; ''
  journalcreds() {
      local arg_role=(superuser)
      local usage=(
          "grab journal creds"
          "journalcreds [-r|--role] database"
      )

      zmodload zsh/zutil
      zparseopts -D -F -K -- \
          {r,-role}:=arg_role ||
          return 1

      if ((# == 0)); then
          print -l $usage
          return
      fi
      role_name=$arg_role[-1]
      db_name="$1"

      json_creds=$(${lib.getExe vault} read db/prd/creds/$role_name-$db_name -format=json)

      username=$(echo "$json_creds" | ${lib.getExe jq} -r '.data.username')
      password=$(echo "$json_creds" | ${lib.getExe jq} -r '.data.password')

      json_conn=$(${lib.getExe vault} read db/prd/config/journal-$db_name -format=json | ${lib.getExe jq} -r '.data.connection_details')

      connection_url=$(echo "$json_conn" | ${lib.getExe pkgs.jq} -r '.connection_url | sub("{{username}}"; "'"$username"'") | sub("{{password}}"; "'"$password"'")')

      export DATABASE_URI="$connection_url"
  }
''
