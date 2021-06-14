#!/usr/bin/env bash
set -e
set -o errexit
set -o nounset
set -o pipefail

# Set environment and use defaults if not defined
COUNT_LINES=${COUNT_LINES:-5}
NETSTAT_LINUX_COMMAND=${NETSTAT_LINUX_COMMAND:-"netstat -tunapl"}
NETSTAT_MAC_COMMAND=${NETSTAT_MAC_COMMAND:-"netstat -tunal"}
PID=""
PNAME=""
GET_INFO=${GET_INFO:-"^Organization|organisation|org-name|person|descr"}
STATE=${STATE:-ESTABLISHED}

ARGS=("$*")

RED="\e[91m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

show_usage_info() {
    # Display Help
    echo "-------------------------------------------------"
    echo "This shell script display info about connections:"
    echo "count, ip address, info "
    echo "Output is ordered by count of connections"
    echo "-------------------------------------------------"
    echo "Syntax:"
    echo "$(basename "${BASH_SOURCE[0]}") [-p PID] - get information by process pid"
    echo "$(basename "${BASH_SOURCE[0]}") [-n NAME] - get information by process name"
    echo "$(basename "${BASH_SOURCE[0]}") [-c NUMBER] - limit output information"
    echo "$(basename "${BASH_SOURCE[0]}") [-s STATE] - show only with this state"
    echo "$(basename "${BASH_SOURCE[0]}") [-r GET_INFO] - get this info from whois"
    echo 
    echo -e "${GREEN}Usage example:${ENDCOLOR}"
    echo -e "${GREEN}Get info about Organization for process with name firefox and limit output to 6 line${ENDCOLOR}"
    echo -e "${GREEN}sudo ${BASH_SOURCE[0]} -n firefox -r Organization -c 6 -s established${ENDCOLOR}"
    echo

}

check_sudo() {

    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Please run this script with sudo${ENDCOLOR}"
        echo -e "Without sudo it will not give all information"
        echo -e "Example:"
        echo -e "${GREEN}sudo $(basename "${BASH_SOURCE[0]}") ${ARGS[0]} ${ENDCOLOR}"
    fi
}

check_requirements() {
# Just check if netstat and whois is installed on system
    if [[ -z "$(which netstat)" ]]; then
        echo -e "${RED}Cannot execute the script${ENDCOLOR}"
        echo -e "Please ensure what you have package ${RED}net-tools${ENDCOLOR} installed"
        echo -e "Please read https://www.tecmint.com/install-netstat-in-linux/"
        exit 1
    fi

    if [[ -z "$(which whois)" ]]; then
        echo -e "${RED}Cannot execute the script${ENDCOLOR}"
        echo -e "Please ensure what you have package net-tools installed"
        echo -e "Please read https://www.howtogeek.com/680086/how-to-use-the-whois-command-on-linux/"
        exit 1
    fi
}

check_os() {
# Check OS to understing that we run in Linux
# because MacOS netstat don't show procces name if by -p paramaters
# if it's MacOS exit with message
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     true;; #Nothing to do - Linux it's exactly what we need
        Darwin*)    echo -e "This program correctly run only under Linux, your OS is ${unameOut}"
                    exit 1
                    ;;
        *)          echo -e "This program correctly run only under Linux, your OS is ${unameOut}"
                    exit 1
    esac
}

get_ip_list(){
    local PID_PNAME="$1"
    local FULL_IP_LIST

    ALL_CONNECTIONS="$(`echo $NETSTAT_LINUX_COMMAND`)"
    FULL_IP_LIST="$(echo "$ALL_CONNECTIONS" | grep $STATE | awk '/'"$PID_PNAME"/' {print $5}' | cut -d: -f1 )"

    if [ -z "${FULL_IP_LIST}" ]; then
        echo -e "${RED}Coul'd not find any connections with this parameters. Please check it.${ENDCOLOR}"
        exit 0;
    fi
    CONN_INFO="$(echo "$FULL_IP_LIST" | cut -d: -f1 | sort | uniq -c | sort | tail -n$COUNT_LINES)"
}

check_whois_by_ip() {
    local IP
    local CONN_COUNT
    local ORG_NAME

    while IFS= read -r line
    do
        IP=$(echo $line | awk '{print $2}');
        CONN_COUNT=$(echo $line | awk '{print $1}');
        ORG_NAME=$(whois $IP | awk -F':' '/'"$GET_INFO"/' {print $2}');

        echo -e "$CONN_COUNT" ":" "$IP" ":" $ORG_NAME
        
    done <<< "$CONN_INFO"

}

### Main section
check_os
check_sudo
check_requirements

while getopts p:n:c:r:s: flag
do
    case "${flag}" in
        p) PID=${OPTARG};;
        n) PNAME=$(echo "${OPTARG}" | tr '[:upper:]' '[:lower:]');;
        c) COUNT_LINES=${OPTARG};;
        r) GET_INFO=${OPTARG};;
        s) STATE=$(echo "${OPTARG}" | tr '[:lower:]' '[:upper:]');;
        *) echo "Exit without parameters. Please see example of usage"
           exit 0
           ;;

    esac
done

if [ $OPTIND -eq 1 ]; then
    show_usage_info
    echo -e "${RED}No options were passed. Please see example of usage${ENDCOLOR}";
    exit 0;
    fi
shift $((OPTIND-1))


echo -e "----------------------------------"
echo -e "Running with following parameters:"
echo -e "----------------------------------"
echo -e "Get the next info from whois by regexp: ${GREEN}${GET_INFO}${ENDCOLOR}"
echo -e "Output lines limit is: ${GREEN}${COUNT_LINES}${ENDCOLOR}"
echo -e "State connection is: ${GREEN}${STATE}${ENDCOLOR}"

if [[ -n "${PID}" ]]; then
    echo -e "Information for process with PID: ${GREEN}${PID}${ENDCOLOR}"
    get_ip_list "$PID"
elif [[ -n "${PNAME}" ]]; then
    echo -e "Information for process name: ${GREEN}${PNAME}${ENDCOLOR}"
    get_ip_list "$PNAME"
else
    echo -e "${RED}Plese give PID or Name to get info${ENDCOLOR}"
    exit 0;
fi

echo -e "----------------------------------"
check_whois_by_ip