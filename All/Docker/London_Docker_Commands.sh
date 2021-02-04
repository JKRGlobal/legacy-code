#  London_Docker_Commands.sh
#  Created by Stephen Warneford-Bygrave on 2016-01-27

# ldn-proxy

sudo docker run \
    --name=ldn-proxy \
    --detach \
    --publish=192.168.254.246:80:80 \
    --volume=/var/run/docker.sock:/tmp/docker.sock \
    --volume=/etc/localtime:/etc/localtime:ro \
    --restart=always \
    jwilder/nginx-proxy

# ldn-bsdpy

sudo docker run \
    --name=ldn-bsdpytftp \
    --detach \
    --publish=192.168.254.246:69:69/udp \
    --volume=/data/docker/ldn-bsdpy/nbi:/nbi \
    --volume=/etc/localtime:/etc/localtime:ro \
    --restart=always \
    macadmins/tftpd \
    && \
sudo docker run \
    --name=ldn-bsdpyhttp \
    --detach \
    --publish=192.168.254.247:80:80 \
    --volume=/data/docker/ldn-bsdpy/nbi:/nbi \
    --volume=/etc/localtime:/etc/localtime:ro \
    --restart=always \
    macadmins/netboot-httpd \
    && \
sudo docker run \
    --name=ldn-bsdpy \
    --detach \
    --publish=192.168.254.246:67:67/udp \
    --volume=/data/docker/ldn-bsdpy/nbi:/nbi \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=BSDPY_NBI_URL=http://192.168.254.247 \
    --env=BSDPY_IP=192.168.254.246 \
    --env=BSDPY_PROTO=http \
    --restart=always \
    bruienne/bsdpy:1.0 \
    && \
    sudo chmod 777 /data/docker/ldn-bsdpy/nbi

# ldn-munkirepo

sudo docker run \
    --name=ldn-munkirepo \
    --detach \
    --publish=192.168.254.246:8081:80 \
    --volume=/data/docker/ldn-munkirepo:/munki_repo \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=ldn-munkirepo \
    --restart=always \
    macadmins/munki \
    && \
    sudo chmod -R 777 /data/docker/ldn-munkirepo

# ldn-imagrrepo

sudo docker run \
    --name=ldn-imagrrepo \
    --detach \
    --publish=192.168.254.246:8082:80 \
    --volume=/data/docker/ldn-imagrrepo/repo:/usr/share/nginx/html \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=ldn-imagrrepo \
    --restart=always \
    nginx \
    && \
    sudo chmod -R 777 /data/docker/ldn-imagrrepo/repo

# ldn-afp

sudo docker run \
    --name=ldn-afp \
    --detach \
    --net=host \
    --publish=192.168.254.246:548:548 \
    --volume=/data/docker/ldn-afp/afp.conf:/etc/afp.conf \
    --volume=/data/docker/ldn-munkirepo:/media/munki \
    --volume=/data/docker/ldn-bsdpy/nbi:/media/bsdpy \
    --volume=/data/docker/ldn-imagrrepo/repo:/media/imagr \
    --volume=/etc/localtime:/etc/localtime:ro \
    --restart=always \
    cptactionhank/netatalk 

# ldn-munkireportdb

sudo docker run \
    --name=ldn-munkireportdb \
    --detach \
    --publish=192.168.254.246:3306:3306 \
    --volume=/data/docker/ldn-munkireportdb:/var/lib/mysql \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=MYSQL_DATABASE=ldn-munkireportdb \
    --env=MYSQL_ROOT_PASSWORD=pass \
    --env=VIRTUAL_HOST=ldn-munkireportdb \
    --restart=always \
    mysql/mysql-server:5.6

# ldn-munkireport

sudo docker run \
    --name=ldn-munkireport \
    --detach \
    --publish=192.168.254.246:8083:80 \
    --volume=/data/docker/ldn-munkireport/config.php:/www/munkireport/config.php \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=ldn-munkireport,munkireport.corp.jkrglobal.com \
    --env=MR_SITENAME=MunkiReport \
    --env=MR_TIMEZONE=Europe/London \
    --restart=always \
    hunty1/munkireport-docker:2.8.4

# ldn-reposado

sudo docker run \
    --name=ldn-reposado \
    --detach \
    --publish=192.168.254.246:8084:8088 \
    --volume=/data/docker/ldn-reposado/preferences.plist:/reposado/code/preferences.plist \
    --volume=/data/docker/ldn-reposado/reposado.conf:/etc/nginx/sites-enabled/reposado.conf \
    --volume=/data/docker/ldn-reposado/html:/reposado/html \
    --volume=/data/docker/ldn-reposado/metadata:/reposado/metadata \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=ldn-reposado \
    --env=VIRTUAL_PORT=8088 \
    --restart=always \
    mscottblake/reposado

# ldn-margarita

sudo docker run \
    --name=ldn-margarita \
    --detach \
    --publish=192.168.254.246:8085:8089 \
    --volumes-from ldn-reposado \
    --volume=/data/docker/ldn-reposado/preferences.plist:/margarita/preferences.plist \
    --volume=/data/docker/ldn-reposado/extras.conf:/extras.conf \
    --volume=/data/docker/ldn-reposado/.htpasswd:/margarita/.htpasswd \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=VIRTUAL_HOST=ldn-margarita \
    --restart=always \
    mscottblake/margarita

sudo docker exec ldn-reposado repo_sync && \
sudo docker exec ldn-reposado repoutil --purge-product all-deprecated && \
sudo docker exec ldn-margarita chgrp -R www-data /reposado && \
sudo docker exec ldn-margarita chmod -R g+rw /reposado

# ldn-munki-do

sudo docker run \
    --name=ldn-munki-do \
    --detach \
    --restart=always \
    --publish=192.168.254.246:8086:8000 \
    --volume=/data/docker/ldn-munkirepo:/munki_repo \
    --volume=/data/docker/ldn-munki-do/db:/munki-do-db \
    --volume=/data/docker/ldn-munki-do/ssh/id_rsa:/root/.ssh/id_rsa \
    --env=DOCKER_MUNKIDO_GIT_PATH="/usr/bin/git" \
    --env=DOCKER_MUNKIDO_GIT_BRANCHING="yes" \
    --env=DOCKER_MUNKIDO_GIT_IGNORE_PKGS="yes" \
    --env=DOCKER_MUNKIDO_MANIFEST_RESTRICTION_KEY="restriction" \
    --env=DOCKER_MUNKIDO_PRODUCTION_BRANCH="production" \
    --env=VIRTUAL_HOST=ldn-munki-do \
    grahamrpugh/munki-do

# ldn-postfix

sudo docker run \
    --name=ldn-postfix \
    --detach \
    --publish=192.168.254.246:25:25 \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=MTP_HOST=LN01-V-DEP01.jkr.co.uk \
    --env=MTP_RELAY=cluster4out.eu.messagelabs.com \
    --env=MTP_PORT=25 \
    --env=MTP_ALLOWED_IPS="172.16.48.128 192.168.200.0/24 192.168.211.11 192.168.254.0/24"\
    --restart=always \
    wegotoeleven/postfix

# ldn-gitlab

sudo docker run \
    --name=ldn-gitlab \
    --detach \
    --publish=8087:80 \
    --publish=2222:22 \
    --volume=/data/docker/ldn-gitlab/appdata:/var/opt/gitlab \
    --volume=/data/docker/ldn-gitlab/logs:/var/log/gitlab \
    --volume=/data/docker/ldn-gitlab/config:/etc/gitlab \
    --volume=/etc/localtime:/etc/localtime:ro \
    --env=GITLAB_OMNIBUS_CONFIG="external_url 'http://gitlab.corp.jkrglobal.com'; gitlab_rails['time_zone'] = 'UTC'; gitlab_rails['gitlab_shell_ssh_port'] = 2222; gitlab_rails['smtp_enable'] = true; gitlab_rails['smtp_address'] = 'ln01-v-dep01'; gitlab_rails['smtp_port'] = 25; gitlab_rails['smtp_authentication'] = 'false';" \
    --env=VIRTUAL_HOST=gitlab.corp.jkrglobal.com \
    --restart=always \
    gitlab/gitlab-ce:8.4.4-ce.0