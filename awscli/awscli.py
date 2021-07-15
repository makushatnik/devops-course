# Script for working with AWS CLI
import os
import click
import subprocess
from subprocess import Popen, PIPE, STDOUT

intervals=['day','hour','minute']

EBS_LIST_COMMAND_START="aws ec2 describe-snapshots --owner self --output json | jq '.Snapshots[] |"
EBS_LIST_COMMAND_END="| [.Description, .VolumeSize, .StartTime, .SnapshotId, .Tags]'"
#DATE_CONDITION=".StartTime < date --date='-{count} {interval}' '+%Y-%m-%d %H:%M'"

def show_usage():
  print("USAGE: python3 awscli.py <ARGS> <FILTER>")
  print("")
  print("ARGS:")
  print("  count   Number of interval measures")
  print("  interval   Chosen interval measure")
  print("FILTER:")
  print("  --tag, -t   Tag Value for filtering result list")
  print("")

@click.command()
@click.argument('count')
@click.argument('interval')
@click.option(
    '--tag', '-t',
    help='Tag Value for filtering result list'
)
def main(count, interval, **kwargs):
  if interval not in intervals:
    show_usage()
    return "Incorrect interval argument"

#  date_str="--date='-{} {}' '+%Y-%m-%d %H:%M'".format(count, interval)
  date_str="--date='-{} {}'".format(count, interval)
  date_eval=Popen(["date", date_str, "+%Y-%m-%d %H:%M"], stdout=PIPE)
  print(date_eval)
  date_condition=".StartTime < {}".format(date_eval)
  print(date_condition)
  print(f"{EBS_LIST_COMMAND_START} select({date_condition}) {EBS_LIST_COMMAND_END}")
  os.system(EBS_LIST_COMMAND_START + " select(" + date_condition + ")" + EBS_LIST_COMMAND_END)

if __name__ == "__main__":
  main()
