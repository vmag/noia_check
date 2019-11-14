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

if [ -f /usr/bin/virtualenv-3 ]; then
/usr/bin/virtualenv-3 -p python3 noia >/dev/null 2>/dev/null
fi

if [ -f /usr/local/bin/virtualenv ]; then
/usr/local/bin/virtualenv -p python3 noia >/dev/null 2>/dev/null
fi

if [ -f /usr/local/bin/virtualenv ]; then
/usr/local/bin/virtualenv -p python3 noia >/dev/null 2>/dev/null
fi

source ./noia/bin/activate
pip3 install srv6-tracert ansible jq >/dev/null 2>/dev/null


if [ -z "`ip -6 addr | grep global`" ]; then
echo -e "${RED}Your host has no IPv6 configured, exiting${NC}"

else
echo -e "${GREEN}Your IPv6 address is: `ip -6 addr | grep global`${NC}"
echo -e "-${GREEN}-- Gathering host facts ---${NC}"
ansible localhost -m setup -t . >/dev/null 2>/dev/null
cat localhost | python3 -m json.tool > `hostname`.json
echo -e "${GREEN}--- Gathering traceroute ---"${NC}
srv6_traceroute.py -d 2a03:b0c0:3:e0::107:4001 > `hostname`.traceroute
rm -rf localhost
zip `hostname`.zip `hostname`.* >/dev/null 2>/dev/null
echo -e "\r\n"
echo -e "${BLUE} -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=${NC}"
echo -e "-${GREEN}-- Done. Please send file ${RED}`hostname`.zip ${GREEN} to ${RED}info@noia.network ${NC}---"
echo -e "${BLUE} -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=${NC}"
echo -e "\r\n"
echo -e "\r\n"
fi

deactivate

