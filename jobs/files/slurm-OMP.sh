#!/bin/bash -l

#############################
# example for an OpenMP job #
#############################

#SBATCH --job-name=example

# we ask for 1 task with 8 cores
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8

# exclusive acccess to compute nodes. 
# default is sharing nodes
#SBATCH --exclusive

# run for five minutes
#              d-hh:mm:ss
#SBATCH --time=0-00:05:00

# determine the partition
#SBATCH --partition=PARA

# turn on all mail notification
#SBATCH --mail-type=ALL
#SBATCH --mail-user=username@um.ac.ir

# stdout
#SBATCH --output="stdout.txt"
# stderr
#SBATCH --error="stderr.txt"

# you may not place bash commands before the last SBATCH directive

# define and create a unique scratch directory
SCRATCH_DIRECTORY=/state/partition1/${USER}/example/${SLURM_JOBID}
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}

# we copy everything we need to the scratch directory
# ${SLURM_SUBMIT_DIR} points to the path where this script was submitted from
cp ${SLURM_SUBMIT_DIR}/my_binary.x ${SCRATCH_DIRECTORY}

# we set OMP_NUM_THREADS to the number of available cores
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}

# we execute the job and time it
time ./my_binary.x > my_output

# after the job is done we copy our output back to $SLURM_SUBMIT_DIR
cp ${SCRATCH_DIRECTORY}/my_output ${SLURM_SUBMIT_DIR}

# we step out of the scratch directory and remove it
cd ${SLURM_SUBMIT_DIR}
rm -rf ${SCRATCH_DIRECTORY}

# happy end
exit 0
