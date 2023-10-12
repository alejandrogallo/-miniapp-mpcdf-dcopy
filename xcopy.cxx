#include <cstdlib>
#include <iostream>
#include <mpi.h>

#define MALLOC(ptr, size) *(void **)ptr = (void *)malloc(size)

#ifndef ATRIP_INT
#error "Define ATRIP_INT"
#endif

extern "C" {

void dcopy_(ATRIP_INT *n, const double *x, ATRIP_INT *incx, double *y,
            ATRIP_INT *incy);
}

template <typename F>
void xcopy(ATRIP_INT *n, const F *x, ATRIP_INT *incx, F *y, ATRIP_INT *incy) {
  dcopy_(n, x, incx, y, incy);
}

int main() {
  MPI_Init(NULL, NULL);

  ATRIP_INT No(10), ooo = No * No * No;
  double *Zijk, *Tijk;
  MALLOC(&Zijk, sizeof(double) * No * No * No);
  MALLOC(&Tijk, sizeof(double) * No * No * No);

  for (size_t i = 0; i < ooo; i++)
    Tijk[i] = double(i);

  ATRIP_INT stride = 1;
  xcopy<double>(&ooo, Tijk, &stride, Zijk, &stride);

  double sum = 0;
  for (size_t i = 0; i < ooo; i++)
    sum = Tijk[i] + Zijk[i];

  std::cout << "sum: " << sum << std::endl;

  MPI_Finalize();
  return 0;
}
