import py_mi_openmp as cpp_imp

sparse_matrix = cpp_imp.loadMatrixMarketFile("sparse_matrix.mtx")

mi_matrix = cpp_imp.runMI(sparse_matrix, 20, True)

print(mi_matrix)

cpp_imp.saveMatrixMarketFile("cpp_sparse_matrix_mi.mtx", mi_matrix)
