
# Add WAFs for spatial harvesting
PLUGINS=`grep plugins ${APP_DIR}/ckan.ini`

if [[ $PLUGINS == *"harvest"* ]]; then

  # Make sure WAF organizations are created
  pip install ckanapi
  ORGANIZATION_NAMES="NCAR"
  for org in $ORGANIZATION_NAMES; do
        /srv/app/.local/bin/ckanapi action organization_create name=${org} title=${org}
  done

  ls -l /var/www/*


  cd /var/www/html
  WAF_FOLDERS="sagedev-dset-harvest-test dset-web-accessible-folder-dev"
  for waf_folder in $WAF_FOLDERS; do
      waf_url="https://github.com/NCAR/${waf_folder}.git"

      if [ ! -d "/var/www/html/${waf_folder}" ]; then
          git clone ${waf_url}
      fi

      # Make sure harvest source exists
      ckan -c ~/ckan.ini harvester source create "${waf_folder}" "http://nginx:9000/${waf_folder}" "waf" "${waf_folder}" "TRUE" "NCAR" "MANUAL" '{"user" : "admin", "read_only": true}'
  done

  # Return to home directory for supervisord startup
  cd
fi
