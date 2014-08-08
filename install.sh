#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$ROOT_DIR/base
ORCL_DIR=$ROOT_DIR/oracle11g

IMAGE_TAG="swquinn/oracle-installer"
RESPONSE_FILE=$BASE_DIR/config/db_install.rsp

while getopts ":i:r" opt; do
  case $opt in
    i)
      IMAGE_TAG=$OPTARG
      ;;
    r)
      RESPONSE_FILE=$OPTARG
      ;;
    \?)
      echo "Usage: install-oracle [OPTIONS] PATH | URL | -"
      echo ""
      echo "Installer for a Dockerized Oracle 11g install under CentOS6"
      echo ""
      echo "    -i      Change the images tag, e.g. swquinn/centos6"
      #echo "    -r      Specify the response file to use. Default: oracle.rsp"
      echo "    -h      Display this screen."
      exit 1
      ;;
   esac
done
  
# Do some validation here, to verify that the user has properly set up their system.
echo "Verifying dependencies..."
if [ ! -d /tmp/orainst ]; then
  echo -e "$(tput setaf 1)Unable to find the installer directory, please create /tmp/orainst$(tput sgr0)"
  exit 1
fi

if [ ! -f $RESPONSE_FILE ]; then
  echo -e "$(tput setaf 1)Unable to find the Oracle response file ($RESPONSE_FILE), please create one in $BASE_DIR/config$(tput sgr0)"
  exit 1
fi

# Run the docker build
echo -e "$(tput setaf 7)Building docker image as...$(tput sgr0)"
echo "  $ docker build -t $IMAGE_TAG --force-rm=true $BASE_DIR"
docker build -t $IMAGE_TAG --force-rm=true $BASE_DIR

echo -e "$(tput setaf 7)Running oracle installer as...$(tput sgr0)"
echo "  $ docker run -v "/tmp/orainst:/tmp/orainst" --rm $IMAGE_TAG -silent -force -response /var/opt/oracle/db_install.rsp"
docker run -v "/tmp/orainst:/tmp/orainst" --rm $IMAGE_TAG -silent -force -response /var/opt/oracle/db_install.rsp