#!/bin/bash

#Ficheiro onde os dados vão ser armazenados
FICHEIRO_DADOS="dados_financeiros.txt"

#Função para inicializar o ficheiro de dados
init_file(){
    if [[! -f "$FICHEIRO_DADOS"]]; then
        echo "Data;Tipo;Categoria;Valor;Descrição" > "$FICHEIRO_DADOS"
    fi
}

#Função para adicionar receitas ou despesas
adicionar_transacao(){
    echo "=== Adicionar Transação ==="
    read -p "Tipo (Receita ou Despesa): "
    read -p "Categoria (ex:Alimentação, Salário; etc..): "
    read -p "Valor: "
    read -p "Descrição: "

    if [["$Tipo" != "Receita" && "$Tipo" != "Despesa" ]]; then
        echo "Erro: Tipo inválido, use 'Receita' ou 'Despesa'."
        return
    fi

#Registar no ficheiro
echo "$(date '+%A-%m-%d') | $Tipo | $Categoria | $Valor | $Descricao" >> "$FICHEIRO_DADOS"
echo "Transação adicionada com sucesso!"

}

#Função paara ver o saldo atual
ver_saldo(){
    echo "=== Saldo Atual ==="
    Receita=$(awk -F';' '$2 == "Receita" {sum += $4} END {print sum}' "$FICHEIRO_DADOS")
    Despesa=$(awk -F';' '$2 == "Despesa" {sum += $4} END {print sum}' "$FICHEIRO_DADOS")
    Saldo=$(echo "$Receita - $Despesa" | bc)

    echo "Receitas: € $Receita"
    echo "Despesas: € $Despesa"
    echo "Saldo: € $Saldo"
}
