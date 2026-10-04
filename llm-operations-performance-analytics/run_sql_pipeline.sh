#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${MSSQL_SA_PASSWORD:-}" ]]; then
  echo "MSSQL_SA_PASSWORD is not set."
  echo 'Example: export MSSQL_SA_PASSWORD="your-local-password"'
  exit 1
fi

SQLCMD="/opt/mssql-tools18/bin/sqlcmd"

run_script() {
  local script="$1"
  echo
  echo "Running ${script}..."
  docker exec sqlserver-ai "${SQLCMD}" \
    -S localhost \
    -U sa \
    -P "${MSSQL_SA_PASSWORD}" \
    -C \
    -i "/data/${script}"
}

run_script "sql/01_create_schema.sql"
run_script "sql/02_load_staging.sql"
run_script "sql/03_transform.sql"
run_script "sql/04_create_budgets.sql"

echo
echo "Pipeline completed."
