#!/bin/bash
# subnets hard coded: subnet-0fdfdd78 and subnet-f7a25eca
# remove hardcoded subnet values.
# use creating-subnets to get subnet ids and pass as arguments
echo "creating db subnet with 2 subnets (needed)"
DbSubnetID=$(aws rds create-db-subnet-group --db-subnet-group-name ITMO544-Database-Subnet --subnet-ids subnet-0fdfdd78 subnet-f7a25eca --db-subnet-group-description "Database subnet" --output=text)
echo $DbSubnetID

echo "Sleeping for one minute"
for i in {0..60}
do
echo -ne '.'
sleep 1
done
echo "Done sleeping!"
