# The AWS CLI task solution.

## Preparing.
1. Install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html) on your system.
2. Go to your AWS Console and create an Access Keys.
Either **Access key ID** and **Secret access key** needed before the next step.
3. Run command:
`aws configure`
and enter your keys.
4. Install jq by typing:
    sudo wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
    sudo chmod +x ./jq
    sudo cp jq /usr/bin
5. Install libraries:
`pip3 install -r requirements.txt`	(in Venv or Global environment)

## Running.
Run a script by typing:
    python awscli.py <ARGS> <OPTIONS>

	ARGS:
	  count      Number of interval measures. Any number from 0 to 2000000.
	  interval   Chosen interval measure. Possible values: **day**, **hour**, **minute**.

	OPTIONS:
	  -t, --tag TEXT   Tag Value for filtering result list
	  -s, --save TEXT  Save snapshots into S3 bucket flag
	  --help           Get help message

### Further development:
Add copying EBS snapshot into S3 bucket by its snapshot ID.  
Add check of bucket existence.