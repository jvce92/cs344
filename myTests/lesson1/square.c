#include <stdio.h>

void square(float *d_out, float *d_in, const int size) {
    for (int i = 0; i < size; i++) {
        d_out[i] = d_in[i] * d_in[i];
    }
}

int main(int argc, char **argv) {
    const int ARRAY_SIZE =  1024;
    const int ARRRAY_BYTES = ARRAY_SIZE * sizeof(float);

    float h_in[ARRAY_SIZE];

    for (int i = 0; i < ARRAY_SIZE; i++) {
        h_in[i] = (float) i;
    }

    float h_out[ARRAY_SIZE];

    square(h_out, h_in, ARRAY_SIZE);

    for (int i = 0; i < ARRAY_SIZE; i++) {
        printf("%f", h_out[i]);
        printf(((i % 4) != 3) ? "\t" : "\n");
    }

    return 0;
}