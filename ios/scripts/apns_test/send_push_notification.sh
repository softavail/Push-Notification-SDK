#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR="$(pwd)"

# constants
PUSH_TYPE_ALERT=alert
PUSH_TYPE_BACKGROUND=background
PUSH_TYPE_VOIP=voip
DEFAULT_PUSH_TYPE=${PUSH_TYPE_ALERT}

PUSH_ENVIRONMENT_PROD=prod
PUSH_ENVIRONMENT_DEVEL=devel
DEFAULT_PUSH_ENVIRONMENT=${PUSH_ENVIRONMENT_DEVEL}

PUSH_SERVER_DEV=api.sandbox.push.apple.com:443
PUSH_SERVER_PROD=api.push.apple.com:443

BUNDLE_ID=com.syniverse.scg.push.demo.app

# parameters
PUSH_ENVIRONMENT=
PUSH_TYPE=
PUSH_SERVER=
PUSH_TOPIC=

# set archive base dir
OPT_PUSH_TYPE=${DEFAULT_PUSH_TYPE}
OPT_DEVICE_TOKEN=
OPT_CERT=
OPT_PAYLOAD=
OPT_ENVIRONMENT=${DEFAULT_PUSH_ENVIRONMENT}
OPT_FLAVOUR=${DEFAULT_FLAVOUR}

while getopts ":d:c:p:e:t:" opt; do
case $opt in
    d)
        OPT_DEVICE_TOKEN="$OPTARG"
        ;;
    c)
        OPT_CERT="$OPTARG"
        ;;
    p)
        OPT_PAYLOAD="$OPTARG"
        ;;
    e)
        OPT_ENVIRONMENT="$OPTARG"
        ;;
    t)
        OPT_PUSH_TYPE="$OPTARG"
        ;;
    \?)
        usage "Unknown option: -$OPTARG"
        ;;
    :)
        usage "Option -$OPTARG requires an argument."
        ;;
esac
done


# change current directory where scripts file is
cd "${SCRIPT_DIR}"

#exit batch script with error
do_exit ()
{
    echo "ERROR: $1" 1>&2
    cd "${CURRENT_DIR}"
    exit 1
}

#check for failure
check_failure ()
{
    if [ $? != 0 ]; then
        do_exit "ERROR: $1"
    fi
}

#print usage and exit with error
usage()
{
    echo "==================================================================================="
    echo "Usage: `basename $0` -d <device_token> -c <cert> -p <payload> -e [environment] -t [push_type]"
    echo ""
    echo "Options:"
    echo "  -d device_token : Device token to send the push to"
    echo "  -c cert         : Path to certificate (.pem) file"
    echo "  -p payload      : JSON payload for notifications"
    echo "  -e environment  : Environment: ${PUSH_ENVIRONMENT_PROD} or ${PUSH_ENVIRONMENT_DEVEL}. Default is: ${DEFAULT_PUSH_ENVIRONMENT}"
    echo "  -f push_type    : Type: ${PUSH_TYPE_ALERT}, ${PUSH_TYPE_VOIP} or ${PUSH_TYPE_BACKGROUND}. Default is: ${DEFAULT_PUSH_TYPE}"
    echo "==================================================================================="

    #restore current directory
    cd "${CURRENT_DIR}"
    do_exit "$1"
}


check_depends()
{
    echo "checking git ..."
    if ! [ -x "$(command -v curl)" ]; then
      do_exit "Error: curl is not installed"
    fi
}

# check input arguments
check_arguments()
{
    local PUSH_TOPIC_SUFFIX=

    if [ X"${OPT_PUSH_TYPE}" == X ]; then
        usage "Invalid usage: must specify push_type"
    elif [ ${OPT_PUSH_TYPE} == ${PUSH_TYPE_ALERT} ]; then
        PUSH_TYPE=${OPT_PUSH_TYPE}
    elif [ ${OPT_PUSH_TYPE} == ${PUSH_TYPE_BACKGROUND} ]; then
        PUSH_TYPE=${OPT_PUSH_TYPE}
    elif [ ${OPT_PUSH_TYPE} == ${PUSH_TYPE_VOIP} ]; then
        PUSH_TYPE=${OPT_PUSH_TYPE}
        PUSH_TOPIC_SUFFIX=".${PUSH_TYPE_VOIP}"
    else
        usage "Invalid usage: unknown push_type ${PUSH_TYPE}"
    fi

    if [ X"${OPT_DEVICE_TOKEN}" == X"" ]; then
        usage "Invalid usage: must specify device_token"
    fi

    if [[ X"${OPT_CERT}" == X ]]; then
        usage "Invalid usage: must specify certificate"
    elif [[ ! -e "${OPT_CERT}" ]]; then
        do_exit "PEM file <${OPT_CERT}> does not exist"
    fi

    if [ X"${OPT_PAYLOAD}" == X ]; then
        usage "Invalid usage: must specify JSON payload"
    fi

    if [ X"${OPT_ENVIRONMENT}" == X ]; then
        usage "Invalid usage: must specify environment"
    elif [ ${OPT_ENVIRONMENT} == ${PUSH_ENVIRONMENT_DEVEL} ]; then
        PUSH_ENVIRONMENT=${OPT_ENVIRONMENT}
        PUSH_SERVER=${PUSH_SERVER_DEV}
    elif [ ${OPT_ENVIRONMENT} == ${PUSH_ENVIRONMENT_PROD} ]; then
        PUSH_ENVIRONMENT=${OPT_ENVIRONMENT}
        PUSH_SERVER=${PUSH_SERVER_PROD}
    else
        usage "Invalid usage: unknown environment ${OPT_ENVIRONMENT}"
    fi

    PUSH_TOPIC="${BUNDLE_ID}${PUSH_TOPIC_SUFFIX}"

    echo "TYPE=$OPT_PUSH_TYPE"
    echo "TOKEN=$OPT_DEVICE_TOKEN"
    echo "CERT=$OPT_CERT"
    echo "ENV=$OPT_ENVIRONMENT"
    echo "FLAVOR=$OPT_FLAVOUR"
    echo "PUSH_TOPIC=$PUSH_TOPIC"

    echo "PAYLOAD=${OPT_PAYLOAD}"

}

do_send()
{
    URL="https://${PUSH_SERVER}/3/device/${OPT_DEVICE_TOKEN}"
    APNSID=$(uuidgen)

    echo "URL=${URL}"


    curl -v \
      --cert ${OPT_CERT} \
      --http2 \
      --header "apns-push-type: ${PUSH_TYPE}" \
      --header "apns-id: ${APNSID}" \
      --header "apns-topic: ${PUSH_TOPIC}" \
      --header "content-type: application/json" \
      --header "apns-priority: 10" \
      --data "${OPT_PAYLOAD}" \
      "${URL}"
}

# main function
main()
{
    echo "Checking dependancies ..."
    check_depends

    # check arguments
    echo "Checking arguments ..."
    check_arguments

    echo "Building ..."
    do_send
}

# to debug
# set -x

#run the script
main

# to stop debug
# set +x

#restore current directory
cd "${CURRENT_DIR}"
