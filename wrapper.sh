#!/bin/bash
set -e
 
 # Logger
function _log(){
  echo -e "=> $(date +'%y/%m/%d %H:%M:%S') [$1] $2"|tee -a /mnt/disk1/log/redis/wrapper.log
}
 
# Initialize and saving deploy configuration
function loadConfig(){
  _log 'INFO' 'Loading config ...'
  touch /config.sh
  for arg in "$@"; do
    if [[ "$arg" == -X* ]]; then
      key=${arg%=*}
      key=${key#*'-X'}
      value=${arg#*=}
      echo "${key}=${value}" >> /config.sh
     _log 'INFO' "Load config of => $key=$value"
    fi
  done;
  chmod 755 /config.sh && . /config.sh
}

# Install redis cluster and startup.
# Required args: <listenIp> <redisPassword>
#
function doInstallStart(){
  _log 'INFO' 'Check required config arguments ...'
  if [[ "$listenIp" == "" || "$redisPassword" == "" ]]; then
    _log 'WARN' 'Using to default arguments <listenIp=127.0.0.1>,<redisPassword=123456>'
    listenIp='127.0.0.1'
    redisPassword='123456'
  fi

  _log 'INFO' 'Initilizing redis cluster config password ...'
  cd /
  listenPorts=(6379 6380 6381 7379 7380 7381)  # By default
  for((i=0;i<${#listenPorts[@]};i++)) do
     port=${listenPorts[i]}
     nodes="${listenIp}:${port},${nodes}"
     cat redis.conf.tpl \
       | sed "s/REDIS_PASSWORD/$redisPassword/g" \
	     | sed "s/REDIS_PASSWORD/$redisPassword/g" \
	     | sed "s/PORT/$port/g" > ${REDIS_HOME}/conf/redis-${port}.conf
  done;
  /bin/redis-ctl start

  _log 'INFO' "Create redis cluster on ${nodes}"
  /bin/redis-ctl cluster ${redisPassword} ${nodes}

  #_log 'INFO' 'Update redis cluster password ...'
  #/bin/redis-ctl passwd redis ${redisPassword} ${nodes}

  _log 'INFO' "Initialized and redis cluster started on: \n$(/bin/redis-ctl status)"
}

# Directly starting redis server.
function doStart(){
  /bin/redis-ctl start
  _log 'INFO' 'Redis cluster started successfully!'
}

# --------------
# [Main Entry] 
# --------------

# Load config
loadConfig $@

if [ ! -f "${REDIS_HOME}/nodes/nodes-6379.conf" ]; then
  doInstallStart
else
  doStart
fi

# Solve the docker run container automatic exit problem!!! 
tail -f /dev/null
