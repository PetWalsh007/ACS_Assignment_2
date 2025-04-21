#!/bin/bash


TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")


INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

# Get disk 
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Push the metric to CloudWatch
aws cloudwatch put-metric-data \
  --metric-name "Database-1-DiskUsagePercent" --namespace "Assign2CustomMetrics-PW" \
  --unit Percent --value "$USAGE" --region us-east-1 \
  --dimensions InstanceId=$INSTANCE_ID