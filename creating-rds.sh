#!/bin/bash

aws rds-delete-db-subnet-group ITMO544-Database-Subnet

echo "Sleeping for three minutes"
for i in {0..180}
do
echo -ne '.'
sleep 1
done
echo "Done sleeping!"

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

aws rds create-db-instance --db-instance-identifier ITMO-544-Database --allocated-storage 5 --db-instance-class db.t1.micro --engine mysql --master-username controller --master-user-password ilovebunnies --db-subnet-group-name ITMO544-Database-Subnet --db-name ITMO-Database > database.json

echo "Sleeping for three minutes"
for i in {0..180}
do
echo -ne '.'
sleep 1
done
echo "Done sleeping!"

aws rds create-db-instance-read-replica --db-instance-identifier ITMO-544-Read-Replica --source-db-instance-identifier ITMO-544-Database --output=text 