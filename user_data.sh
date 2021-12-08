#!/bin/bash

# update all software
yum -y update

# install htop
yum -y install htop

# aws config folder
mkdir -p /root/.aws
# generate the config file
echo '[default]
region = us-east-1
' > /root/.aws/config
# copy aws config to /home/ec2-user
cp -r /root/.aws /home/ec2-user
chown -R ec2-user /home/ec2-user

# copy files from s3
aws s3 cp s3://peadar-cloudinit-lab/qprocessor.py /home/ec2-user
aws s3 cp s3://peadar-cloudinit-lab/qprocessor.service /home/ec2-user
chown -R ec2-user /home/ec2-user

# move service unit file in
mv /home/ec2-user/qprocessor.service /etc/systemd/system/qprocessor.service

# install boto3 library
pip3 install boto3

# enable & start service
systemctl daemon-reload
systemctl enable qprocessor
systemctl start qprocessor

