#!/bin/bash

LOG_FILE="output.txt"

echo "Resultados da execução - $(date)" > "$LOG_FILE"
echo "======================================" >> "$LOG_FILE"

gcc jogodavidaOpGpu.c -o jogo -fopenmp
if [ $? -ne 0 ]; then
    echo "Erro na compilação." | tee -a "$LOG_FILE"
    exit 1
fi

THREADS_LIST=(1 2 4 8 16)

for threads in "${THREADS_LIST[@]}"; do
    echo "Executando com OMP_NUM_THREADS=$threads" | tee -a "$LOG_FILE"
    export OMP_NUM_THREADS=$threads

    { 
        echo ">>> Saída para OMP_NUM_THREADS=$threads"
        ./jogo
        echo "--------------------------------------"
    } >> "$LOG_FILE" 2>&1
done

echo "Execuções finalizadas. Resultados em $LOG_FILE"
