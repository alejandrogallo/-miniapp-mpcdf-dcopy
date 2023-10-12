CXXFLAGS = -pedantic -fmax-errors=1
#MKL_LDFLAGS = -L$(MKLROOT)/lib/intel64/ -mkl

MKL_LDFLAGS = -L$(MKLROOT)/lib/intel64/ -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread  -lmkl_scalapack_lp64 -lmkl_blacs_intelmpi_lp64
MKL_SOURCE = . ./modules_icc-mkl-impi

INT64 = -DATRIP_INT=int64_t
INT32 = -DATRIP_INT=int32_t

GCC_SOURCE = . ./modules_gcc-oblas-ompi
OPENBLAS_PATH ?= /u/airmler/src/atrip/extern/OpenBLAS/gcc13

BINS = xcopy.icc.32 xcopy.icc.64 xcopy.icc.32.mkl xcopy.icc.64.mkl xcopy.gcc.32 xcopy.gcc.64

all: $(BINS)

run:
	srun -n8 -p interactive --time=0:10:00 --mem=1G $(BIN)

clean:
	rm -v $(BINS)

.PHONY: run all clean

# MKL ##########################################################################

xcopy.icc.32: xcopy.cxx
	$(MKL_SOURCE) && \
		mpiicpc -o $@ $(CXXFLAGS) $(INT32) xcopy.cxx $(MKL_LDFLAGS)

xcopy.icc.64: xcopy.cxx
	$(MKL_SOURCE) && \
		mpiicpc -o $@ $(CXXFLAGS) $(INT64) xcopy.cxx $(MKL_LDFLAGS)

xcopy.icc.32.mkl: xcopy.cxx
	$(MKL_SOURCE) && \
		mpiicpc -o $@ $(CXXFLAGS) $(INT32) xcopy.cxx -L$(MKLROOT)/lib/intel64 -lmkl

xcopy.icc.64.mkl: xcopy.cxx
	$(MKL_SOURCE) && \
		mpiicpc -o $@ $(CXXFLAGS) $(INT64) xcopy.cxx -L$(MKLROOT)/lib/intel64 -lmkl

# GNU ##########################################################################

xcopy.gcc.32: xcopy.cxx
	$(GCC_SOURCE) && \
		mpic++ $(CXXFLAGS) $(INT32) xcopy.cxx -lopenblas -L $(OPENBLAS_PATH)  -o $@

xcopy.gcc.64: xcopy.cxx
	$(GCC_SOURCE) && \
		mpic++ $(CXXFLAGS) $(INT64) xcopy.cxx -lopenblas -L $(OPENBLAS_PATH)-o $@
