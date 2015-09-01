#!/bin/bash

RET=1

while [[ RET -ne 0 ]]; do
    sleep 1;
    mysql -e 'exit' > /dev/null 2>&1; RET=$?
done

DB_NAME=${DB_NAME:-database}

mysqladmin -u root create $DB_NAME

if [ -n "$INIT" ]; then
    /data/$INIT
fi
