#!/bin/bash
# CAUTION: SCRIPT TAKES YEARS TO EXECUTE!
#target of health check policy is currently "index.php"

ElbUrl=$(aws elb create-load-balancer --load-balancer-name ITMO-544-Load-Balancer --security-groups sg-414a0a26 --subnets subnet-0fdfdd78 --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --output=text)
echo "\nLaunched ELB and sleeping for one minute"
for i in {0..60}
 do
  echo -ne '.'
  sleep 1;
  done

aws elb configure-health-check --load-balancer-name ITMO-544-Load-Balancer --health-check Target=HTTP:80/index.php,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3
echo -e "\nConfigured ELB health check and sleeping for one minute"
for i in {0..60}
 do
  echo -ne '.'
  sleep 1;
  done
  
aws ec2 run-instances --image-id ami-d05e75b8 --count 3 --instance-type t1.micro --key-name ITMO-544-Key-Pair.pem --user-data file://install-webserver.sh --subnet-id subnet-0fdfdd78 --output text --security-group-ids sg-414a0a26 --iam-instance-profile Name=phpDeveloper
echo -e "\nLaunched 3 EC2 Instances and sleeping for one minute"
for i in {0..60}
 do
  echo -ne '.'
  sleep 1;
  done
  
declare -a ARRAY 
ARRAY=(`aws ec2 describe-instances --filters --output text Name=client-token,Values=$clientTkns | grep INSTANCES | awk {'print $8'}`)
echo -e "\nListing Instances, filtering their instance-id, adding them to an ARRAY and sleeping 15 seconds"
for i in {0..15}; do echo -ne '.'; sleep 1;done
LENGTH=${#ARRAY[@]}
echo "ARRAY LENGTH IS $LENGTH"
for (( i=0; i<${#ARRAY[@]}; i++)); 
  do
  echo "Registering ${ARRAY[$i]} with load-balancer $1" 
  aws elb register-instances-with-load-balancer --load-balancer-name $1 --instances ${ARRAY[$i]} --output=table 
echo -e "\nLooping through instance array and registering each instance one at a time with the load-balancer.  Then sleeping 60 seconds to allow the process to finish."
    for y in {0..60} 
    do
      echo -ne '.'
      sleep 1
    done
 echo "\n"
done