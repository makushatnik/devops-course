#!/bin/bash
readonly GITHUB_API_URL="https://api.github.com/repos/"

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

if [[ $# -lt 1 ]]; then
  show_usage
  exit 0
fi

repo_url=$1
repo_part=''
get_pulls_str=''
if [[ $repo_url == *$GITHUB_URL* ]]; then
  is_github=true
  repo_part=${repo_url:GITHUB_LEN}
elif [[ "$repo_str" == *$GITLAB_URL* ]]; then
  repo_part=${repo_url:GITLAB_LEN}
  echo "Not supported now"
  exit 0
elif [[ "$repo_url" == *$BITBUCKET_URL* ]]; then
  repo_part=${repo_url:BITBUCKET_LEN}
  echo "Not supported now"
  exit 0
else
  echo "ERROR: There's no such repository"
  show_usage
  exit 1
fi

IFS='/' read -ra my_array <<< "$repo_part"
repo_owner=${my_array[0]}
repo_name=${my_array[1]}
echo "REPO_OWNER = $repo_owner"
echo "REPO_NAME  = $repo_name"
if [ $is_github ]; then
  get_pulls_str="$GITHUB_API_URL$repo_owner/$repo_name/pulls"
fi

#if [ -z "${list[message]}" ] || [ "${list[message]}" != "Not Found" ]; then
#  echo "API worked"
#else
#  echo "API don't work now. Try later."
#  exit 1
#fi

# 1.1 Check that Pull Requests in open State exist
list="$(curl $get_pulls_str)"
open_pulls_count=`echo "$list" | jq '[.[] | select(.state == "open") |{ id: .id, state: .state}] |group_by(.state)|.[]|([.[]]|length)'`
#echo "OPEN PR = $open_pulls_count"
if [[ $open_pulls_count -gt 0 ]]; then
  echo "There are $open_pulls_count of open Pull Requests"
else
  echo "There no open Pull Requests"
fi

# 1.2 Get the most Active Participants
echo "$list" | jq '[.[] | { id: .id, url: .url, number: .number, user: .user.login } ] | group_by(.user)|.[]|{user: .[0].user, count: ([.[]]|length)} | select(.count >= 2) | .user'

