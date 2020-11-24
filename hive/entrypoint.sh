#!/usr/bin/env bash

# ---------- ssh without password to localhost ---------- #

JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

sed -i "s/\#   StrictHostKeyChecking ask/\StrictHostKeyChecking no/g" /etc/ssh/ssh_config
service ssh reload
service ssh start
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys


/opt/hadoop/bin/hdfs namenode -format

/opt/hadoop/sbin/start-dfs.sh
/opt/hadoop/sbin/start-yarn.sh

/opt/hive/bin/hive --service metastore &

tail -f /dev/null