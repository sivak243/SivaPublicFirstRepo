#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo “Welcome to Terraform EC2 MAchine: $(hostname -f)” > /var/www/html/index.html