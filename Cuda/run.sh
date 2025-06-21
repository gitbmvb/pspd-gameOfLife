#!/bin/bash

SOURCE_FILE="jogodavida.cu"
EXECUTABLE="jogo"
LOG_FILE="output.txt"

BLOCK_DIMS=(16 32 64 128 256)

echo "Resultados da execução CUDA - $(date)" > "$LOG_FILE"
echo "=========================================" >> "$LOG_FILE"

nvcc "$SOURCE_FILE" -o "$EXECUTABLE" -Wno-deprecated-gpu-targets
if [ $? -ne 0 ]; then
    echo "Erro na compilação CUDA." | tee -a "$LOG_FILE"
    exit 1
fi

for blockdim in "${BLOCK_DIMS[@]}"; do
    echo "Executando com blockDim=$blockdim" | tee -a "$LOG_FILE"

    {
        echo ">>> Saída para ./jogo $blockdim"
        ./"$EXECUTABLE" "$blockdim"
        echo "--------------------------------------"
    } >> "$LOG_FILE" 2>&1
done

echo "Execuções CUDA finalizadas. Resultados em $LOG_FILE"
