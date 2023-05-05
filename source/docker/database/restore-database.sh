#!/bin/bash

###############################################################################
# 
# Nome do arquivo: restore-database.sh
# Autor: Erivando Sena <erivandoramos@unilab.edu.br>
# Data de criação: 28/04/2023
#
# Descrição: Este script foi desenvolvido como parte do projeto [Stack DEVOPS DTI] da 
#            Universidade da Integração Internacional da Lusofonia Afro-Brasileira (UNILAB).
#
# Direitos autorais (c) 2023 Erivando Sena/UNILAB.
#
# É concedida permissão para usar, copiar, modificar e distribuir este software apenas para 
# uso pessoal ou em sua organização, desde que este aviso de direitos autorais apareça em 
# todas as cópias. 
# Este software é fornecido "como está" e sem garantias expressas ou implícitas, incluindo, 
# mas não se limitando a, garantias implícitas de comercialização e adequação a um propósito 
# específico. 
# Em nenhum caso, o autor será responsável por quaisquer danos diretos, indiretos, 
# incidentais, especiais, exemplares ou consequentes (incluindo, mas não se limitando 
# a, aquisição de bens ou serviços substitutos, perda de uso, dados ou lucros, ou 
# interrupção dos negócios) decorrentes do uso, incapacidade de uso ou resultados do 
# uso deste software.
#
# Este programa é distribuído na esperança de que possa ser útil, mas SEM NENHUMA 
# GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
# Veja a Licença Pública Geral GNU para mais detalhes.
#
##############################################################################

# uso: ./estore-database.sh db.host.com db user password

set +eu

function restore_postgres_prod() {
    local connection_string_root_con="postgresql://$PG_USER:$PG_PASSWORD@$PG_HOST:$PG_PORT/$PG_DATABASE" 
    pg_restore --list /tmp/bd_pg_dump.dmp | sed -E 's/(.* EXTENSION )/; \1/g' > /tmp/bd_pg_dump.toc
    pg_restore -v -j 2 -Fc -c -L /tmp/bd_pg_dump.toc -d $connection_string_root_con /tmp/bd_pg_dump.dmp
}

function restore_postgres_homolog() {
    local connection_string_root_con="postgresql://$PG_USER:$PG_PASSWORD_HOMOLOGACAO@$PG_HOST:$PG_PORT/$PG_DATABASE_HOMOLOGACAO" 
    pg_restore --list /tmp/bd_pg_dump.dmp | sed -E 's/(.* EXTENSION )/; \1/g' > /tmp/bd_pg_dump.toc
    pg_restore -v -j 2 -Fc -c -L /tmp/bd_pg_dump.toc -d $connection_string_root_con /tmp/bd_pg_dump.dmp

    # Verificar se pg_restore foi executado com sucesso
    if [ "$?" -ne 0 ]; then
        echo "Erro ao restaurar o database!"
        exit 1
    else
        echo "O banco de dados foi restaurado com sucesso!"
    fi
}
