#!/bin/bash

databases=(
    "address-registry-events"
    "address-registry"
    "building-registry-events"
    "building-registry"
    "municipality-registry-events"
    "municipality-registry"
    "parcel-registry-events"
    "parcel-registry"
    "postal-registry-events"
    "postal-registry"
    "streetname-registry-events"
    "streetname-registry"
)

for db in ${databases[@]}
do
    echo -e "\nStart rebuild indexes for $db"

    sqlcmd \
        -S $db_server `# sql-server address` \
        -U $db_user \
        -P $db_password \
        -d $db `# set database (USE [$db])` \
        -I `# set quoted_indentifier` \
        -i ./rebuild.sql `#use script`

    echo -e "Finished rebuilding indexes for $db\n"
done
