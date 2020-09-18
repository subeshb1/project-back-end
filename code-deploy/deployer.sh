#!/bin/bash  

set -e

TASK_DEF_ARN=$(jq -r ".Exports | map(select(.Name == \"${ENV_TYPE}TaskDefinitionArn\")) | .[0].Value" <<< $(aws cloudformation list-exports))

jq '.taskDefinition | del(.taskDefinitionArn) | .image = "<IMAGE_PLACEHOLDER>" ' <<<$(aws ecs describe-task-definition --task-definition $TASK_DEF_ARN) > taskdef.json
