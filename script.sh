#!/bin/bash
set +xe
set -o pipefail

SERVER=$1
DB_NAME=$2
USERNAME=$3
PASSWORD=$4
SCRIPT_FILE=$5
LOG_FILE=$6

exec 2>&1
opt/mssql-tools/bin/sqlcmd -S $SERVER -d $DB_NAME -U $USERNAME -P $PASSWORD -i $SCRIPT_FILE -I
