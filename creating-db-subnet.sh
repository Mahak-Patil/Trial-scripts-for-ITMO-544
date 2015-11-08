#!/bin/bash

#NOTE TO SELF: DELETE PRVIOUS VPC AND SUBNETS FROM THE CONSOLE BEFORE RUNNING THIS SCRIPT

# subnets hard coded: subnet-0fdfdd78 and subnet-f7a25eca
# remove hardcoded subnet values.
# use creating-subnets to get subnet ids and pass as arguments

#delete previous RDS subnets:
aws rds-delete-db-subnet-group ITMO544-Database-Subnet
echo "Enter image id: (ami-d05e75b8)"

VpcID=$(aws ec2 create-vpc --cidr-block 172.3.0.0/28 --output=text |awk '{print $1}')
echo "\n"$VpcID
SubnetID1=$(aws ec2 create-subnet --vpc-id $VpcID --cidr-block 172.3.0.0/28 --output=text|awk '{print $1}')
echo "\n"$SubnetID1
SubnetID2=$(aws ec2 create-subnet --vpc-id $VpcID --cidr-block 172.3.0.0/28 --output=text|awk '{print $1}')
echo "\n"$SubnetID2

echo "creating db subnet with 2 subnets (needed)"
DbSubnetID=$(aws rds create-db-subnet-group --db-subnet-group-name ITMO544-Database-Subnet --subnet-ids $SubnetID1 $SubnetID2 --db-subnet-group-description "Database subnet" --output=text)
echo "\n"$DbSubnetID

echo "Sleeping for one minute"
for i in {0..60}
do
echo -ne '.'
sleep 1
done
echo "Done sleeping!"
