#!/bin/bash

export LANG=pt_BR.UTF-8

#Ficheiro onde os dados vão ser armazenados
FICHEIRO_DADOS="dados_financeiros.txt"

#Função para inicializar o ficheiro de dados
init_ficheiro(){
    if [[ ! -f "$FICHEIRO_DADOS" ]]; then
        echo "Data;Tipo;Categoria;Valor;Descrição" > "$FICHEIRO_DADOS"
    fi
}

#Função para adicionar receitas ou despesas
adicionar_transacao(){
    echo "=== Adicionar Transação ==="
    read -p "Tipo (Receita ou Despesa): " Tipo
    read -p "Categoria (ex:Alimentação, Salário; etc..): " Categoria
    read -p "Valor: " Valor
    read -p "Descrição: " Descricao

    if [["$Tipo" != "Receita" && "$Tipo" != "Despesa" ]]; then
        echo "Erro: Tipo inválido, use 'Receita' ou 'Despesa'."
        return
    fi

#Registar no ficheiro
echo "$(date '+%d-%m-%Y') | $Tipo | $Categoria | $Valor | $Descricao" >> "$FICHEIRO_DADOS"
echo "Transação adicionada com sucesso!"

}

#Função paara ver o saldo atual
ver_saldo(){
    echo "=== Saldo Atual ==="
    Receita=$(awk -F';' '$2 == "Receita" {sum += $4} END {print sum}' "$FICHEIRO_DADOS")
    Despesa=$(awk -F';' '$2 == "Despesa" {sum += $4} END {print sum}' "$FICHEIRO_DADOS")
    Saldo=$(echo "$Receita - $Despesa" | bc)
    

    echo "Receitas: $Receita€"
    echo "Despesas: $Despesa€"
    echo "Saldo: $Saldo€"
}

#Função para exportar os dados para CSV
exportar_csv(){
    echo "=== Exportar Dados ==="
    read -p "Digite o nome do arquivo CSV: " nome_ficheiro
    cp "$FICHEIRO_DADOS" "$nome_ficheiro"
    echo "Dados exportados para $nome_ficheiro"

    if [ -f "$nome_ficheiro" ]; then
        echo "O ficheiro $nome_ficheiro existe!"
    else
        echo "O ficheiro $nome_ficheiro não foi encontrado."
    fi
}

#Função do Menu principal
menu(){
    while true; do
        echo "=== Simulador de fluxo financeiro ==="
        echo "1. Adicionar Transação"
        echo "2. Ver Saldo Atual"
        echo "3. Exportar para ficheiro CSV"
        echo "4. Sair"
        read -p "Escolha uma opção: " Opcao

        case "$Opcao" in
            1) adicionar_transacao ;;
            2) ver_saldo ;;
            3) exportar_csv ;;
            4) echo "A sair..."; break ;;
            *) echo "Opção inválida!" ;;
        esac

    done
}

#Inicializar o ficheiro e executar o Menu principal
init_ficheiro
menu

