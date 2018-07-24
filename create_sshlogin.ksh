#!/bin/ksh 
SCRIPT_DIR=`dirname ${0}`
if [ -f ${SCRIPT_DIR}/ssh_login.ksh ]
then
    SSH_SCRIPT=${SCRIPT_DIR}/ssh_login.ksh
else
    echo "no ssh login script present"
    exit
fi

chmod 600 ${HOME}/.ssh/config

ls -l ${SSH_SCRIPT}

while getopts "u:p:h:" opt; do
   case "$opt" in
              u)  USER="$OPTARG";;
              p)  PASS="$OPTARG";;
              h)  HOSTNAME="$OPTARG";;
            [?])  echo  >&2 "Usage: $0 [-u <user-name> ] [-p <user-password> ] [-h <hostname>] "
           	  exit 1;;
   esac
done
# PASS=Unix11!
# Generate key if it does not exist
if  [ ! -f ${HOME}/.ssh/id_rsa ] ; then
        #ulimit 0000
        chmod 600 ${HOME}/.ssh/id_rsa
        ssh-keygen  -t rsa -N "" -f ${HOME}/.ssh/id_rsa
fi

if [[ ! -d ${HOME}/.ssh ]]; then
                mkdir -p ${HOME}/.ssh
fi

if [[ ! -f ${HOME}/.ssh/config ]]; then
                echo "StrictHostKeyChecking no" > ${HOME}/.ssh/config
else
                grep "StrictHostKeyChecking" ${HOME}/.ssh/config > /dev/null 2> /dev/null
                
                if [[ $? -ne 0 ]]; then
                                echo "StrictHostKeyChecking no" >> ${HOME}/.ssh/config
                fi
fi
chmod 600 ${HOME}/.ssh/config
echo "$PASS"  |${SSH_SCRIPT} ssh-copy-id -i ${HOME}/.ssh/id_rsa.pub ${USER}@${HOSTNAME}
