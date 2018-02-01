#!/bin/bash
set -e
set -v

cd /pgmigrate
pgmigrate -c postgresql://postgres@localhost/gongo migrate -t $TARGET
cd /