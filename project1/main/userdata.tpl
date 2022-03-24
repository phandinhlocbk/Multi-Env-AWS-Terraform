#!/bin/bash
yum update -y

## Apache　Setup
yum install -y httpd
chown -R apache:apache /var/www/html
echo "hello" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
