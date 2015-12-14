#!/bin/sh

############################################
# Pull in ~/.dserc if it exists
# and extract the credentials
############################################
HADOOP_CREDENTIALS=""
HIVE_CREDENTIALS=""
SQOOP_CREDENTIALS=""
SPARK_CREDENTIALS=""
SHARK_CREDENTIALS=""
DSE_CREDENTIALS=""

read_password()
{
    stty -echo
    trap "stty echo; kill -9 $$" INT
    read "$@"
    stty echo
    trap - INT
    echo
}

set_credentials() {
    if [ -z $DSE_CREDENTIALS_SUPPLIED ]; then

        if [ ! -z $dse_username ]; then
            DSE_USERNAME="$dse_username"
            if [ -z $dse_password ]; then
                printf "Password: "
                read_password dse_password
                export dse_password
            fi
            DSE_PASSWORD="$dse_password"
        elif [ -f ~/.dserc ]; then
            DSE_USERNAME=$(echo `cat ~/.dserc | grep username` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
            DSE_PASSWORD=$(echo `cat ~/.dserc | grep password` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
            DSE_SASL_PROTOCOL=$(echo `cat ~/.dserc | grep sasl_protocol` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
            DSE_LOGIN_CONFIG=$(echo `cat ~/.dserc | grep login_config` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
        fi

        if [ ! -z $DSE_USERNAME ]; then
            HADOOP_CREDENTIALS="-Dcassandra.username=$DSE_USERNAME -Dcassandra.password=$DSE_PASSWORD"
            HIVE_CREDENTIALS="--hiveconf cassandra.username=$DSE_USERNAME --hiveconf cassandra.password=$DSE_PASSWORD"
            SQOOP_CREDENTIALS="--cassandra-username=$DSE_USERNAME --cassandra-password=$DSE_PASSWORD"
            export SPARK_CREDENTIALS="$HADOOP_CREDENTIALS"
            export SHARK_CREDENTIALS="$HIVE_CREDENTIALS"
            export SPARK_SQL_SERVER_CREDENTIALS="$HIVE_CREDENTIALS"
            DSE_CREDENTIALS="$HADOOP_CREDENTIALS"
        fi
    fi
    if [ ! -z $dse_jmx_username ]; then
        DSE_JMX_USERNAME="$dse_jmx_username"
        if [ -z $dse_jmx_password ]; then
            printf "JMX Password: "
            read_password dse_jmx_password
            export dse_jmx_password
        fi
        DSE_JMX_PASSWORD="$dse_jmx_password"
    elif [ -f ~/.dserc ]; then
        DSE_JMX_USERNAME=$(echo `cat ~/.dserc | grep jmx_username` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
        DSE_JMX_PASSWORD=$(echo `cat ~/.dserc | grep jmx_password` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
    fi
    if [ ! -z $DSE_JMX_USERNAME ]; then
        DSE_JMX_CREDENTIALS="-a $DSE_JMX_USERNAME -b $DSE_JMX_PASSWORD"
        CASSANDRA_JMX_CREDENTIALS="-u $DSE_JMX_USERNAME -pw $DSE_JMX_PASSWORD"
    fi
}

set_credentials
