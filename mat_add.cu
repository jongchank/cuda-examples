#include <stdio.h>

#define X 10
#define Y 10

__global__ void add_matrix(int *a, int *b, int *c)
{
    int i = threadIdx.x + blockIdx.x * blockDim.x;    
    c[i] = a[i] + b[i];
}

int main(void)
{
    int a[X][Y] = {
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    };
    int b[X][Y] = {
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
        {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    };
    int c[X][Y];
    int *d_a, *d_b, *d_c;
    int i;

    cudaMalloc((void **)&d_a, X * Y * sizeof(int));
    cudaMalloc((void **)&d_b, X * Y * sizeof(int));
    cudaMalloc((void **)&d_c, X * Y * sizeof(int));

    cudaMemcpy(d_a, a, X * Y * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, X * Y * sizeof(int), cudaMemcpyHostToDevice);

    add_matrix<<<10, 10>>>(d_a, d_b, d_c);

    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, X * Y * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    for (i = 0; i < X; i++) {
        for (int j = 0; j < Y; j++) {
            printf("%d ", c[i][j]);
        }
        printf("\n");
    }

    return 0;
}
