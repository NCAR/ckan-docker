#FROM ckan/ckan-dev:2.11.4   # Use instead to install CKAN Developer/Debug tools
FROM ckan/ckan-base:2.11.4

# Workaround from https://github.com/ckan/ckan-docker/issues/196
USER root
RUN mkdir /srv/app/.local && chown ckan /srv/app/.local
RUN mkdir /srv/app/.cache && chown ckan /srv/app/.cache

# Copy harvester scripts
COPY config/*.sh  /srv/app

RUN chown -R ckan:ckan-sys ${APP_DIR} && chmod 755 /srv/app/*.sh


### Install everything we need for the harvester
# Install cron and supervisor.
RUN apt-get update && apt-get install -y --no-install-recommends \
    procps \
    cron \
    supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/log/ckan/std /var/log/supervisor /etc/supervisor/conf.d \
    && chown -R ckan:ckan-sys /var/log/ckan /var/log/supervisor /etc/supervisor/conf.d

# Config supervisor for managing cron and harvest processes
COPY config/supervisord_ckan.conf /etc/supervisor/conf.d/ckan.conf
COPY config/supervisord.conf /etc/supervisor/supervisord.conf
COPY config/crontab /etc/cron.d/ckan-cron

# Running cron as non-root user and give permission to ckan user
RUN chmod gu+s /usr/sbin/cron && \
    crontab -u ckan /etc/cron.d/ckan-cron

# Copy custom initialization scripts
COPY --chown=ckan-sys:ckan-sys docker-entrypoint.d/* /docker-entrypoint.d/
COPY --chown=ckan-sys:ckan-sys setup/prerun.py ${APP_DIR}

# Copy Pure XML for serving at endpoint <ckan_base_url>/pure.xml
COPY --chown=ckan-sys:ckan-sys setup/pure.xml ${APP_DIR}

# Apply any patches needed to CKAN core or any of the built extensions (not the runtime mounted ones)
COPY --chown=ckan-sys:ckan-sys patches ${APP_DIR}/patches

# Add supervisord invocation during startup
RUN sed -i '/uwsgi \$UWSGI_OPTS/i\    supervisord --configuration \/etc\/supervisor\/supervisord.conf &' ${APP_DIR}/start_ckan.sh

# The permissions changes to /var/www/html MUST be applied here, as the rest of the time we are the ckan user.
RUN  mkdir -p /var/www/html && chown -R ckan:ckan-sys /var/www/html

# Install PyCharm module if we are debugging
ARG PYCHARM_DEBUG=false
RUN if [ "$PYCHARM_DEBUG" = "true" ]; then \
        pip install pydevd-pycharm==262.8665.186; \
    fi

USER ckan
RUN for d in $APP_DIR/patches/*; do \
        if [ -d $d ]; then \
            for f in `ls $d/*.patch | sort -g`; do \
                cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
            done ; \
        fi ; \
    done
