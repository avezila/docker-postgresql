docker exec -it nirhub_postgres pgmigrate -d /pgmigrate -c postgresql://postgres:$DB_PASS@$DB_HOST/nirhub "$@"
