#!/bin/bash
#SBATCH --partition=bhattacharyalab      	# Partition 
#SBATCH --job-name=mpi_job_test      		# Job name
#SBATCH --ntasks=152                  		# Number of MPI tasks (i.e. processes)
#SBATCH --cpus-per-task=1            		# Number of cores per MPI task
#SBATCH --nodes=5                    		# Maximum number of nodes to be allocated
#SBATCH --time=00:05:00              		# Wall time limit (days-hrs:min:sec)
#SBATCH -o slurm.%N.%j.out # STDOUT
#SBATCH -e slurm.%N.%j.err # STDERR

# source ~/.conda_init
# module load openmpi5.0.6
# module load anaconda3
# conda activate py354
#
# which mpiexec
# which python
# mpiexec -n 30 python3 -c "from mpi4py import MPI; from matplotlib import pyplot; print('rank',MPI.COMM_WORLD.Get_rank())"
#

mpiexec -n 152 python3 -c "from mpi4py import MPI; print('rank', MPI.COMM_WORLD.Get_rank())"
