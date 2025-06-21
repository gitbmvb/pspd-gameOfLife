#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <sys/time.h>

#define ind2d(i, j, tam) ((i) * (tam + 2) + (j))
#define POWMIN 3
#define POWMAX 10

__host__ double wall_time(void)
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec + tv.tv_usec / 1000000.0;
}

__global__ void UmaVidaKernel(int *tabIn, int *tabOut, int tam)
{
    int i = blockIdx.y * blockDim.y + threadIdx.y + 1;
    int j = blockIdx.x * blockDim.x + threadIdx.x + 1;

    if (i <= tam && j <= tam)
    {
        int idx = ind2d(i, j, tam);
        int vizviv =
            tabIn[ind2d(i - 1, j - 1, tam)] + tabIn[ind2d(i - 1, j, tam)] + tabIn[ind2d(i - 1, j + 1, tam)] +
            tabIn[ind2d(i, j - 1, tam)] + tabIn[ind2d(i, j + 1, tam)] +
            tabIn[ind2d(i + 1, j - 1, tam)] + tabIn[ind2d(i + 1, j, tam)] + tabIn[ind2d(i + 1, j + 1, tam)];

        if (tabIn[idx] && vizviv < 2)
            tabOut[idx] = 0;
        else if (tabIn[idx] && vizviv > 3)
            tabOut[idx] = 0;
        else if (!tabIn[idx] && vizviv == 3)
            tabOut[idx] = 1;
        else
            tabOut[idx] = tabIn[idx];
    }
}

__host__ void InitTabul(int *tabIn, int *tabOut, int tam)
{
    for (int i = 0; i < (tam + 2) * (tam + 2); i++)
        tabIn[i] = tabOut[i] = 0;

    tabIn[ind2d(1, 2, tam)] = 1;
    tabIn[ind2d(2, 3, tam)] = 1;
    tabIn[ind2d(3, 1, tam)] = 1;
    tabIn[ind2d(3, 2, tam)] = 1;
    tabIn[ind2d(3, 3, tam)] = 1;
}

__host__ int Correto(int *tab, int tam)
{
    int cnt = 0;
    for (int i = 0; i < (tam + 2) * (tam + 2); i++)
        cnt += tab[i];
    return (cnt == 5 &&
            tab[ind2d(tam - 2, tam - 1, tam)] &&
            tab[ind2d(tam - 1, tam, tam)] &&
            tab[ind2d(tam, tam - 2, tam)] &&
            tab[ind2d(tam, tam - 1, tam)] &&
            tab[ind2d(tam, tam, tam)]);
}

void SaveTabulToFile(const char *filename, int *tabul, int tam)
{
    FILE *f = fopen(filename, "w");
    if (!f)
    {
        perror("fopen");
        exit(1);
    }
    for (int i = 1; i <= tam; i++)
    {
        for (int j = 1; j <= tam; j++)
        {
            fputc(tabul[ind2d(i, j, tam)] ? 'X' : '.', f);
        }
        fputc('\n', f);
    }
    fclose(f);
}

int main(int argc, char * argv[]) {
    for (int pow = POWMIN; pow <= POWMAX; pow++)
    {
        int tam = 1 << pow;
        size_t size = (tam + 2) * (tam + 2) * sizeof(int);

        int *h_in = (int *)malloc(size);
        int *h_out = (int *)malloc(size);
        InitTabul(h_in, h_out, tam);

        int *d_in, *d_out;
        cudaMalloc((void **)&d_in, size);
        cudaMalloc((void **)&d_out, size);

        cudaMemcpy(d_in, h_in, size, cudaMemcpyHostToDevice);
        cudaMemcpy(d_out, h_out, size, cudaMemcpyHostToDevice);

        int block_dim = argc > 1 ? atoi(argv[1]) : 16;

        dim3 block(block_dim, block_dim);
        dim3 grid((tam + block.x - 1) / block.x, (tam + block.y - 1) / block.y);

        double t0 = wall_time();
        for (int i = 0; i < 2 * (tam - 3); i++)
        {
            UmaVidaKernel<<<grid, block>>>(d_in, d_out, tam);
            UmaVidaKernel<<<grid, block>>>(d_out, d_in, tam);
        }
        cudaDeviceSynchronize();
        double t1 = wall_time();

        cudaMemcpy(h_in, d_in, size, cudaMemcpyDeviceToHost);

        printf("tam=%d; tempo CUDA=%7.7f - ", tam, t1 - t0);
        if (Correto(h_in, tam))
            printf("**RESULTADO CORRETO**\n");
        else
            printf("**RESULTADO ERRADO**\n");

        cudaFree(d_in);
        cudaFree(d_out);

        char file_name[30];
        snprintf(file_name, sizeof(file_name), "saida_gpu_%d.txt", tam);

        // SaveTabulToFile(file_name, h_in, tam);

        free(h_in);
        free(h_out);
    }
    return 0;
}
