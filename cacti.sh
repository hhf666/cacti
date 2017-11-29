db_pid=`docker ps |grep mysql |awk '{print$1}'`
db_ip=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $db_pid`
echo $db_pid
echo $db_ip

docker run -d --name cacti -p 8081:80 -p 8443:443 \
-e INITIALIZE_DB=1 \
-e DB_HOST=$db_ip \
-e RDB_HOST=$db_ip \
-e DB_ROOT_PASS=cacti \
-e TZ=Asia/Shanghai \
-e DB_NAME=cacti \
-e DB_USER=cactiuser \
-e DB_PASS=cactiuser \
-e DB_PORT=3306 \
-e RDB_NAME=cacti \
-e RDB_USER=cactiuser \
-e RDB_PASS=cactiuser \
-e RDB_PORT=3306 \
-v /opt/cacti/cacti:/usr/local/cacti \
cacti
docker ps
