#!/bin/bash

echo "[INIT] Checking JSON upload config..."

# Esperar a que MariaDB esté lista
until mysql -h db -uglpi -pglpi_pass glpidb -e "SELECT 1" &> /dev/null; do
  echo "[INIT] Waiting for database..."
  sleep 3
done

# Verificar si existe la tabla
TABLE_EXISTS=$(mysql -h db -uglpi -pglpi_pass glpidb -N -e "SHOW TABLES LIKE 'glpi_configs';")

if [ "$TABLE_EXISTS" != "glpi_configs" ]; then
  echo "[INIT] glpi_configs table not found yet. Skipping..."
  exit 0
fi

# Verificar si ya tiene JSON
HAS_JSON=$(mysql -h db -uglpi -pglpi_pass glpidb -N -e "
  SELECT value FROM glpi_configs 
  WHERE name='fileextensions' AND context='core' AND value LIKE '%json%';
")

if [ -z "$HAS_JSON" ]; then
  echo "[INIT] Adding JSON to allowed extensions..."
  mysql -h db -uglpi -pglpi_pass glpidb -e "
    UPDATE glpi_configs 
    SET value = CONCAT(value, ', json')
    WHERE name='fileextensions' AND context='core';
  "
else
  echo "[INIT] JSON already enabled."
fi
