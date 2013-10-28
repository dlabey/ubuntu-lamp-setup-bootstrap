#!/bin/bash
# Interactive Server Setup For Ubuntu Server LTS With:
# Security, VIM, Logrotate, MySQL, Apache, PHP, PHP-FPM, Varnish, And SFTP

# Update apt-get & Upgrade Stuff
apt-get update
apt-get upgrade
echo 'Updated and upgraded apt-get.'

# Setup Firewall & Allow SSH
apt-get install ufw
ufw enable
ufw allow ssh
echo 'Setup Firewall and allowed SSH.'

# Setup VIM
apt-get install vim
echo 'Setup VIM.'

# Setup Logrotate
apt-get install logrotate
cp /etc/logrotate.d/apache2 /etc/logrotate.d
echo 'Setup Logrotate.'

# Setup MySQL
apt-get install mysql-server
ufw allow mysql
echo 'Setup MySQL.'

# Setup Apache
echo deb http://us.archive.ubuntu.com/ubuntu/ quantal multiverse >> /etc/apt/sources.list
echo deb-src http://us.archive.ubuntu.com/ubuntu/ quantal multiverse >> /etc/apt/sources.list
echo deb http://us.archive.ubuntu.com/ubuntu/ quantal-updates multiverse >> /etc/apt/sources.list
echo deb-src http://us.archive.ubuntu.com/ubuntu/ quantal-updates multiverse >> /etc/apt/sources.list
apt-get update
apt-get install apache2
apt-get install libapache2-mod-fastcgi
apt-get install apache2-mpm-worker
a2enmod actions fastcgi alias rewrite
cp etc/apache2/mods-available/* /etc/apache2/mods-available
cp etc/apache2/ports.conf /etc/apache2/ports.conf
echo 'Setup Apache.'

# Setup PHP & PHP-FPM
apt-get install php5
apt-get install php5-fpm
apt-get install php5-mysql
echo 'Setup PHP and PHP-FPM.'

# Setup Varnish
curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -
echo deb http://repo.varnish-cache.org/ubuntu/ lucid varnish-3.0 > /etc/apt/sources.list.d/varnish.list
apt-get update
apt-get install varnish
sed -i 's/DAEMON_OPTS="-a :6081/DAEMON_OPTS="-a :80/g' /etc/default/varnish
echo 'Setup Varnish.'

# Setup SFTP
groupadd www-users
useradd www-user
echo 'Set password for www-user:'
passwd www-user
usermod -a -G www-users www-user
usermod -a -G www-data www-user
echo '' >> /etc/ssh/sshd_config
echo 'Match Group www-users' >> /etc/ssh/sshd_config
echo 'ChrootDirectory /var/www' >> /etc/ssh/sshd_config
echo 'ForceCommand internal-sftp' >> /etc/ssh/sshd_config

# Setup Web Directory
mkdir /var/www/mywebsite
chgrp www-data /var/www
chmod 755 /var/www
chgrp www-data /var/www/mywebsite
chmod 776 /var/www/mywebsite
cp etc/apache2/sites-available/* /etc/apache2/sites-available
ln -s /etc/apache2/sites-available/mywebsite /etc/apache2/sites-enabled

ufw allow http
ufw allow https
service apache2 restart
service varnish restart
service ssh restart
echo 'Server setup.'