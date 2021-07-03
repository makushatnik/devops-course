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

## Running.
Run a script by typing:
`script.sh`
