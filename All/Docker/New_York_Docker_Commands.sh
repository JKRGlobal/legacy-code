#  New_York_Docker_Commands.sh
#  Created by Stephen Warneford-Bygrave on 2016-01-27

# nyc-proxy

sudo docker run \
    --name=nyc-proxy \
    --detach \
    --publish=192.168.12.226:80:80 \
    --volume=/var/run/docker.sock:/tmp/docker.sock \
    --volume=/etc/localtime:/etc/localtime:ro \
    --restart=always \
    jwilder/nginx-proxy

# nyc-bsdpy

sudo docker run \
    --name=nyc-bsdpytftp \
    --detach \
    --publish=192.168.12.226:69:69/udp \
    --volume=/data/docker/nyc-bsdpy/nbi:/nbi \
    --volume=/etc/localtime:/etc/localtime:ro \
    --restart=always \
    macadmins/tftpd \
    && \
sudo docker run \
    --name=nyc-bsdpyhttp \
    --detach \
    --publish=192.168.12.227:80:80 \
    --volume=/data/docker/nyc-bsdpy/nbi:/nbi \
    --volume=/etc/localtime:/etc/localtime:ro \
    --restart=always \
    macadmins/netboot-httpd \
    && \
sudo docker run \
    --name=nyc-bsdpy \
    --detach \
    --publish=67:67/udp \
    --volume=/data/docker/nyc-bsdpy/nbi:/nbi \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=BSDPY_NBI_URL=http://192.168.12.227 \
    --env=BSDPY_IP=192.168.12.226 \
    --env=BSDPY_PROTO=http \
    --restart=always \
    bruienne/bsdpy:1.0 \
    && \
    sudo chmod 777 /data/docker/nyc-bsdpy/nbi

# nyc-munkirepo

sudo docker run \
    --name=nyc-munkirepo \
    --detach \
    --publish=192.168.12.226:8081:80 \
    --volume=/data/docker/nyc-munkirepo:/munki_repo \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=nyc-munkirepo \
    --restart=always \
    macadmins/munki \
    && \
    sudo chmod -R 777 /data/docker/nyc-munkirepo

# nyc-imagrrepo

sudo docker run \
    --name=nyc-imagrrepo \
    --detach \
    --publish=192.168.12.226:8082:80 \
    --volume=/data/docker/nyc-imagrrepo/repo:/usr/share/nginx/html \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=nyc-imagrrepo \
    --restart=always \
    nginx

# nyc-afp

sudo docker run \
    --name=nyc-afp \
    --detach \
    --net=host \
    --publish=192.168.12.226:548:548 \
    --volume=/data/docker/nyc-afp/afp.conf:/etc/afp.conf \
    --volume=/data/docker/nyc-munkirepo:/media/munki \
    --volume=/data/docker/nyc-bsdpy/nbi:/media/bsdpy \
    --volume=/data/docker/nyc-imagrrepo/repo:/media/imagr \
    --volume=/etc/localtime:/etc/localtime:ro \
    --restart=always \
    cptactionhank/netatalk

# nyc-munkireportdb

sudo docker run \
    --name=nyc-munkireportdb \
    --detach \
    --publish=192.168.12.226:3306:3306 \
    --volume=/data/docker/nyc-munkireportdb:/var/lib/mysql \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=MYSQL_DATABASE=nyc-munkireportdb \
    --env=MYSQL_ROOT_PASSWORD=pass \
    --env=VIRTUAL_HOST=nyc-munkireportdb \
    --restart=always \
    mysql/mysql-server:5.6

# nyc-munkireport

sudo docker run \
    --name=nyc-munkireport \
    --detach \
    --publish=192.168.12.226:8083:80 \
    --volume=/data/docker/nyc-munkireport/config.php:/www/munkireport/config.php \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=nyc-munkireport \
    --restart=always \
    hunty1/munkireport-docker:2.6.0

# nyc-reposado

sudo docker run \
    --name=nyc-reposado \
    --detach \
    --publish=192.168.12.226:8088:8088 \
    --volume=/data/docker/nyc-reposado/preferences.plist:/reposado/code/preferences.plist \
    --volume=/data/docker/nyc-reposado/reposado.conf:/etc/nginx/sites-enabled/reposado.conf \
    --volume=/data/docker/nyc-reposado/html:/reposado/html \
    --volume=/data/docker/nyc-reposado/metadata:/reposado/metadata \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=nyc-reposado \
    --env=VIRTUAL_PORT=8088 \
    --restart=always \
    mscottblake/reposado

# nyc-margarita

sudo docker run \
    --name=nyc-margarita \
    --detach \
    --publish=192.168.12.226:8085:8089 \
    --volumes-from nyc-reposado \
    --volume=/data/docker/nyc-reposado/preferences.plist:/margarita/preferences.plist \
    --volume=/data/docker/nyc-reposado/extras.conf:/extras.conf \
    --volume=/data/docker/nyc-reposado/.htpasswd:/margarita/.htpasswd \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=nyc-margarita \
    --restart=always \
    mscottblake/margarita

sudo docker exec nyc-reposado repo_sync && \
sudo docker exec nyc-reposado repoutil --purge-product all-deprecated && \
sudo docker exec nyc-margarita chgrp -R www-data /reposado && \
sudo docker exec nyc-margarita chmod -R g+wr /reposado

# nyc-postfix

sudo docker run \
    --name=nyc-postfix \
    --detach \
    --publish=192.168.12.226:25:25 \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=MTP_HOST=NY01-V-DEP01.jkr.co.uk \
    --env=MTP_RELAY=cluster4out.eu.messagelabs.com \
    --env=MTP_PORT=25 \
    --env=MTP_ALLOWED_IPS="192.168.12.230 192.168.12.231 192.168.12.225" \
    --restart=always \
    wegotoeleven/postfix