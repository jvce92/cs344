#include <stdio.h>
#include "gputimer.h"
#include <string>

#define NUM_THREADS 10000000
#define ARRAY_SIZE  100

#define BLOCK_WIDTH 1000

void print_array(int *array, int size)
{
    printf("{ ");
    for (int i = 0; i < size; i++)  { printf("%d ", array[i]); }
    printf("}\n");
}

__global__ void increment_naive(int *g)
{
	// which thread is this?
	int i = blockIdx.x * blockDim.x + threadIdx.x; 

	// each thread to increment consecutive elements, wrapping at ARRAY_SIZE
	i = i % ARRAY_SIZE;  
	g[i] = g[i] + 1;
}

__global__ void increment_atomic(int *g)
{
	// which thread is this?
	int i = blockIdx.x * blockDim.x + threadIdx.x; 

	// each thread to increment consecutive elements, wrapping at ARRAY_SIZE
	i = i % ARRAY_SIZE;  
	atomicAdd(& g[i], 1);
}

int main(int argc,char **argv)
{   
    if (argc < 2) return 1;
    std::string mode = std::string(argv[1]);

    GpuTimer timer;
    printf("%d total threads in %d blocks writing into %d array elements\n",
           NUM_THREADS, NUM_THREADS / BLOCK_WIDTH, ARRAY_SIZE);

    // declare and allocate host memory
    int h_array[ARRAY_SIZE];
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(int);
 
    // declare, allocate, and zero out GPU memory
    int * d_array;
    cudaMalloc((void **) &d_array, ARRAY_BYTES);
    cudaMemset((void *) d_array, 0, ARRAY_BYTES); 

    // launch the kernel - comment out one of these
    timer.Start();
    
    if (mode.compare("naive") == 0) {
        increment_naive<<<NUM_THREADS/BLOCK_WIDTH, BLOCK_WIDTH>>>(d_array);
    }
    else if (mode.compare("atomic") == 0) {
        increment_atomic<<<NUM_THREADS/BLOCK_WIDTH, BLOCK_WIDTH>>>(d_array);
    }
    else {
        printf("The argument must be either naive or atomic\n");
        return 1;
    }

    timer.Stop();
    
    // copy back the array of sums from GPU and print
    cudaMemcpy(h_array, d_array, ARRAY_BYTES, cudaMemcpyDeviceToHost);
    print_array(h_array, ARRAY_SIZE);
    printf("Time elapsed = %g ms\n", timer.Elapsed());
 
    // free GPU memory allocation and exit
    cudaFree(d_array);
    return 0;
}