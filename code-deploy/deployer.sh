#!/bin/bash  

set -e

EXPORT_NAME=$(jq -r ".Exports | map(select(.Name == \"$ENV_TYPE-TaskDefinitionArn\")) | .[0].Value" <<< $(aws --profile=college cloudformation list-exports))

sed "s/TASK_DEFINITION_ARN_PLACEHOLDER/$EXPORT_NAME/" appspec.template.yaml > appspec.yaml
