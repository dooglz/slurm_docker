#!/bin/bash
# The job name
#SBATCH --job-name=helloworld
# Set the error and output files
#SBATCH --output=hello-%J.out
#SBATCH --error=hello-%J.out
# Set the initial working directory
##SBATCH --workdir=/scratch/us/usxa
# Choose the queue
# Wall clock time limit
#SBATCH --time=00:05:00
# Send an email on failure
#SBATCH --mail-type=FAIL
# This is the job
echo "Hello World!"
sleep 30
echo "goodbye world!"
