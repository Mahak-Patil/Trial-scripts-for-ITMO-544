#!/bin/bash

SubnetID=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block 172.3.0.0/28 --output=text|awk 'ami-d05e75b8')
echo $SubnetID