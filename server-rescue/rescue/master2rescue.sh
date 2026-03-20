#!/bin/sh
DB_REMOTE_HOST="192.168.1.1"
DB_REMOTE_USERNAME="passbolt-rescue"
DB_REMOTE_PASSWORD="very-secret-password"
DB_LOCAL_USERNAME="passbolt-rescue"
DB_LOCAL_PASSWORD="very-secret-password"
BIN_MYSQL="/usr/bin/mysql"
BIN_MYSQLDUMP="/usr/bin/mysqldump"
TMP_PASSBOLTSQL="/var/www/passbolt/rescue/passbolt.sql"

restore_httpd() {
    systemctl start httpd
}

echo "Backup..."
"${BIN_MYSQLDUMP}" -h "${DB_REMOTE_HOST}" -u "${DB_REMOTE_USERNAME}" -p"${DB_REMOTE_PASSWORD}" --single-transaction --quick --skip-lock-tables --extended-insert --no-autocommit passbolt > "${TMP_PASSBOLTSQL}"
if [ $? -ne 0 ]; then
    echo "mySQLDump error... Nothing to do."
    exit 1
fi

echo "Restore..."
systemctl stop httpd
trap restore_httpd EXIT

"${BIN_MYSQL}" -h localhost -u "${DB_LOCAL_USERNAME}" -p"${DB_LOCAL_PASSWORD}" -e "DROP DATABASE IF EXISTS passbolt; CREATE DATABASE IF NOT EXISTS passbolt CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
"${BIN_MYSQL}" -h localhost -u "${DB_LOCAL_USERNAME}" -p"${DB_LOCAL_PASSWORD}" --init-command="SET SESSION foreign_key_checks=0; SET SESSION unique_checks=0;" passbolt < "${TMP_PASSBOLTSQL}"

trap - EXIT
systemctl start httpd
echo "End."
