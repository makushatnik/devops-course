# Script for working with AWS CLI
import os
import sys
import click
import subprocess
from subprocess import Popen, PIPE, STDOUT

intervals=['day','hour','minute']

# Constants
EBS_LIST_COMMAND_START="aws ec2 describe-snapshots --owner self --output json | jq '.Snapshots[] |"
EBS_LIST_COMMAND_END="| [.Description, .VolumeSize, .StartTime, .SnapshotId, .Tags]'"
CREATE_BUCKET_COMMAND="aws s3 mb s3://"
NOT_FOUND_STR="NoSuchBucket"
MAX_COUNT=2000000
BUCKET="makushatnik-ebs"
REGION="eu-central-1"


# Function for describing how the Script works.
def show_usage():
  print("USAGE: python3 awscli.py <ARGS> <OPTIONS>")
  print("")
  print("ARGS:")
  print("  count   Number of interval measures. Less than " + str(MAX_COUNT))
  print("  interval   Chosen interval measure")
  print("OPTIONS:")
  print("  --tag, -t    Tag Value for filtering result list")
  print("  --save, -s   Flag for saving snapshot in S3 by its ID")
  print("  --help       Help")
  print("")

# The Main function of the Script
@click.command()
@click.argument('count')
@click.argument('interval')
@click.option(
    '--tag', '-t',
    help='Tag Value for filtering result list'
)
@click.option(
    '--save', '-s',
    help='Save snapshots into S3 bucket flag'
)
def main(count, interval, tag, save):
  """
  An AWS CLI tool for checking EBS Snapshots and saving them. Provide count and interval of snapshots' age.

  count   Number of interval measures. Less than 2000000.

  interval   Chosen interval measure. Possible values: day, hour, minute
  """
  check_count(count)
  if interval not in intervals:
    print("Incorrect interval argument")
    show_usage()
    sys.exit()

  show_ebs_list(count, interval, tag)
  if save:
    save_into_s3()

# Check count script input parameter.
# If it wrong, raise an error.
def check_count(count):
  if int(count) >= MAX_COUNT:
    print("Incorrect count argument")
    show_usage()
    sys.exit()

# Check if a bucket already exists
def check_if_bucket_exists():
  p=Popen(["aws", "s3", "ls", "s3://{}".format(BUCKET)], stdout=PIPE)
  list_str=p.communicate()[0].decode('utf-8')
  if list_str.find(NOT_FOUND_STR) != -1:
    return False
  return True

# Copy snapshot to S3 by its snapshot ID
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/copy-snapshot.html
# Here written:
# Copies a point-in-time snapshot of an EBS volume and stores it in Amazon S3.
# But actually it don't work. 
def copy_snapshot_to_s3(snapshot_id):
  print(snapshot_id)
  p=Popen(["aws", "ec2", "copy-snapshot", "--source-region", REGION, "--source-snapshot-id", snapshot_id, "--description", "This is my copied snapshot."], stdout=PIPE)
  res=p.communicate()[0].decode('utf-8')
  print(res)

# Save selected snapshot into S3.
def save_into_s3():
  bucket_exists=check_if_bucket_exists()
  if not bucket_exists:
    os.system(CREATE_BUCKET_COMMAND + BUCKET)
  snapshot_id=input("Enter an EBS Snapshot Id: ")
  if snapshot_id:
    copy_snapshot_to_s3(snapshot_id)

# Show EBS List in a JSON format.
def show_ebs_list(count, interval, tag):
  date_str="--date=-{} {}".format(count, interval)
  p=Popen(["date", date_str, "+%Y-%m-%d %H:%M"], stdout=PIPE)
  date_tmp=p.communicate()[0]
  date_str=date_tmp.decode('utf-8')
  # WA
  date_str=date_str.replace("\r", "")
  date_str=date_str.replace('\n', '')

  date_condition=".StartTime < \"{}\"".format(date_str)
  os.system(get_ebs_list_command_str(date_condition, tag))

# Combine the EBS list command string.
def get_ebs_list_command_str(date_condition, tag):
  command_str=EBS_LIST_COMMAND_START + " select(" + date_condition
  if tag:
    command_str+=" and .Tags[].Value == \"{}\") ".format(tag)
  else:
    command_str+=") "
  command_str+=EBS_LIST_COMMAND_END
  print(command_str)
  return command_str

if __name__ == "__main__":
  main()
