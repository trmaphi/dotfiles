exec_ecs() {
  read -r aws_profile <<< $(aws configure list-profiles | fzf --prompt="Select Profiles: ")

  if [ -z "$aws_profile" ]
  then
    echo "No profile provided"
    return
  fi
  read -r clusterPrefix clusterName <<< $(aws --profile $aws_profile ecs list-clusters --output json | jq -r '.clusterArns[] | split("/") | join(" ")' |  fzf --prompt="Select Cluster: " | awk '{print $1,$2}')

  if [ -z "$clusterName" ]
  then
    echo "No cluster selected"
    return
  fi

  read -r taskPrefix taskId <<< $(aws --profile $aws_profile ecs list-tasks --cluster $clusterName --output json | jq -r '.taskArns[] | split("/") | join(" ")' | fzf --prompt="Select Task: " | awk '{print $1,$3}')
  
  if [ -z "$taskId" ]
  then
    echo "No TaskId selected"
    return
  fi
  # Get the list of container names for the selected task
  read -r containerId containerName <<<$(aws --profile $aws_profile ecs describe-tasks --cluster $clusterName --tasks $taskId --query "tasks[].containers[].{containerArn:containerArn, name:name}" | jq -r '.[] | {name: .name, id: .containerArn | split("/") | .[3]} | "\(.name) \(.id)"' | fzf --prompt="Select Container: "  | awk '{print $2,$1}')
  if [ -n "$containerId" ]
  then
    aws --profile $aws_profile ecs execute-command --cluster $clusterName --task $taskId --container $containerName --interactive --command "/bin/sh"
  fi
}

connect_to_redis() {
  read -r aws_profile <<< $(aws configure list-profiles | fzf --prompt="Select Profiles To Redis: ")

  if [ -z "$aws_profile" ]
  then
    echo "No profile provided"
    return
  fi
  
  # select the redis cluster
  selected_redis=$(aws --profile $aws_profile elasticache describe-cache-clusters --show-cache-node-info --query "CacheClusters[].{id:CacheClusterId, address:CacheNodes[0].Endpoint.Address}" | jq -r '.[] | "\(.id) \(.address)"' | fzf --prompt="Select Redis Cluster: "| awk {'print $2'})
  if [ -z "$selected_redis" ]
  then
    echo "No Redis Cluster selected"
    return
  fi

  read -r aws_profile_ecs <<< $(aws configure list-profiles | fzf --prompt="Select Profiles To Use ECS: ")

  if [ -z "$aws_profile_ecs" ]
  then
    echo "No profile provided"
    return
  fi

  read -r clusterPrefix clusterName <<< $(aws --profile $aws_profile_ecs ecs list-clusters --output json | jq -r '.clusterArns[] | split("/") | join(" ")' |  fzf  | awk '{print $1,$2}')
  if [ -z "$clusterName" ]
  then
    echo "No cluster selected"
    return
  fi
  read -r taskPrefix taskId <<< $(aws --profile $aws_profile_ecs ecs list-tasks --cluster $clusterName --output json | jq -r '.taskArns[] | split("/") | join(" ")' | fzf  | awk '{print $1,$3}')
  if [ -z "$taskId" ]
  then
    echo "No TaskId selected"
    return
  fi
  
  # Get the list of container names for the selected task
  read -r containerId containerName <<<$(aws --profile $aws_profile_ecs ecs describe-tasks --cluster $clusterName --tasks $taskId --query "tasks[].containers[].{containerArn:runtimeId, name:name}" | jq -r '.[] | {name: .name, id: .containerArn} | "\(.name) \(.id)"' | fzf  | awk '{print $2,$1}')
  if [ -n "$containerId" ]
  then
    targetId="ecs:${clusterName}_${taskId}_${containerId}"
    aws --profile $aws_profile_ecs ssm start-session --target $targetId --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"host":["'"$selected_redis"'"],"portNumber":["6379"], "localPortNumber":["6390"]}'
  fi
}