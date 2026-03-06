#!/bin/bash
#SBATCH --job-name=mpi_job_test      		# Job name
#SBATCH --ntasks=30                  		# Number of MPI tasks (i.e. processes)
#SBATCH --cpus-per-task=1            		# Number of cores per MPI task 
#SBATCH --nodes=2                    		# Maximum number of nodes to be allocated
#SBATCH --time=00:05:00              		# Wall time limit (days-hrs:min:sec)
#SBATCH --output=mpi_test_.log.%j    		# Path to the standard output and error files relative to the working directory

source ~/.conda_init
module load openmpi5.0.6 
module load anaconda3
conda activate py354
mpiexec -n 30 python3 ~/clustertest/artest.py
