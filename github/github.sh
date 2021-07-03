#!/bin/bash
readonly API_URL="https://api.github.com/"
readonly GITHUB_URL="https://github.com/"
readonly GITLAB_URL="https://gitlab.com/"
readonly BITBUCKET_URL="https://bitbucket.com/"

readonly GITHUB_LEN=${#GITHUB_URL}
readonly GITLAB_LEN=${#GITLAB_URL}
readonly BITBUCKET_LEN=${#BITBUCKET_URL}

show_usage() {
  echo "USAGE: github.sh <REPO>"
  echo
  echo "* REPO: repo url"
  echo "-------------------------------"
  echo "* - required parameters"
}

REPO_URL=$1
REPO_PART=''
if [[ $REPO_URL == *$GITHUB_URL* ]]; then
  REPO_PART=${REPO_URL:GITHUB_LEN}
elif [[ $REPO_URL == *$GITLAB_URL* ]]; then
  REPO_PART=${REPO_URL:GITLAB_LEN}
elif [[ $REPO_URL == *$BITBUCKET_URL* ]]; then
  REPO_PART=${REPO_URL:BITBUCKET_LEN}
else
  echo "ERROR: There's no such repository"
  show_usage
  exit 1
fi

IFS='/' read -ra my_array <<< "$REPO_PART"
REPO_OWNER=${my_array[0]}
REPO_NAME=${my_array[1]}
echo "REPO_OWNER = $REPO_OWNER"
echo "REPO_OWNER = $REPO_NAME"

check_arguments() {
  echo "PARAM = $1"
}
# Get Pull Requests
LIST="$(curl $API_URL$REPO_OWNER/$REPO_NAME/pulls)"
if [[ -z $LIST[message] ]]; then
  echo "API worked"
else
  echo "API don't work now. Try later."
  exit 1
fi
# Filter Participants

echo "$LIST" | jq '.[] | [ .id, .number, .user.login ]'
