from mpi4py import MPI
import numpy as np


comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()
print('Hello from rank', rank, flush=True)

N = 10

# placeholder to store states of all walks
state_vector = np.zeros(N)
current_rank_indices = []
for i_local in range(rank, N, size):    # mpi
    current_rank_indices.append(i_local)
    # modifying local indices
    state_vector[i_local] = rank

comm.Allreduce(MPI.IN_PLACE, state_vector, op=MPI.SUM)
print('After allreduce from rank', rank, state_vector)
