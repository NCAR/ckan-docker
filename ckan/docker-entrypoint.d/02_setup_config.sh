#!/bin/bash

if [[ $CKAN__PLUGINS == *"dsetsearch"* ]]; then

  # Show commands that are run
  set -x

  ckan config-tool --edit ./ckan.ini ckan.site_title='Docker DASH Search'

  ckan config-tool --edit ./ckan.ini ckan.site_description='NCAR data search and discovery'

  ckan config-tool --edit ./ckan.ini ckan.auth.public_user_details=false

  # Keep the favicon value unchanged; its config setting differs across CKAN versions.
  ckan config-tool --edit ./ckan.ini ckan.favicon='/NCARfavicon.ico'

  # Place DSETSearch plugin settings in [app:main] section (before Logging)
#  sed -i "/## Logging configuration/i \ \n\
### DSET-Search Plugin Settings \n\
## Toggle display of Resource Formats search facet and dataset-specific format tags in search results \n\
#ckanext.dsetsearch.enable_search_format_ui = true \n\
#ckanext.dsetsearch.enable_publisher_facet = true \n\
#" /etc/ckan/default/ckan.ini
  ckan config-tool ./ckan.ini ckanext.dsetsearch.enable_search_format_ui=true
  ckan config-tool ./ckan.ini ckanext.dsetsearch.enable_publisher_facet=true
  ckan config-tool ./ckan.ini ckanext_dsetsearch_banner_message='test'



  # Place Repo-Info settings in [app:main] section (before Logging)
#  sed -i "/## Logging configuration/i \ \n\
### Repo-Info Settings \n\
#ckanext.repo.srcpath = /usr/lib/ckan/default/src \n\
#ckanext.repo.repos = ckan NCAR/ckanext-dsetsearch \n\
#" /etc/ckan/default/ckan.ini
  ckan config-tool ./ckan.ini ckanext.repo.srcpath=$SRC_DIR
  ckan config-tool ./ckan.ini ckanext.repo.repos='ckan NCAR/ckanext-dsetsearch'

  # Place Harvester settings in [app:main] section (before Logging)
#  sed -i "/## Logging configuration/i \ \n\
### Harvest Settings \n\
#ckan.harvest.mq.type = redis \n\
#ckan.harvest.log_scope = 1 \n\
#ckan.harvest.log_timeframe = 10 \n\
#ckan.harvest.log_level = info \n\
#ckanext.spatial.harvest.user_name = admin \n\
#ckanext.spatial.search_backend = solr-spatial-field \n\
#ckanext.spatial.use_postgis_sorting = false \n\
#ckan.spatial.validator.profiles = iso19139, dset-minimum-fields-production, geographic-extent-validator, temporal-extent-validator, collections-validator \n\
# \n\
### Spatial Map Widget Settings  \n\
#ckanext.spatial.common_map.type = custom \n\
#ckanext.spatial.common_map.custom.url = https://tile.openstreetmap.org/{z}/{x}/{y}.png \n\
#ckanext.spatial.common_map.attribution = &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors \n\
#" /etc/ckan/default/ckan.ini

  # Add configuration toggle for enabling/disabling harvest error email notification
  ckan config-tool ./ckan.ini ckan.harvest.status_mail.errored=true
  ckan config-tool ./ckan.ini ckan.harvest.mq.type=redis
  ckan config-tool ./ckan.ini ckan.harvest.log_scope=1 
  ckan config-tool ./ckan.ini ckan.harvest.log_timeframe=10 
  ckan config-tool ./ckan.ini ckan.harvest.log_level=info 
  ckan config-tool ./ckan.ini ckanext.spatial.harvest.user_name=ckan_admin
  ckan config-tool ./ckan.ini ckanext.spatial.search_backend=solr-spatial-field
  ckan config-tool ./ckan.ini ckanext.spatial.use_postgis_sorting=false
  ckan config-tool ./ckan.ini ckan.spatial.validator.profiles='iso19139, dset-minimum-fields-production, geographic-extent-validator, temporal-extent-validator, collections-validator'
  ckan config-tool ./ckan.ini ckanext.spatial.common_map.type=custom 
  ckan config-tool ./ckan.ini ckanext.spatial.common_map.custom.url='https://tile.openstreetmap.org/{z}/{x}/{y}.png'
  ckan config-tool ./ckan.ini ckanext.spatial.common_map.attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'



  # Change Solr query parser to allow point location queries
  #sed -i "s|ckan.search.solr_allowed_query_parsers = |ckan.search.solr_allowed_query_parsers = field|" /etc/ckan/default/ckan.ini
  #ckan config-tool --edit ./ckan.ini ckan.search.solr_allowed_query_parsers=field

  # Allow the harvest user to create collections (groups in CKAN) at harvest time (MAY BE UNNEEDED).
  # sed -i "s|ckan.auth.user_create_groups = false|ckan.auth.user_create_groups = true|" /etc/ckan/default/ckan.ini


  # Update Email Notification settings in [app:main] section

#  ckan config-tool --edit ./ckan.ini email_to=yourEmail@ucar.edu
#  ckan config-tool --edit ./ckan.ini error_email_from=vagrant-ckan@localhost
#  ckan config-tool --edit ./ckan.ini smtp.server=smtp.gmail.com:587
#  ckan config-tool --edit ./ckan.ini smtp.starttls=True
#  ckan config-tool --edit ./ckan.ini smtp.user=yourEmail@ucar.edu
#  ckan config-tool --edit ./ckan.ini smtp.password=your_CIT_Password
#  ckan config-tool --edit ./ckan.ini smtp.mail_from=vagrant-ckan@ucar.edu


fi