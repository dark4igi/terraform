#!/bin/bash
sudo -s
yum -y update
yum install -y httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<h2>Build by Power of terraform <font color='green'> v0.13 </font></h2><br>
Owner ${f_name} ${l_name} <br>

%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}

</html>
EOF

sudo service httpd start
sudo chkconfig httpd on
