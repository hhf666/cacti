MYSQL_ROOT_PASSWORD=cacti
MYSQL_DATABASE=cacti
MYSQL_USER=cactiuser
MYSQL_PASSWORD=cactiuser
MYSQL_PORT=3306

docker run -d --name mysql -p 3306:3306 \
-v /opt/mysql/conf.d:/etc/mysql/conf.d \
-v /opt/mysql/data:/var/lib/mysql \
-e TZ=Asia/Shanghai \
-e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
-e MYSQL_USER=$MYSQL_PASSWORD \
-e MYSQL_PASSWORD=$MYSQL_PASSWORD \
mysql
#percona

