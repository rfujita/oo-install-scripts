#!/bin/bash
# Setup ssh keys for authenticating from broker to node

# setup variables
source ./oo-install.conf

# Put node information in DNS
oo-register-dns -h ${NODENAME} -d ${DOMAIN} -n ${NODEIP} -k ${KEYFILE}

# Copy over broker pub key info
ssh root@${NODEHOSTNAME} "if [ ! -d "/root/.ssh/" ] ;then mkdir -m=700 /root/.ssh/; fi"
ssh root@${NODEHOSTNAME} "chcon system_u:object_r:ssh_home_t:s0 /root/.ssh/"
scp /etc/openshift/rsync_id_rsa.pub root@${NODEHOSTNAME}:/root/.ssh/

# Setup broker pub key for authentication
ssh root@${NODEHOSTNAME} "cat /root/.ssh/rsync_id_rsa.pub >> /root/.ssh/authorized_keys ; rm -f /root/.ssh/rsync_id_rsa.pub"

# Verify you can ssh in without password
ssh -i /root/.ssh/rsync_id_rsa root@${NODEHOSTNAME} "hostname ; uptime"

