#!/bin/bash
set -e

FILE_NAME=$1
DOCKER_USERNAME=$2
DOCKER_PASSWORD=$3

TEAM_NAME="poc-k8s"


# Read Github Username from file
while read GITHUB_USER; do
    
    echo "Creating Pipeline for $GITHUB_USER"
    fly -t $TEAM_NAME set-pipeline --pipeline $GITHUB_USER --config ./pipeline.yaml --var "docker.username=${DOCKER_USERNAME}" --var "docker.password=${DOCKER_PASSWORD}" --var "github_username=${GITHUB_USER}" -n
    fly -t $TEAM_NAME expose-pipeline --pipeline $GITHUB_USER
    fly -t $TEAM_NAME unpause-pipeline -p $GITHUB_USER
    
    # fly -t $TEAM_NAME destroy-pipeline -p $GITHUB_USER -n
    
done < $FILE_NAME
