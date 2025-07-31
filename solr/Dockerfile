ARG SOLR_IMAGE_VERSION=2.10-solr9-spatial

FROM ckan/ckan-solr:${SOLR_IMAGE_VERSION}
EXPOSE 8983

ENV SOLR_INSTALL="/opt/solr/"
ENV SOLR_CONFIG_DIR="$SOLR_INSTALL/server/solr/configsets"
ENV SOLR_SCHEMA_FILE="$SOLR_CONFIG_DIR/ckan/conf/managed-schema"

USER root

## Add Date range type and fields
ENV SOLR_DATE_TYPE='<fieldType name="date_range" class="solr.DateRangeField"/>'

RUN sed -i "/<types>/a $SOLR_DATE_TYPE" $SOLR_SCHEMA_FILE


ENV SOLR_DATE_FIELDS='<field name="extras_publication_date" type="date" indexed="true" stored="true" multiValued="false"/> \
<field name="extent_range" type="date_range" indexed="true" stored="true" multiValued="false"/>'

RUN sed -i "/<fields>/a $SOLR_DATE_FIELDS" $SOLR_SCHEMA_FILE

USER solr

CMD ["sh", "-c", "solr-precreate ckan $SOLR_CONFIG_DIR/ckan"]