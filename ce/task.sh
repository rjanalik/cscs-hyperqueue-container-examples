#!/bin/bash

# This script is a single task that will be run by HyperQueue.
# HQ_TASK_ID is an environment variable set by HyperQueue for each task.
# See HyperQueue documentation for other variables set by HyperQueue

source /etc/os-release

echo "$(date): start task ${HQ_TASK_ID}: $(hostname) CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES} OS: $NAME $VERSION"

# Simulate some work
sleep 30

echo "$(date): end task ${HQ_TASK_ID}: $(hostname) CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES} OS: $NAME $VERSION"
