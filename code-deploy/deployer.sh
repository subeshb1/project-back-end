#!/bin/bash  

aws --region $AWS_DEFAULT_REGION cloudformation list-exports

TASK_DEF_ARN=$(jq -r ".Exports | map(select(.Name == \"${ENV_TYPE}-TaskDefinitionArn\")) | .[0].Value" <<< $(aws --region $AWS_DEFAULT_REGION cloudformation list-exports))

jq '.taskDefinition | del(.taskDefinitionArn) | .image = "<IMAGE_PLACEHOLDER>" ' <<<$(aws --region $AWS_DEFAULT_REGION  ecs describe-task-definition --task-definition $TASK_DEF_ARN) > taskdef.json
