#!/bin/bash
#directory of this script
DIR=$(dirname "$0")

python3 -m venv $DIR/venv

. $DIR/venv/bin/activate

pip install -r $DIR/requirements.txt

export REGION=us-east-1
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "REGION: $REGION"
echo "ACCOUNT_ID: $ACCOUNT_ID"

# copy the images you are using in your flow, make sure to use `repo/image:tag` pattern
python $DIR/copy_docker_images_to_ecr.py ncbi/blast:latest
#python copy_docker_images_to_ecr.py yourotherimage

