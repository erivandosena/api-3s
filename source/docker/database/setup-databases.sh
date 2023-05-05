#!/bin/bash

####################################################################################################
# 
# Nome do arquivo: setup-databases.sh
# Autor: Erivando Sena <erivandoramos@unilab.edu.br>
# Data de criacao: 29/04/2023
#
# Descricao: Este script foi desenvolvido como parte do projeto [Stack DEVOPS DTI] da 
#            Universidade da Integracao Internacional da Lusofonia Afro-Brasileira (UNILAB).
#
# Direitos autorais (c) 2023 Erivando Sena/UNILAB.
#
# E concedida permissao para usar, copiar, modificar e distribuir este software apenas para 
# uso pessoal ou em sua organizacao, desde que este aviso de direitos autorais apareca em 
# todas as copias. 
# Este software e fornecido "como esta" e sem garantias expressas ou implicitas, incluindo, 
# mas nao se limitando a, garantias implicitas de comercializacao e adequacao a um proposito 
# especifico. 
# Em nenhum caso, o autor sera responsavel por quaisquer danos diretos, indiretos, 
# incidentais, especiais, exemplares ou consequentes (incluindo, mas nao se limitando 
# a, aquisicao de bens ou servicos substitutos, perda de uso, dados ou lucros, ou 
# interrupcao dos negocios) decorrentes do uso, incapacidade de uso ou resultados do 
# uso deste software.
#
# Este programa e distribuido na esperanca de que possa ser util, mas SEM NENHUMA 
# GARANTIA; sem uma garantia implicita de ADEQUACAO a qualquer MERCADO ou APLICACAO EM PARTICULAR.
# Veja a Licenca Publica Geral GNU para mais detalhes.
#
####################################################################################################

# Connection options:
#   -h, --host=HOSTNAME      host do servidor de banco de dados
#   -p, --port=PORT          porta do servidor de banco de dados
#   -U, --username=USERNAME  nome de usuario do banco de dados
#   -w, --no-password        nunca solicitar senha
#   -W, --password           forcar prompt de senha (should happen automatically)

# set -euo pipefail

set +eu

readonly MAX_ATTEMPTS=25
readonly WAIT_TIME=15

# connection_string_root="-h $PG_HOST -p $PG_PORT -U $PG_USER_ROOT -d $PG_DATABASE"
# connection_string_root_con="host=$PG_HOST port=$PG_PORT user=$PG_USER_ROOT dbname=$PG_DATABASE"
connection_string_root_con="postgresql://$PG_USER_ROOT:$PG_ROOT_PASSWORD@$PG_HOST:$PG_PORT/$PG_DATABASE" 

# echo "$connection_string_root"
echo "$connection_string_root_con"

# funcoes gerais
function verifica_postgres() {
    local connection_string="$1"
    local attempts=0

    until psql $connection_string -c '\q'; do
        >&2 echo "PostgreSQL indisponivel! Tentando novamente em $WAIT_TIME segundos."
        sleep $WAIT_TIME

        attempts=$((attempts+1))
        if [ $attempts -eq $MAX_ATTEMPTS ]; then
            >&2 echo "Falha ao conectar ao PostgreSQL apos $MAX_ATTEMPTS tentativas."
            exit 1
        fi
    done
    echo "Servidor PostgreSQL UP!"
}

function database_exists() { 
    local database_name="$1"
    return=$(psql -tA $connection_string_root_con -c "SELECT 1 FROM pg_database WHERE datname='$database_name';" | grep -qc 1)
}

function user_exists() {
    local username="$1"
    local exists=$(psql -tA $connection_string_root_con -c "SELECT 1 FROM pg_roles WHERE rolname='$username';")
    if [[ -n $exists ]]; then
        return 1
    else
        return 0
    fi
}

function create_user_admin() { 
    local username=$1
    if [[ $(user_exists "$username") -eq 0 ]]; then
        psql -v ON_ERROR_STOP=1 -d $connection_string_root_con <<-EOSQL
            CREATE ROLE $username WITH
                SUPERUSER
                LOGIN 
                CREATEDB
                CREATEROLE
                REPLICATION
                INHERIT
                CONNECTION LIMIT -1
                PASSWORD 'md56ca6a5dafcdbc6a71988f97f4fc56fa1';

            COMMENT ON ROLE $username IS 'Usuario admin padrao';
EOSQL
    fi
}

function create_user_regular() {
    local username=$1
    if [[ $(user_exists "$username") -eq 0 ]]; then
        psql -v ON_ERROR_STOP=1 -d $connection_string_root_con <<-EOSQL
            CREATE ROLE $username WITH
                LOGIN 
                CREATEDB
                CREATEROLE
                REPLICATION
                INHERIT
                CONNECTION LIMIT -1
                PASSWORD 'md56ca6a5dafcdbc6a71988f97f4fc56fa1';

            COMMENT ON ROLE $username IS 'Usuario regular padrao';
EOSQL
    fi
}

function check_user_privilegios() {
    local database="$1"
    local user="$2"
    local result=$(psql -tA $connection_string_root_con -c "SELECT has_database_privilege('$user', '$database', 'CREATE');" 2>/dev/null)

    if [[ "$result" == "t" ]]; then
        return 1
    else
        return 0
    fi
}

function check_owner_database() {
    local database="$1"
    local user="$2"
    if [[ $(psql -tA $connection_string_root_con -c "SELECT pg_catalog.pg_get_userbyid(d.datdba) AS owner FROM pg_catalog.pg_database d WHERE d.datname = '$database';") == '$user' ]]; then
        return 1
    else
        return 0
    fi
}

function create_database() {
	local database=$1
    local user=$2
    psql -v ON_ERROR_STOP=1 -d $connection_string_root_con <<-EOSQL
        CREATE DATABASE "$database"
            WITH
            OWNER = '$user'
            ENCODING = 'UTF8'
            CONNECTION LIMIT = -1
            TEMPLATE template0;

        COMMENT ON DATABASE "$database" IS 'Dadabase PostgreSQL $database';
EOSQL
}

function atribui_privilegios() {
    local database="$1"
    local user="$2"
    psql -v ON_ERROR_STOP=1 -d $connection_string_root_con <<-EOSQL
        GRANT CONNECT ON DATABASE "$database" TO $user;
        GRANT USAGE ON SCHEMA public TO $user;
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO $user;
        GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO $user;
        ALTER DEFAULT PRIVILEGES FOR USER $user GRANT CREATE ON TABLES TO $user;
        ALTER DEFAULT PRIVILEGES FOR USER $user GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $user;
        ALTER DEFAULT PRIVILEGES FOR USER $user GRANT TRUNCATE, REFERENCES, TRIGGER ON TABLES TO $user;
        ALTER DEFAULT PRIVILEGES FOR USER $user IN SCHEMA public GRANT SELECT, UPDATE ON SEQUENCES TO $user;
EOSQL
}

function atribui_privilegios_owner() {
    local database="$1"
    local user="$2"
    psql -v ON_ERROR_STOP=1 -d $connection_string_root_con <<-EOSQL
        ALTER DATABASE "$database" OWNER TO $user;
        GRANT ALL PRIVILEGES ON DATABASE "$database" TO $user;
EOSQL
}

# Aguarda conexao com o PostgreSQL
verifica_postgres "$connection_string_root_con"

# Setup database
if ! database_exists "$PG_DATABASE"; then
    create_database "$PG_DATABASE" "$PG_USER"
fi

if ! database_exists "$PG_DATABASE_HOMOLOGACAO"; then
    create_database "$PG_DATABASE_HOMOLOGACAO" "$PG_USER"
fi

# Setup user admin
array_users=(${USERS_DUMP_ROOT})
for i in ${!array_users[@]}; do
    username="${array_users[$i]}"

    create_user_admin "$username"

    if [[ $(check_user_privilegios "$PG_DATABASE" "$username") -eq 0 ]]; then
        atribui_privilegios "$PG_DATABASE" "$username"
    fi

    if [[ $(check_user_privilegios "$PG_DATABASE_HOMOLOGACAO" "$username") -eq 0 ]]; then
        atribui_privilegios "$PG_DATABASE_HOMOLOGACAO" "$username"
    fi

    if [[ $(check_owner_database "$PG_DATABASE" "$username") -eq 0 ]]; then
        atribui_privilegios_owner "$PG_DATABASE" "$username"
    fi

    if [[ $(check_owner_database "$PG_DATABASE_HOMOLOGACAO" "$username") -eq 0 ]]; then
        atribui_privilegios_owner "$PG_DATABASE_HOMOLOGACAO" "$username"
    fi
done

# Setup user regular
array_users=(${USERS_DUMP})
for i in ${!array_users[@]}; do
    username="${array_users[$i]}"

    create_user_regular "$username"

    if [[ $(check_user_privilegios "$PG_DATABASE" "$username") -eq 0 ]]; then
        atribui_privilegios "$PG_DATABASE" "$username"
    fi

    if [[ $(check_user_privilegios "$PG_DATABASE_HOMOLOGACAO" "$username") -eq 0 ]]; then
        atribui_privilegios "$PG_DATABASE_HOMOLOGACAO" "$username"
    fi
done