#!/bin/bash
set -eo pipefail

echo "Connecting to: $SERVER"
echo "Database: $DB_NAME"
echo "User: $USERNAME"
echo "Script: $SCRIPT_FILE"

# Run the SQL script
/opt/mssql-tools/bin/sqlcmd \
  -S "$SERVER,$PORT" \
  -d "$DB_NAME" \
  -U "$USERNAME" \
  -P "$PASSWORD" \
  -i "$SCRIPT_FILE" \
  -I | tee "$LOG_FILE"
