#!/bin/bash

# This script is a single task that will be run by HyperQueue.
# HQ_TASK_ID is an environment variable set by HyperQueue for each task.
# See HyperQueue documentation for other variables set by HyperQueue

podman run -v $PWD:$PWD --workdir $PWD jfrog.svc.cscs.ch/dockerhub/ubuntu:22.04 bash ./task-container.sh
