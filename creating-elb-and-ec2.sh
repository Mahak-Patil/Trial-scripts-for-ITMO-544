#!/bin/bash
# CAUTION: SCRIPT TAKES YEARS TO EXECUTE!
# edit install-websever.sh path name
# target of health check policy is currently "index.php"
# all commands have hard coded values

# creating elb 
ElbUrl=$(aws elb create-load-balancer --load-balancer-name ITMO-544-Load-Balancer --security-groups sg-414a0a26 --subnets subnet-0fdfdd78 --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --output=text)
echo "\nLaunched ELB and sleeping for one minute"
for i in {0..60}
 do
  echo -ne '.'
  sleep 1;
  done

# configuring health check
aws elb configure-health-check --load-balancer-name ITMO-544-Load-Balancer --health-check Target=HTTP:80/index.php,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3
echo -e "\nConfigured ELB health check. Proceeding to launch EC2 instances"
  
# launching ec2 instances
aws ec2 run-instances --image-id ami-d05e75b8 --count 3 --instance-type t2.micro --key-name ITMO-544-Key-Pair --user-data file://install-webserver.sh --subnet-id subnet-0fdfdd78 --output text --security-group-ids sg-414a0a26 --iam-instance-profile Name=phpDeveloper
echo -e "\nLaunched 3 EC2 Instances and sleeping for one minute"
for i in {0..60}
 do
  echo -ne '.'
  sleep 1;
  done
  
 
# registering instances with crested elb
declare -a instance_list
mapfile -t instance_list < <(aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --key-name $4 --security-group-ids $5 --subnet-id $6 --associate-public-ip-address --iam-instance-profile Name=$7 --user-data file://install-webserver.sh --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g")
aws ec2 wait instance-running --instance-ids ${instance_list[@]} 
aws ec2 wait instance-running --instance-ids ${instance_list[@]} 
echo "Following instances running: ${instance_list[@]}" 
echo "\nAdding above to an array and registering with the load balancer." 
len=${#instance_list[@]}
for (( i=0; i<${#instance_list[@]}; i++)); 
  do
  echo "Registering ${instance_list[$i]} with load-balancer ITMO-544-Load-Balancer" 
  aws elb register-instances-with-load-balancer --load-balancer-name ITMO-544-Load-Balancer --instances ${instance_list[$i]} --output=table 
echo -e "\n Sleeping for one minute to complete the process."
    for y in {0..60} 
    do
      echo -ne '.'
      sleep 1
    done
 echo "\n"
done