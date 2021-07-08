#!/bin/bash
ARGS=("$@")
Intervals=('day' 'hour' 'minute'); 

readonly MAX_COUNT=2000000

readonly RED="\e[91m"
readonly GREEN="\e[32m"
readonly YELLOW="\e[33m"
readonly ENDCOLOR="\e[0m"

readonly CANT_EXECUTE_MSG="${RED}Can't execute the script${ENDCOLOR}"
readonly EBS_LIST_COMMAND_START="aws ec2 describe-snapshots --owner self --output json | jq '.Snapshots[] |"
readonly EBS_LIST_COMMAND_END="| [.Description, .VolumeSize, .StartTime, .SnapshotId, .Tags]'"
# readonly DATE_CONDITION=".StartTime < $(date --date='-"$1 $2"' '+%Y-%m-%d %H:%M')"
readonly DATE_EVAL=`eval "date --date='-$1 $2' '+%Y-%m-%d %H:%M'"`
#echo "DATE_EVAL = $DATE_EVAL"
DATE_CONDITION=".StartTime < \"$DATE_EVAL\""
#echo "DATE_CONDITION = $DATE_CONDITION"
readonly FILTER_CONDITION=".Tags[].Value == $3"

show_usage() {
  echo "USAGE: script.sh <COUNT> <INTERVAL> <FILTER>"
  echo ""
  echo "* COUNT: numeric greater or equal to 0, but less than $MAX_COUNT"
  echo "* INTERVAL: day, hour or minute"
  echo "  FILTER: enter a Tag Value to filter Snapshots by"
  echo ""
  echo "Interval & count are used to show all EBS blocks those are older than count of days (hours or minutes)."
  echo "* - required parameters"
}

check_requirements() {
# Check if aws and jq are installed.
  if [[ -z "$(which aws)" ]]; then
    echo -e $CANT_EXECUTE_MSG
    echo -e "Package ${RED}awscli${ENDCOLOR} is required"
    echo -e "Please, install it: https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html"
    exit 1
  fi

  if [[ -z "$(which jq)" ]]; then
    echo -e $cant_execute_msg
    echo -e "Package ${RED}jq${ENDCOLOR} is required"
    exit 1
  fi
}

check_arguments() {
  local count=$1
  local interval=$2

  if [ -z "$count" ]; then
    echo -e $CANT_EXECUTE_MSG
    show_usage
    exit 0
  fi
  if [ "$count" -lt 0 ]; then
    echo -e $CANT_EXECUTE_MSG
    echo "Count should be >= 0"
    show_usage
    exit 0
  fi
  if [ "$count" -gt "$MAX_COUNT" ]; then
    echo -e $CANT_EXECUTE_MSG
    echo "Count should be <= $MAX_COUNT"
    show_usage
    exit 0
  fi

  if [ -z "$interval" ]; then
    echo -e $CANT_EXECUTE_MSG
    show_usage
    exit 0
  fi
  found=`echo ${Intervals[*]} | grep "$interval"`
  if [ -z "$found" ]; then
    echo "Interval ain't found"
    echo -e $CANT_EXECUTE_MSG
    show_usage
    exit 0
  fi
}

### Main section
check_requirements
check_arguments ${ARGS[*]}

FILTER=$3
EBS_LIST=""

if [[ -n $FILTER ]]; then
  EBS_LIST="$EBS_LIST_COMMAND_START select($DATE_CONDITION and $FILTER_CONDITION) $EBS_LIST_COMMAND_END"
else
  EBS_LIST="$EBS_LIST_COMMAND_START select($DATE_CONDITION) $EBS_LIST_COMMAND_END"
fi
echo "List of EBS Snapshots found:"
echo $EBS_LIST
RUN=$(`echo $EBS_LIST`)
echo $RUN
