docker exec -it nirhub_postgres pgmigrate -d /pgmigrate -c postgresql://postgres@localhost/nirhub "$@"
