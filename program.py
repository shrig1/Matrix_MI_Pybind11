import time
from scipy.sparse import random as sparse_random
import py_mi_openmp as cpp_imp

# Generate a sparse random matrix with 1000 rows and 5000 columns
# Density of the matrix is set to 0.01 (1% non-zero elements)
sparse_matrix = sparse_random(1000, 5000, density=0.01, format='csr')
matrix = sparse_matrix.toarray()

start_time = time.time()

print(matrix)
mi_matrix = cpp_imp.run(matrix, 20)

print(mi_matrix)

end_time = time.time()
elapsed_time = end_time - start_time
print(f"Elapsed time: {elapsed_time:.4f} seconds") 