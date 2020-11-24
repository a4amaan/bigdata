#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "postgres"  <<-EOSQL
    CREATE USER hiveuser WITH PASSWORD 'hupass!@';
    CREATE DATABASE metastore;
    GRANT ALL PRIVILEGES ON DATABASE metastore TO hiveuser;
EOSQL

psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
  \c metastore
  \i /docker-entrypoint-initdb.d/hive-schema-2.3.0.postgres.sql
  \i /docker-entrypoint-initdb.d/hive-txn-schema-2.3.0.postgres.sql
  \pset tuples_only
  \o /tmp/grant-privs
SELECT 'GRANT SELECT,INSERT,UPDATE,DELETE ON "' || schemaname || '"."' || tablename || '" TO hiveuser ;'
FROM pg_tables
WHERE tableowner = CURRENT_USER and schemaname = 'public';
  \o
  \i /tmp/grant-privs
EOSQL