#!/bin/bash

mpiexec -n 10 python3 -c "from mpi4py import MPI; print('rank', MPI.COMM_WORLD.Get_rank())"
