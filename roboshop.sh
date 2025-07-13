#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-050181a88007d400e"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "payment" "dispatch" "frontend")
ZONE_ID="Z0072111386H9FAC3M1H8"
DOMAIN_NAME="nareshveeranala.shop"

for instance in ${INSTANCES[@]}
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t2.micro --security-group-ids sg-050181a88007d400e --tag-specifications 'ResourceType=instance,Tags=[{key=Name,value=$instance}]' --query "Instances[0].InstanceId" --output text)
    if [ $instance != "frontend" ]
    then
        Ip=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query 'eservations[0].Instances[0].PrivateIpAddress' --output text)
    else
        Ip=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query 'eservations[0].Instances[0].PublicIpAddress' --output text)
    fi
    echo "$instance Ip address: $IP"
done