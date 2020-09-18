jq ".Exports | map(select(.Name == \"$ENV_TYPE-TaskDefinitionArn\")) | .[0].Value' <<< $(aws cloudformation list-exports)
