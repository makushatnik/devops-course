#!/bin/bash
readonly REPO="https://api.github.com/repos/makushatnik/devops-course/pulls"

# Get Pull Requests
LIST="curl -I $REPO"
# Filter Participants

echo "LIST = $LIST"