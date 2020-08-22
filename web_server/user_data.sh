#!/bin/bash
sudo -s
yum -y update
yum install -y httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2> WebServer with IP: $myip</h2><br>Build by terraform!" > /var/www/html/index.html
sudo service httpd start
sudo chkconfig httpd on
