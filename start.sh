#!/bin/bash
name=$(cat /proc/sys/kernel/random/uuid | cut -c 1-6)

ORG=$1
PAT=$2
AGENTNAME=$3

echo "Settings vars"
export VSTS_ACCOUNT=$ORG
export VSTS_TOKEN=$PAT
export VSTS_AGENT=$AGENTNAME
export VSTS_WORK="/tmp/agent" 
export VSTS_POOL="self-hosted"
export VSTS_AGENT_PATH=/tmp/buildAgent


echo "Setting up Azure Agent"
if [[ -z $VSTS_ACCOUNT ]]
then
  echo 'Missing VSTS_ACCOUNT environment variable'
  exit 1
fi

if [[ -z $VSTS_TOKEN ]] 
then
  echo 'Missing VSTS_TOKEN environment variable'
  exit 1
else
	if [[ -f $VSTS_TOKEN ]] 
	then
	 VSTS_TOKEN=$(cat $VSTS_TOKEN | grep -v '^[[:space:]]*$' | head -1)
	 if [[ -z $VSTS_TOKEN ]]
	 then
	  echo "Missing VSTS_TOKEN file content"
	  exit 1 
	 fi
	fi
fi

if [[ -z $VSTS_AGENT ]]
then
 VSTS_AGENT=$HOSTNAME  
fi

if [[ -z $VSTS_WORK ]]
then
 VSTS_WORK="_work"  
else
 mkdir -p $VSTS_WORK
fi

if [[ -z $VSTS_POOL ]]
then
 VSTS_POOL="Default"  
fi

echo "Download agent to $VSTS_AGENT_PATH/agent.zip"
wget https://vstsagentpackage.azureedge.net/agent/2.200.2/vsts-agent-linux-x64-2.200.2.tar.gz -O $VSTS_AGENT_PATH/agent.tar.gz #replace the url with given value 

echo "Extract agent.zip"
tar -xf $VSTS_AGENT_PATH/agent.tar.gz

echo "Deleting agent.zip"
rm $VSTS_AGENT_PATH/agent.tar.gz

cd $VSTS_AGENT_PATH

$vsts_agent_path/bin/agent.listener configure --unattended \
    --agent '$vsts_agent' \
    --url https://$vsts_account.visualstudio.com \
    --auth pat \
    --token '$vsts_token' \
    --pool '$vsts_pool' \
    --work '$vsts_work' \
    --replace

#$VSTS_AGENT_PATH/bin/Agent.Listener run
