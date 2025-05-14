FROM ckan/ckan-base:2.11

# Install any extensions needed by your CKAN instance
# See Dockerfile.dev for more details and examples

### Harvester ###
RUN pip3 install -e 'git+https://github.com/NCAR/ckanext-harvest.git@main#egg=ckanext-harvest' && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt
# will also require gather_consumer and fetch_consumer processes running (please see https://github.com/ckan/ckanext-harvest)

### Spatial Harvester ###
RUN pip3 install -e 'git+https://github.com/NCAR/ckanext-spatial.git@main#egg=ckanext-spatial' && \
    pip3 install -r ${APP_DIR}/src/ckanext-spatial/pip-requirements.txt

### Repo Info; required by dsetsearch plugin ###
RUN pip3 install -e 'git+https://github.com/NCAR/ckanext-repo.git@main#egg=ckanext-repo' 



### DASH Search custom plugin
RUN  pip3 install -e git+https://67704c9484c2b63f308a9a2269932d4dda57b36f@github.com/NCAR/ckanext-dsetsearch.git#egg=ckanext-dsetsearch && \
     pip3 install -r ${APP_DIR}/src/ckanext-dsetsearch/pip-requirements.txt



# Copy custom initialization scripts
COPY --chown=ckan-sys:ckan-sys docker-entrypoint.d/* /docker-entrypoint.d/

# Apply any patches needed to CKAN core or any of the built extensions (not the
# runtime mounted ones)
COPY --chown=ckan-sys:ckan-sys patches ${APP_DIR}/patches

# Make the WAF folder owned by ckan
USER root
RUN mkdir -p /var/www/html && chown ckan /var/www/html


USER ckan

RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
            done ; \
        fi ; \
    done
