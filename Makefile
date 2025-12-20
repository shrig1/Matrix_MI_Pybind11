CXX = g++

# Default SYS
SYS ?= linux


LOCAL_EIGEN_WIN = C:/Users/ssromerogon/Documents/vscode_working_dir/eigen # Local installation
LOCAL_EIGEN_LIN = /usr/include/eigen3

# Flags for Windows
CXXFLAGS_WINDOWS_RELEASE = -O2 -Wall -I $(LOCAL_EIGEN_WIN) -lm
CXXFLAGS_WINDOWS_DEBUG = -g -O0 -DDEBUG -Wall -Wextra -pedantic -fsanitize=address -fno-omit-frame-pointer -I $(LOCAL_EIGEN_WIN) -lm

# Flags for Linux
CXXFLAGS_LINUX_RELEASE = -O2 -I $(LOCAL_EIGEN_LIN) -lm
CXXFLAGS_LINUX_DEBUG = -g -O0 -DDEBUG -Wall -Wextra -pedantic -fsanitize=address -fno-omit-frame-pointer -I $(LOCAL_EIGEN_LIN) -lm

# OpenMP flags
OPENMPFLAGS = -fopenmp

# Select SYS-specific flags and print platform info
ifeq ($(SYS),windows)
    ifeq ($(DEBUG),yes)
        CXXFLAGS = $(CXXFLAGS_WINDOWS_DEBUG)
    else
        CXXFLAGS = $(CXXFLAGS_WINDOWS_RELEASE)
    endif
    PLATFORM_MESSAGE = "Building on Windows"
    EIGEN_PATH = $(LOCAL_EIGEN_WIN)
else ifeq ($(SYS),linux)
    ifeq ($(DEBUG),yes)
        CXXFLAGS = $(CXXFLAGS_LINUX_DEBUG)
    else
        CXXFLAGS = $(CXXFLAGS_LINUX_RELEASE)
    endif
    PLATFORM_MESSAGE = "Building on Linux"
    EIGEN_PATH = $(LOCAL_EIGEN_LIN)
else
    $(error Unsupported platform: $(SYS))
endif

# Targets
TARGETS = mi_serial mi_openmp

# Python / pybind11 settings
PYTHON = python3
# try to get pybind11/python include and link flags; fall back to python-config
PYTHON_INCLUDES := $(shell $(PYTHON) -m pybind11 --includes 2>/dev/null || $(PYTHON)-config --includes 2>/dev/null || echo "")
PYTHON_LDFLAGS := $(shell $(PYTHON) -m pybind11 --libs 2>/dev/null || $(PYTHON)-config --ldflags 2>/dev/null || echo "")
# local pybind11 headers (this repo)
PYBIND_LOCAL_INC = -I./pybind11
# extension suffix (.so, .cpython-*-x86_64-linux-gnu.so, etc)
EXT_SUFFIX := $(shell $(PYTHON) -c "import sysconfig;print(sysconfig.get_config_var('EXT_SUFFIX') or '.so')")


# Rules
all: $(TARGETS)
	@echo "$(PLATFORM_MESSAGE)"
	@echo "Eigen Path: $(EIGEN_PATH)"
	@echo "CXXFLAGS: $(CXXFLAGS)"


mi_serial: mi_serial.cpp mmio.c mmio.h
	$(CXX) $(CXXFLAGS) -o $@ mi_serial.cpp mmio.c

mi_openmp: mi_openmp.cpp mmio.c mmio.h
	$(CXX) $(CXXFLAGS) $(OPENMPFLAGS) -o $@ mi_openmp.cpp mmio.c

# Build python extension from the mi_openmp sources (expects pybind11 bindings
# to be present inside mi_openmp.cpp or an included wrapper). Produces module
# named py_mi_openmp<EXT_SUFFIX>. Use: make py
py: py_mi_openmp$(EXT_SUFFIX)

py_mi_openmp$(EXT_SUFFIX): mi_openmp-pybind11.cpp mmio.c mmio.h
	$(CXX) $(CXXFLAGS) -fPIC -shared $(OPENMPFLAGS) $(PYBIND_LOCAL_INC) $(PYTHON_INCLUDES) -o $@ mi_openmp-pybind11.cpp mmio.c $(PYTHON_LDFLAGS)

clean:
	rm -f $(TARGETS)
	rm -f py_mi_openmp*.so py_mi_openmp*$(EXT_SUFFIX)

.PHONY: all clean  # Add .PHONY to prevent issues with files named 'all' or 'clean'
