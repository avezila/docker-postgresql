#!/bin/bash
set -e
set -v

cd /pgmigrate
pgmigrate -c postgresql://postgres:$DB_PASS@$DB_HOST/gongo migrate -t $TARGET
cd /
