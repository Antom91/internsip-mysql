#!/bin/bash
set -e

MYSQL_PROVISION_MARKER='/var/lib/mysql/mysql.provision'

mysqld --user=mysql &

waitingForMySQL(){
  until nc -z -v -w30 127.0.0.1 3306 &>/dev/null
  do
    echo "Waiting for MySQL..."
    sleep 5
  done
}

configureMySQL(){
  waitingForMySQL
  echo "Configuring MySQL"
  mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by "$MYSQL_ROOT_PASSWORD";
EOF
  echo "MySQL was configured succesfully"
}

checkMySQL(){
  if [ -f "$MYSQL_PROVISION_MARKER" ]; then
      echo "$MYSQL_PROVISION_MARKER exists."
  else
      configureMySQL
      touch $MYSQL_PROVISION_MARKER
  fi

  echo "MySQL Started"
  while :
  do
    MYSQL_PID=$(cat /var/run/mysqld/mysqld.pid)
    if ! ps --pid $MYSQL_PID &>/dev/null; then
        exit 1
    fi
  	 sleep 1
  done
}

checkMySQL
