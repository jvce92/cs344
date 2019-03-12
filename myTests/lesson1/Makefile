# NVCC Compiler
NVCC=nvcc
CC=gcc

# CUDA Includes
CUDA_INCLUDE = /usr/local/cuda-10.0/include

# Flags
NVCC_FLAGS = -O3 -arch=compute_60 -code=sm_60 -Xcompiler -Wall -Xcompiler -Wextra -m64

GCC_FLAGS = -O3 -Wall -Wextra -m64

# Recipes
.PHONY: all clean

square: square.cu square.c
	$(CC) $(GCC_FLAGS) -o squareC square.c
	$(NVCC) $(NVCC_FLAGS) -I$(CUDA_INCLUDE) -o squareCUDA square.cu

clean:
	rm -f *.o
	rm -f squareC squareCUDA