#!/bin/bash
set -e
set -v

cd /pgmigrate
cat /var/lib/pgpro/std-10/data/postgresql.conf
cat /var/lib/pgpro/std-10/data/pg_hba.conf
pgmigrate -c postgresql://postgres@$DB_HOST/gongo migrate -t $TARGET
cd /
