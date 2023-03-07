#!/bin/bash

registries=("municipality" "streetname" "address" "building" "postal" "parcel" "road")

for registry in ${registries[@]}
do
    dbs=("${registry}-registry" "${registry}-registry-events")

    for db in ${dbs[@]}
    do
        server="db_${registry}_server"
        user="db_${registry}_user"
        password="db_${registry}_password"

        echo -e "\nRebuild indexes for $db"  

        echo "Server: " ${!server}
        echo "User": ${!user}

        sqlcmd \
            -S ${!server} \
            -U ${!user} \
            -P ${!password} \
            -d $db `# set database (USE [$db])` \
            -I `# set quoted_indentifier` \
            -i ./rebuild.sql `#use script`

        echo -e "Finished rebuilding indexes for $db\n"     
    done
done
