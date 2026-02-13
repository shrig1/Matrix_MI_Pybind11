# Methods
- `matrix loadMatrixMarketFile(string filename)`  
    Ex: `test_import_matrix = cpp_imp.loadMatrixMarketFile("sparse_matrix.mtx")`  
- `void saveMatrixMarketFile(string filename, matrix)`  
    Ex: `cpp_imp.saveMatrixMarketFile("cpp_sparse_matrix_mi.mtx", mi_matrix)`  
- `run(matrix, int nbins, bool checkpoint)`  
    The matrix is of your standard Eigen Matrix form, and the checkpoint parameter allows you to get a console output for every 100 rows that are computed.  
    Ex: `mi_matrix = cpp_imp.run(test_import_matrix, 20, True)`  
- `computeError(matrix1, matrix)`