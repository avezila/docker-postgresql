#!/bin/bash
set -e
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$ROOT"
set -v
docker build -t avezila/postgresql:4 .
docker tag avezila/postgresql:4 nirhub.ru:30050/postgresql:4

