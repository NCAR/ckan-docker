#!/bin/bash

cd ${SRC_EXTENSIONS_DIR} || exit

# Make installs conditional because a docker bind mount places local plugins into the container.

### Harvester ###
if [ ! -d "${SRC_EXTENSIONS_DIR}/ckanext-harvest" ]; then
    git clone https://github.com/NCAR/ckanext-harvest.git
fi
pip3 install -e ${SRC_EXTENSIONS_DIR}/ckanext-harvest && \
pip3 install -r ${SRC_EXTENSIONS_DIR}/ckanext-harvest/pip-requirements.txt && \
pip3 install -r ${SRC_EXTENSIONS_DIR}/ckanext-harvest/dev-requirements.txt


### Spatial Harvester ###
if [ ! -d "${SRC_EXTENSIONS_DIR}/ckanext-spatial" ]; then
    git clone https://github.com/NCAR/ckanext-spatial.git
fi
pip3 install -e ${SRC_EXTENSIONS_DIR}/ckanext-spatial && \
pip3 install -r ${SRC_EXTENSIONS_DIR}/ckanext-spatial/pip-requirements.txt


### Repo Info; required by dsetsearch plugin ###
if [ ! -d "${SRC_EXTENSIONS_DIR}/ckanext-repo" ]; then
     git clone https://github.com/NCAR/ckanext-repo.git
fi
pip3 install -e ${SRC_EXTENSIONS_DIR}/ckanext-repo


### Plugins for filtering on publication date and temporal extent
if [ ! -d "${SRC_EXTENSIONS_DIR}/ckanext-datesearch" ]; then
      git clone https://github.com/NCAR/ckanext-datesearch.git
fi
pip3 install -e ${SRC_EXTENSIONS_DIR}/ckanext-datesearch


if [ ! -d "${SRC_EXTENSIONS_DIR}/ckanext-extentsearch" ]; then
      git clone https://github.com/NCAR/ckanext-extentsearch.git
fi
pip3 install -e ${SRC_EXTENSIONS_DIR}/ckanext-extentsearch

### Provide sitemap and Pure feed
if [ ! -d "${SRC_EXTENSIONS_DIR}/ckanext-sitemap" ]; then
      git clone https://github.com/NCAR/ckanext-sitemap.git
fi
pip3 install -e ${SRC_EXTENSIONS_DIR}/ckanext-sitemap

### Provide Google Analytics
if [ ! -d "${SRC_EXTENSIONS_DIR}/ckanext-googleanalytics" ]; then
      git clone https://github.com/ckan/ckanext-googleanalytics.git
fi
pip3 install -e ${SRC_EXTENSIONS_DIR}/ckanext-googleanalytics


## Return to home directory
cd ${APP_DIR} || exit