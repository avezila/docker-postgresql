FROM ubuntu:17.10

ENV PG_APP_HOME="/etc/docker-pgpro"
ENV PG_VERSION=std-10 \
    PG_USER=postgres \
    PG_HOME=/var/lib/pgpro \
    PG_RUNDIR=/run/pgpro \
    PG_LOGDIR=/var/log/pgpro \
    PG_CERTDIR=/opt/pgpro/certs

ENV PG_BIN_ROOT=/opt/pgpro/${PG_VERSION}
ENV PG_BINDIR=${PG_BIN_ROOT}/bin \
    PG_DATADIR=${PG_HOME}/${PG_VERSION}/data

ENV TARGET 4000

ENV DB_NAME=gongo
ENV REPLICATION_USER=repluser
ENV REPLICATION_PASS="Monach2734&"

ENV PATH="/opt/pgpro/std-10/bin:${PATH}"
ENV DB_EXTENSION=pgcrypto,intarray,hstore,rum,jsquery

COPY runtime/ ${PG_APP_HOME}/
ADD ./tsearch_data/ /opt/pgpro/std-10/share/tsearch_data/
ADD ./init/entrypoint.sh /sbin/entrypoint.sh
ADD ./init/pgmigrate.sh /sbin/pgmigrate.sh


ADD ./dockerfile.sh /root
RUN /root/dockerfile.sh

ENV LC_ALL=en_US.utf8
ENV LANG=en_US.utf8

WORKDIR ${PG_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
