# 🚀 [PSPD Labs] Game of Life

Este repositório contém uma adaptação distribuída do clássico **Jogo da Vida de Conway**, utilizando **MPI**, **OpenMP** e **CUDA** para explorar paralelismo em diferentes níveis: entre nós, entre threads e em GPUs.

## 📌 Objetivo

A proposta do projeto é estudar e comparar abordagens paralelas para o **Jogo da Vida**, um autômato celular com regras simples, mas que gera comportamentos complexos. Comparamos três paradigmas de paralelização:

* **MPI (Message Passing Interface)**: para comunicação entre múltiplos processos distribuídos.
* **OpenMP**: para paralelismo em múltiplos threads em CPUs.
* **CUDA**: para execução em paralelo massivo em GPUs NVIDIA.

## 🧠 Sobre o Jogo da Vida

O Jogo da Vida é um autômato celular proposto por John Conway. Ele ocorre em uma grade bidimensional de células, onde cada célula pode estar viva (1) ou morta (0). A cada geração, as células são atualizadas com base nas seguintes regras:

1. Célula viva com 2 ou 3 vizinhas vivas continua viva.
2. Célula morta com exatamente 3 vizinhas vivas se torna viva.
3. Caso contrário, a célula morre ou continua morta.

<p align="center">
  <img src="docs/game_of_life_1.gif" alt="Image 1" width="45%" />
  <img src="docs/game_of_life_2.gif" alt="Image 2" width="45%" />
</p>


## 🧩 Arquitetura

A estrutura do projeto é organizada por diretórios conforme a abordagem de paralelização utilizada. Cada pasta contém o código-fonte principal e um script `run.sh` para facilitar a execução:

```
.
├── cuda/              # Implementação usando CUDA para execução em GPU
│   ├── jogodavida.cu
│   └── run.sh
├── mpi/               # Implementação distribuída com MPI
│   ├── jogodavidampi.c
│   └── run.sh
├── openmp/            # Versão paralela para CPU com OpenMP
│   ├── jogodavidaomp.c
│   └── run.sh
├── openm-gpu/        # Versão híbrida com OpenMP direcionado para GPU
│   ├── jogodavidaOpGpu.c
│   └── run.sh
├── README.md          # Documento explicativo do projeto
└── jogodavida.c       # Versão sequencial (base) do Jogo da Vida
```

## 🛠️ Como compilar e executar

### Requisitos

* **MPI**: OpenMPI ou MPICH
* **OpenMP**: GCC com suporte a OpenMP
* **CUDA**: NVIDIA GPU + Toolkit instalado

### MPI

```bash
cd mpi
mpicc jogodavidampi.c -o game
mpirun -np 4 ./game
```
Você pode variar a quantidade de processos alterando o valor à direita da flag `-np`. Para executar o benchmarking,

```bash
cd mpi
chmod +x run.sh
./run.sh
```

### OpenMP

```bash
cd openmp
gcc -fopenmp jogodavidaomp.c -o game
./game
```
Você pode variar a quantidade de threads por meio da variável de ambiente `OMP_NUM_THREADS`. Por exemplo:

```bash
export OMP_NUM_THREADS=20
```
Para executar o benchmarking,

```bash
cd openmp
chmod +x run.sh
./run.sh
```

### CUDA

```bash
cd cuda
nvcc jogodavida.cu -o game
./game
```
O kernel é automaticamente iniciado com tamanho de bloco `16`, todavia é possível alterá-lo passando como argumento o valor desejado. Por exemplo, no código abaixo executamos o kernel com um bloco de tamanho 32, havendo previamente compilado com o nvcc:

```bash
./game 32
```
Para realizar o benchmarking, basta executar:

```bash
cd cuda
chmod +x run.sh
./run.sh
```

## 📈 Benchmarking

A partir da execução e avaliação do código do Jogo da Vida com diferentes abordagens de paralelismo (MPI, OpenMP para CPU, OpenMP Target com GPU e CUDA), foi possível constatar diferenças significativas quanto ao desempenho para diferentes tamanhos de tabuleiro. Todas as versões produziram resultados corretos, porém com eficiências distintas dependendo da tecnologia utilizada e da escala do problema.

* A versão com **MPI** mostrou desempenho aceitável para tamanhos pequenos e médios, mas não se destacou para tamanhos grandes (≈1024), mesmo com mais processos, em virtude dos custos de comunicação e da natureza do paralelismo distribuído em uma máquina local.
* A versão com **OpenMP tradicional (CPU)** teve um desempenho melhor que o MPI em muitos casos e foi relativamente fácil de implementar, com boa escalabilidade até certo número de threads. Entretanto, não obteve os melhores resultados em tempo para entradas grandes.
* A versão com **OpenMP Target (GPU)** foi eficiente, especialmente em tamanhos médios a grandes, mas ficou atrás do CUDA em desempenho bruto. Seu principal diferencial é permitir o uso de GPUs com uma curva de aprendizado muito mais suave, mantendo a portabilidade e simplicidade do OpenMP.
* A versão com **CUDA** apresentou o melhor desempenho absoluto entre todas as abordagens, com tempos extremamente reduzidos mesmo em tamanhos grandes (≈1024). Isso confirma a eficiência do modelo de execução CUDA para cálculos massivamente paralelos.

Para fins educacionais e de prototipagem, OpenMP Target é a melhor escolha, pois é simples, portável e com desempenho competitivo. Todavia, para aplicações de altíssimo desempenho, CUDA é preferível, embora mais complexa. O MPI é mais adequado para execução distribuída em cluster, não sendo a melhor opção em execução local com acesso a GPUs.

## 🎥 Vídeo de Apresentação

[Link]()

## 📝 Relatório Completo

[Acesse aqui](docs/report.pdf).

## 👥 Autores

<div align="center">
   <table style="margin-left: auto; margin-right: auto;">
        <tr>
            <td align="center">
                <a href="https://github.com/arthurgrandao">
                    <img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/85596312?v=4" width="150px;"/>
                    <h5 class="text-center">Arthur Grandão <br>211039250</h5>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/gitbmvb">
                    <img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/30751876?v=4" width="150px;"/>
                    <h5 class="text-center">Bruno Martins <br>211039297</h5>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/dougAlvs">
                    <img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/98109429?v=4" width="150px;"/>
                    <h5 class="text-center">Douglas Alves <br>211029620</h5>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/g16c">
                    <img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/90865675?v=4" width="150px;"/>
                    <h5 class="text-center">Gabriel Campello <br>211039439</h5>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/manuziny">
                    <img style="border-radius: 50%;" src="https://avatars.githubusercontent.com/u/88348637?v=4" width="150px;"/>
                    <h5 class="text-center">Geovanna Avelino <br>202016328</h5>
                </a>
            </td>
    </table>
</div>

## 📚 Referências

CONWAY, John. *Conway's Game of Life*. Wikipedia, 2024. Disponível em: [https://en.wikipedia.org/wiki/Conway%27s\_Game\_of\_Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life). Acesso em: 21 jun. 2025.

OPEN MPI. *Official Open MPI website*. \[S.l.]: Open MPI, \[2025?]. Disponível em: [https://www.open-mpi.org/](https://www.open-mpi.org/). Acesso em: 21 jun. 2025.

OPENMP ARCHITECTURE REVIEW BOARD. *The OpenMP API specification for parallel programming*. \[S.l.]: OpenMP, \[2025?]. Disponível em: [https://www.openmp.org/](https://www.openmp.org/). Acesso em: 21 jun. 2025.

NVIDIA CORPORATION. *CUDA Zone*. \[S.l.]: NVIDIA, \[2025?]. Disponível em: [https://developer.nvidia.com/cuda-zone](https://developer.nvidia.com/cuda-zone). Acesso em: 21 jun. 2025.
