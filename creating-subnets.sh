#!/bin/bash
echo "Enter image id: (ami-d05e75b8)"

VpcID=$(aws ec2 create-vpc --cidr-block 172.3.0.0/28 --output=text |awk '{print $1}')
echo "\n"$VpcID
SubnetID=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block 172.3.0.0/28 --output=text|awk '{print $1}')
echo "\n"$SubnetID

echo "Sleeping for one minute"
for i in {0..60}
do
echo -ne '.'
sleep 1
done
