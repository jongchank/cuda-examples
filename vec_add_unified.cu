#include <stdio.h>

#define N 10

__global__ void add_vector(int *a, int *b, int *c)
{
    int i = threadIdx.x + blockIdx.x * blockDim.x;    
    c[i] = a[i] + b[i];
}

int main(void)
{
    int *a, *b, *c;

    // Allocate unified memory
    cudaMallocManaged(&a, N * sizeof(int));
    cudaMallocManaged(&b, N * sizeof(int));
    cudaMallocManaged(&c, N * sizeof(int));

    // Initialize the input arrays
    for (int i = 0; i < N; i++) {
        a[i] = i;
        b[i] = N - 1 - i;
    }

    // Launch the kernel
    add_vector<<<2, 5>>>(a, b, c);

    // Wait for the GPU to finish
    cudaDeviceSynchronize();

    // Print the result
    for (int i = 0; i < N; i++) {
        printf("%d ", c[i]);
    }
    printf("\n");

    // Free unified memory
    cudaFree(a);
    cudaFree(b);
    cudaFree(c);

    return 0;
}
