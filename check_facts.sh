#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

echo -e "-${GREEN}-- Installing packages ---${NC}"
if [ -f /etc/lsb-release ]; then
apt-get -y install python3-pip zip >/dev/null 2>/dev/null
fi

if [ -f /etc/redhat-release ]; then
yum install python3-pip zip -y >/dev/null 2>/dev/null
fi

echo -e "-${GREEN}-- Installing virtualenv ---${NC}"

pip3 install virtualenv >/dev/null 2>/dev/null
virtualenv -p python3 noia >/dev/null 2>/dev/null
source ./noia/bin/activate
pip3 install ansible >/dev/null 2>/dev/null
pip3 install srv6-tracert >/dev/null 2>/dev/null

echo -e "-${GREEN}-- Gathering host facts ---${NC}"
ansible localhost -m setup > `hostname`.json

echo -e "${GREEN}--- Gathering traceroute ---"${NC}
srv6_traceroute.py -d 2a03:b0c0:3:e0::107:4001 > `hostname`.traceroute

deactivate
zip `hostname`.zip `hostname`.* >/dev/null 2>/dev/null
echo -e "\r\n"
echo -e "${BLUE} -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=${NC}"
echo -e "-${GREEN}-- Done. Please send file ${RED}`hostname`.zip ${GREEN} to ${RED}info@noia.network ${NC}---"
echo -e "${BLUE} -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=${NC}"
echo -e "\r\n"
echo -e "\r\n"

