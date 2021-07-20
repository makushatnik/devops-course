#!/bin/bash
set -e
set -o errexit
set -o nounset
set -o pipefail

# Set environment and use defaults if not defined
COUNT_LINES=${COUNT_LINES:-5}
#NETSTAT_LINUX_COMMAND=${NETSTAT_LINUX_COMMAND:-"sudo netstat -tunapl"}
SS_LINUX_COMMAND=${SS_LINUX_COMMAND:-"sudo ss -tunap"}
#NETSTAT_MAC_COMMAND=${NETSTAT_MAC_COMMAND:-"netstat -tunal"}
PID=""
PNAME=""
REQ_STR=${REQ_STR:-"Organization"}
STATE=""

ARGS=("$*")

RED="\e[91m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

# Constants
readonly cant_execute_msg="${RED}Can't execute the script${ENDCOLOR}"
readonly net_tools_absent_err="You need to get ${RED}net-tools${ENDCOLOR} package installed"

show_usage_info() {
    # Display Help
    echo "-------------------------------------------------"
    echo "This shell script displays some info about connections:"
    echo "count, IP address, company info "
    echo "Output is ordered by count of connections"
    echo "-------------------------------------------------"
    echo "Usage: solution.sh [OPTIONS]"
    echo " "
    echo "Options:"
    echo "$(basename "${BASH_SOURCE[0]}") [-p PID]       get information by process PID"
    echo "$(basename "${BASH_SOURCE[0]}") [-n NAME]      get information by process name"
    echo "$(basename "${BASH_SOURCE[0]}") [-c NUMBER]    count of strings in result"
    echo "$(basename "${BASH_SOURCE[0]}") [-s STATE]     show connections only in that state"
    echo "$(basename "${BASH_SOURCE[0]}") [-r REQ_STR]   get requested information from Whois"
    echo 
    echo -e "${GREEN}Usage example:${ENDCOLOR}"
    echo -e "${GREEN}Get info about Organization for process with name firefox and limit output to 6 lines${ENDCOLOR}"
    echo -e "${GREEN}${BASH_SOURCE[0]} -n firefox -r Organization -c 6 -s estab${ENDCOLOR}"
    echo

}

check_requirements() {
# Check if ss and whois are installed.
  if [[ -z "$(which ss)" ]]; then
    echo -e $cant_execute_msg
    echo -e $net_tools_absent_err
    echo -e "Please, read https://www.tecmint.com/install-netstat-in-linux/"
    exit 1
  fi

  if [[ -z "$(which whois)" ]]; then
    echo -e $cant_execute_msg
    echo -e $net_tools_absent_err
    echo -e "Please read https://www.howtogeek.com/680086/how-to-use-the-whois-command-on-linux/"
    exit 1
  fi
}

check_os_is_linux() {
# MacOS netstat don't show procces name if by -p parameters
# if it's MacOS exit with message
  unameOut="$(uname -s)"
  case "${unameOut}" in
    Linux*)  true;;
    *)       echo -e "This shell script correctly runs only under Linux, your OS is ${unameOut}"
             exit 1
  esac
}

get_ip_list() {
  local PID_PNAME="$1"
  local CONNECTIONS
  local IP_LIST

  if [ -z "$STATE" ]; then
    CONNECTIONS="$(`echo $SS_LINUX_COMMAND`)"
  else
    CONNECTIONS="$(`echo $SS_LINUX_COMMAND` | grep $STATE)"
  fi
  
  if [ -z "${CONNECTIONS}" ]; then
    echo -e "${RED}Can't find any connections with this parameters.${ENDCOLOR}"
    exit 0;
  fi

  IP_LIST="$(echo "$CONNECTIONS" | awk '/'"$PID_PNAME"/' {print $6}' | cut -d: -f1 )"

  if [ -z "${IP_LIST}" ]; then
    echo -e "${RED}Can't find any connections with this parameters.${ENDCOLOR}"
    exit 0;
  fi
  CONN_INFO="$(echo "$IP_LIST" | uniq -c | sort | tail -n$COUNT_LINES)"
}

get_whois_info() {
  local IP
  local CONN_COUNT
  local ORG_NAME

  while IFS= read -r line
  do
    IP=$(echo $line | awk '{print $2}');
    CONN_COUNT=$(echo $line | awk '{print $1}');
    ORG_NAME=$(whois $IP | awk -F':' '/'^"$REQ_STR"/' {print $2}' | tr -d '[:space:]');

    echo -e "$CONN_COUNT" ":" "$IP" ":" $ORG_NAME
        
  done <<< "$CONN_INFO"
}

### Main section
check_os_is_linux
check_requirements

while getopts p:n:c:r:s: flag
do
  case "${flag}" in
    p) PID=${OPTARG};;
    n) PNAME=$(echo "${OPTARG}" | tr '[:upper:]' '[:lower:]');;
    c) COUNT_LINES=${OPTARG};;
    r) REQ_STR=${OPTARG};;
    s) STATE=$(echo "${OPTARG}" | tr '[:lower:]' '[:upper:]');;
    *) echo "Illegal parameter."
       show_usage_info
       exit 0;;
  esac
done

if [ $OPTIND -eq 1 ]; then
  show_usage_info
  echo -e "${RED}No options were passed. Please, see example of usage${ENDCOLOR}";
  exit 0;
  fi
shift $((OPTIND-1))

if [ -n "$PID" ] && [ -n "$PNAME" ]; then
  echo -e "${RED}You can't use both Pid and Name parameters. You should choose one of them.${ENDCOLOR}";
  exit 0;
fi

echo -e "----------------------------------"
echo -e "Running with following parameters:"
echo -e "----------------------------------"
echo -e "Get the next info from whois by regexp: ${GREEN}${REQ_STR}${ENDCOLOR}"
echo -e "Output lines limit is: ${GREEN}${COUNT_LINES}${ENDCOLOR}"
echo -e "State connection is: ${GREEN}${STATE}${ENDCOLOR}"

if [[ -n "${PID}" ]]; then
  echo -e "Information for process with PID: ${GREEN}${PID}${ENDCOLOR}"
  get_ip_list "$PID"
elif [[ -n "${PNAME}" ]]; then
  echo -e "Information for process name: ${GREEN}${PNAME}${ENDCOLOR}"
  get_ip_list "$PNAME"
else
  echo -e "${RED}Please, either input PID or Name to get info${ENDCOLOR}"
  exit 0;
fi

echo -e "----------------------------------"
get_whois_info
