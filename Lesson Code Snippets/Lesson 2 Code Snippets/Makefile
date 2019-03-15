# NVCC Compiler
NVCC=nvcc
CC=gcc

# CUDA Includes
CUDA_INCLUDE = /usr/local/cuda-10.0/include

# Flags
NVCC_FLAGS = -O3 -arch=compute_60 -code=sm_60 -Xcompiler -Wall -Xcompiler -Wextra -m64

GCC_FLAGS = -O3 -Wall -Wextra -m64

BASENAME = associative atomics hello_blockIdx hello_threadIdx memory
SRC = $(addsuffix .cu, $(BASENAME))
OBJS = $(addsuffix .o, $(BASENAME))

# Recipes
.PHONY: all clean

all: $(OBJS)

%.o: %.cu
	$(NVCC) $(NVCC_FLAGS) -I$(CUDA_INCLUDE) -o $@ $<

run: 
	@for obj in $(OBJS); do \
		echo "==========================================\nRunning $$obj" ; \
		./$$obj ; \
	done

clean:
	rm -f *.o
	