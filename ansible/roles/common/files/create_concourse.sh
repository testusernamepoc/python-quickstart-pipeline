#!/bin/bash
set -e

FILE_NAME=$1
DOCKER_USERNAME=$2
DOCKER_PASSWORD=$3
K8S_URL=$4
K8S_CA=$5
K8S_TOKEN=$6
TEAM_NAME=$7


# Read Github Username from file
while read GITHUB_USER; do
    
    echo "Creating Pipeline for $GITHUB_USER"
    fly -t $TEAM_NAME set-pipeline --pipeline $GITHUB_USER --config ./pipeline.yaml --var "docker.username=${DOCKER_USERNAME}" --var "docker.password=${DOCKER_PASSWORD}" --var "github_username=${GITHUB_USER}" --var "k8s.url=${K8S_URL}" --var "k8s.ca=${K8S_CA}" --var "k8s.token=${K8S_TOKEN}" -n
    fly -t $TEAM_NAME expose-pipeline --pipeline $GITHUB_USER
    fly -t $TEAM_NAME unpause-pipeline -p $GITHUB_USER
    
    # fly -t $TEAM_NAME destroy-pipeline -p $GITHUB_USER -n
    
done < $FILE_NAME
