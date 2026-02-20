import py_mi

sparse_matrix = py_mi.loadMatrixMarketFile("sparse_matrix.mtx")

mi_matrix = py_mi.runMI(sparse_matrix, 20, True)

print(mi_matrix)

# py_mi.saveMatrixMarketFile("cpp_sparse_matrix_mi.mtx", mi_matrix)
