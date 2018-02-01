#!/bin/bash
set -e
source ${PG_APP_HOME}/functions

[[ ${DEBUG} == true ]] && set -x

# allow arguments to be passed to postgres
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == postgres || ${1} == $(which postgres) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch postgres
if [[ -z ${1} ]]; then
  map_uidgid
  create_datadir
  create_certdir
  create_logdir
  create_rundir
  set_resolvconf_perms
  
  if [ -f "/postgresql.conf" ]; then
    if [ -f "${PG_DATADIR}/postgresql.conf" ]; then
      #exec_as_postgres cp ${PG_DATADIR}/postgresql.conf ${PG_DATADIR}/postgresql.conf.save
      exec_as_postgres cp /postgresql.conf ${PG_DATADIR}/postgresql.conf
    fi
  fi


  configure_postgresql

  if [ -f "/postgresql.conf" ]; then
    #exec_as_postgres cp ${PG_DATADIR}/postgresql.conf ${PG_DATADIR}/postgresql.conf.save
    exec_as_postgres cp /postgresql.conf ${PG_DATADIR}/postgresql.conf
  fi


  echo "Starting PostgreSQL ${PG_VERSION}..."
  echo $EXTRA_ARGS
  if [ -d "/pgmigrate" ]; then
    if [ -f "/sbin/pgmigrate.sh" ]; then
      exec_as_postgres ${PG_BINDIR}/pg_ctl -D "$PG_DATADIR" -o "${EXTRA_ARGS}" -w start > /dev/null
      exec_as_postgres /sbin/pgmigrate.sh
      exec_as_postgres ${PG_BINDIR}/pg_ctl -D "$PG_DATADIR" -m fast -w stop > /dev/null
    fi
  fi
  exec start-stop-daemon --start --chuid ${PG_USER}:${PG_USER} \
    --exec ${PG_BINDIR}/postgres -- -D ${PG_DATADIR} ${EXTRA_ARGS}
else
  exec "$@"
fi
