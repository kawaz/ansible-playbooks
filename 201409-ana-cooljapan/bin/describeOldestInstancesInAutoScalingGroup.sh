#!/bin/bash
cd $(dirname -- "$0") || exit 1
profile="${AWS_DEFAULT_PROFILE:-main-ro}"
region="${AWS_DEFAULT_REGION:-us-east-1}"
asName="${1:-$(./getAutoScalingGroupName.sh)}"

instanceIds=$(
aws --profile "$profile" --region "$region" \
  autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names "$asName" \
  |
jq -r '
.AutoScalingGroups[].Instances[]
| select(.LifecycleState == "InService")
.InstanceId
'
)


aws --profile "$profile" --region "$region" \
  ec2 describe-instances --instance-ids "${instanceIds[@]}"
