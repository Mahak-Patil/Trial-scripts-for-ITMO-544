#!/bin/bash
# creating security group usong vpc "vpc-2ea45e4a"
#while transfering, DO NOT pass hard coded vpc

SecurityGroupID=$(aws ec2 create-security-group --group-name ITMO-544-Security-Group --description "Security group" --vpc-id vpc-2ea45e4a --output=textawk|'{print $1}')
echo "\n"$SecurityGroupID
