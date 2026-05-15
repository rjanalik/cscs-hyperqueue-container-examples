#!/bin/bash

#SBATCH --nodes 2
#SBATCH --ntasks-per-node 1
#SBATCH --time 00:10:00
#SBATCH --partition normal
#SBATCH --account csstaff
#SBATCH -p debug


# Set up the journal file for state tracking
# If an argument is provided, use it to restore a previous job
# Otherwise, create a new journal file for the current job
RESTORE_JOB=$1
if [ -n "$RESTORE_JOB" ]; then
    export JOURNAL=~/.hq-journal-${RESTORE_JOB}
else
    export JOURNAL=~/.hq-journal-${SLURM_JOBID}
fi

# Ensure each Slurm job has its own HyperQueue server directory
export HQ_SERVER_DIR=~/.hq-server-${SLURM_JOBID}

# Start the HyperQueue server with the journal file
hq server start --journal=${JOURNAL} &

# Wait for the server to be ready
hq server wait --timeout=120
if [ "$?" -ne 0 ]; then
    echo "Server did not start, exiting ..."
    exit 1
fi

# Pull image once per node
srun podman image pull jfrog.svc.cscs.ch/dockerhub/ubuntu:22.04

# Start HyperQueue workers
srun hq worker start &

# Submit tasks only if we are not restoring a previous job
# (300 CPU tasks and 16 GPU tasks)
if [ -z "$RESTORE_JOB" ]; then
    #hq submit --resource "cpus=1" --array 1-300 ./task.sh;
    hq submit --resource "cpus=8" --array 1-100 ./task.sh;
fi

# Wait for all jobs to finish
hq job wait all

# Stop HyperQueue server and workers
hq server stop

# Clean up server directory and journal file
rm -rf ${HQ_SERVER_DIR}
rm -rf ${JOURNAL}

echo
echo "Everything done!"
