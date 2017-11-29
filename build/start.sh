#!/bin/bash

### set server timezone
echo "$(date +%F_%R) [Note] Setting server timezone settings to '${TZ}'"
echo "date.timezone = ${TZ}" >> /etc/php.ini
rm /etc/localtime
ln -s /usr/share/zoneinfo/${TZ} /etc/localtime

### setup database credential settings
if [ ! -f /usr/local/cacti/include/config.php ]; then
    echo "Started with empty ETC, copying example data in-place"
    cp -Rp /usr/local/cacti.init/* /usr/local/cacti
fi

sed -i -e "s/%DB_HOST%/${DB_HOST}/" \
       -e "s/%DB_PORT%/${DB_PORT}/" \
       -e "s/%DB_NAME%/${DB_NAME}/" \
       -e "s/%DB_USER%/${DB_USER}/" \
       -e "s/%DB_PASS%/${DB_PASS}/" \
       -e "s/%DB_PORT%/${DB_PORT}/" \
       -e "s/%RDB_HOST%/${RDB_HOST}/" \
       -e "s/%RDB_PORT%/${RDB_PORT}/" \
       -e "s/%RDB_NAME%/${RDB_NAME}/" \
       -e "s/%RDB_USER%/${RDB_USER}/" \
       -e "s/%RDB_PASS%/${RDB_PASS}/" \
       /usr/local/cacti/include/config.php \
       /usr/local/spine/etc/spine.conf \
       /settings/*.sql

### verify if initial install steps are required, if lock file does not exist run the following   
if [ ! -f /usr/local/cacti/install.lock ]; then
       echo "$(date +%F_%R) [New Install] Lock file does not exist - new install."
       # wait for database to initialize - http://stackoverflow.com/questions/4922943/test-from-shell-script-if-remote-tcp-port-is-open
       while ! timeout 1 bash -c 'cat < /dev/null > /dev/tcp/${DB_HOST}/${DB_PORT}'; do sleep 3; done
       echo "$(date +%F_%R) [New Install] Database is up! - configuring DB located at ${DB_HOST}:${DB_PORT} (this can take a few minutes)."

       # if docker was told to setup the database then perform the following
       if [ ${INITIALIZE_DB} = 1 ]; then
              echo "$(date +%F_%R) [New Install] Container has been instructed to create new Database on remote system."
              # initial database and user setup
              echo "$(date +%F_%R) [New Install] CREATE DATABASE ${DB_NAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
              mysql -h ${DB_HOST} -uroot -p${DB_ROOT_PASS} -e "CREATE DATABASE ${DB_NAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
              # allow cacti user access to new database
              echo "$(date +%F_%R) [New Install] GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}' IDENTIFIED BY '*******';"
              mysql -h ${DB_HOST} -uroot -p${DB_ROOT_PASS} -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
              # allow required access to mysql timezone table
              echo "$(date +%F_%R) [New Install] GRANT SELECT ON mysql.time_zone_name TO '${DB_USER}' IDENTIFIED BY '*******';"
              mysql -h ${DB_HOST} -uroot -p${DB_ROOT_PASS} -e "GRANT SELECT ON mysql.time_zone_name TO '${DB_USER}' IDENTIFIED BY '${DB_PASS}';"   
              # fresh install db merge
              echo "$(date +%F_%R) [New Install] Merging vanilla cacti.sql file to database."
              mysql -h ${DB_HOST} -u${DB_USER} -p${DB_PASS} ${DB_NAME} < /usr/local/cacti/cacti.sql
       fi
       # Refactor rra 
       echo "$(date +%F_%R) Refactor the directory structure of rra files."
       /usr/bin/php /usr/local/cacti/cli/structure_rra_paths.php --proceed

       # installing supporting template files
       echo "$(date +%F_%R) [New Install] Installing supporting template files."
       cp -r /templates/resource /usr/local/cacti
       cp -r /templates/scripts /usr/local/cacti

       # install additional settings
       for filename in /settings/*.sql; do
              echo "$(date +%F_%R) [New Install] Importing settings file $filename"
              mysql -h ${DB_HOST} -u${DB_USER} -p${DB_PASS} ${DB_NAME} < $filename
       done

       # install additional templates
       for filename in /templates/*.xml; do
              echo "$(date +%F_%R) [New Install] Installing template file $filename"
              php -q /usr/local/cacti/cli/import_template.php --filename=$filename > /dev/null
       done

       # create lock file so this is not re-ran on restart
       touch /usr/local/cacti/install.lock
       echo "$(date +%F_%R) [New Install] Creating lock file, db setup complete."
fi


### correcting file permissions
echo "$(date +%F_%R) [Note] Setting cacti file permissions."
chown -R apache.apache /usr/local/cacti

# start cron service
echo "$(date +%F_%R) [Note] Starting crond service."
/usr/sbin/crond -n &

# start snmp servics
echo "$(date +%F_%R) [Note] Starting snmpd service."
/sbin/snmpd -Lf /var/log/snmpd.log &

# start web service
echo "$(date +%F_%R) [Note] Starting httpd service."
/sbin/httpd -DFOREGROUND
