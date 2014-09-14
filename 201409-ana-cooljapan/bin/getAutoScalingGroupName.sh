#!/bin/bash
cd $(dirname -- "$0") || exit 1
profile="${AWS_DEFAULT_PROFILE:-main-ro}"
region="${AWS_DEFAULT_REGION:-us-east-1}"
stackName="${1:-ana-cooljapan}"

aws --profile "$profile" --region "$region" \
  cloudformation describe-stack-resources \
  --stack-name "$stackName" \
  |
jq -r '
.StackResources[] |
  select(
    .LogicalResourceId=="AutoScalingGroup" and
    (.ResourceStatus|endswith("_COMPLETE"))
  )
  .PhysicalResourceId
'
