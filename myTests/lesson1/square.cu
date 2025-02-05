#include <stdio.h>

__global__  void square(float *d_out, float *d_in) {
    int idx = threadIdx.x;
    float f = d_in[idx];
    d_out[idx] = f * f; 
}

int main(int argc, char **argv) {
    const int ARRAY_SIZE =  1024;
    const int ARRRAY_BYTES = ARRAY_SIZE * sizeof(float);

    float h_in[ARRAY_SIZE];

    for (int i = 0; i < ARRAY_SIZE; i++) {
        h_in[i] = (float) i;
    }

    float h_out[ARRAY_SIZE];

    float *d_in;
    float *d_out;

    cudaMalloc((void **) &d_in, ARRRAY_BYTES);
    cudaMalloc((void **) &d_out, ARRRAY_BYTES);

    cudaMemcpy(d_in, h_in, ARRRAY_BYTES, cudaMemcpyHostToDevice);

    square<<<1, ARRAY_SIZE>>>(d_out, d_in);

    cudaMemcpy(h_out, d_out, ARRRAY_BYTES, cudaMemcpyDeviceToHost);

    for (int i = 0; i < ARRAY_SIZE; i++) {
        printf("%f", h_out[i]);
        printf(((i % 4) != 3) ? "\t" : "\n");
    }

    cudaFree(d_in);
    cudaFree(d_out);

    return 0;
}