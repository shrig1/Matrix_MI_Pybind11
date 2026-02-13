import time
from scipy.sparse import random as sparse_random
import py_mi_openmp as cpp_imp

# Generate a sparse random matrix with 1000 rows and 5000 columns
# Density of the matrix is set to 0.01 (1% non-zero elements)
# sparse_matrix = sparse_random(1000, 5000, density=0.01, format='csr')
# matrix = sparse_matrix.toarray()

test_import_matrix = cpp_imp.loadMatrixMarketFile("sparse_matrix.mtx")

# print(test_import_matrix)

# print(matrix)
mi_matrix = cpp_imp.run(test_import_matrix, 20, True)

print(mi_matrix)

cpp_imp.saveMatrixMarketFile("cpp_sparse_matrix_mi.mtx", mi_matrix)