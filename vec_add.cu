#include <stdio.h>

#define N 10

__global__ void add_vector(int *a, int *b, int *c)
{
    int i = threadIdx.x + blockIdx.x * blockDim.x;    
    c[i] = a[i] + b[i];
}

int main(void)
{
    int a[N] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    int b[N] = {9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
    int c[N];
    int *d_a, *d_b, *d_c;
    int i;

    cudaMalloc((void **)&d_a, N * sizeof(int));
    cudaMalloc((void **)&d_b, N * sizeof(int));
    cudaMalloc((void **)&d_c, N * sizeof(int));

    cudaMemcpy(d_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

    add_vector<<<2, 5>>>(d_a, d_b, d_c);

    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, N * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    for (i = 0; i < N; i++) {
        printf("%d\n", c[i]);
    }

    return 0;
}
