#!/bin/bash

SOURCE_FILE="jogodavidampi.c"
EXECUTABLE="jogo_mpi"
LOG_FILE="output.txt"

PROCESS_LIST=(1 2 4 8)

echo "Resultados da execução MPI - $(date)" > "$LOG_FILE"
echo "=========================================" >> "$LOG_FILE"

mpicc "$SOURCE_FILE" -o "$EXECUTABLE"
if [ $? -ne 0 ]; then
    echo "Erro na compilação MPI." | tee -a "$LOG_FILE"
    exit 1
fi

for np in "${PROCESS_LIST[@]}"; do
    echo "Executando com $np processo(s)" | tee -a "$LOG_FILE"

    {
        echo ">>> Saída para mpirun -np $np"
        mpirun -np "$np" ./"$EXECUTABLE"
        echo "-------------------------------------"
    } >> "$LOG_FILE" 2>&1
done

echo "Execuções MPI finalizadas. Resultados em $LOG_FILE"
