#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR="$(pwd)"

# set archive base dir
IPA_FILE=$1
RELEASE_NOTES_PATH=$2
DIST_LISTS=$3

# check arguments

# change current directory where scripts file is
cd "${SCRIPT_DIR}"

# include script files
source scripts/set_common_variables.sh
source scripts/update_functions.sh


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
    echo "Usage: `basename $0` <IPA_FILE> <RELEASE_NOTES_PATH> [DISTR_LISTS]"
    echo ""
    echo "Options:"
    echo "  <IPA_FILE>              specifies ipa file to be deployed"
    echo "  <RELEASE_NOTES_PATH>    path to the release notes file"
    echo "  [DISTR_LISTS]           comma separated list of distribution lists"
    echo "==================================================================================="

    #restore current directory
    cd "${CURRENT_DIR}"
    do_exit "Invalid Usage"
}

# check input arguments
check_arguments()
{

    if [ X"${IPA_FILE}" == X ]; then
        usage "Invalid usage"
    fi

    if [ X"${RELEASE_NOTES_PATH}" == X ]; then
        usage "Invalid usage"
    fi

    if [ ! -f "${IPA_FILE}" ]; then
        do_exit "IPA file <${IPA_FILE}> does not exist."
    fi

    if [ ! -f "${RELEASE_NOTES_PATH}" ]; then
        do_exit "File <${RELEASE_NOTES_PATH}> does not exist. It is used as release notes for the Crashlytics distribution"
    fi
}

# print script settings and variables
print_options()
{
    echo "IPA_FILE=${IPA_FILE}"
    echo "RELEASE_NOTES_PATH=${RELEASE_NOTES_PATH}"
    echo "DISTR_LISTS=${DISTR_LISTS}"
}

upload_to_crashlytics()
{
    echo "Uploading ..."
    local DISTRIBUTION_LISTS="${CL_DISTRIBUTION_LISTS}"

    if [ X"${DIST_LISTS}" != X"" ]; then
        DISTRIBUTION_LISTS="${DIST_LISTS}"
    fi

    ./depends/fabric_ios/Crashlytics.framework/submit ${CL_API_KEY} ${CL_BUILD_SECRET} \
        -ipaPath ${IPA_FILE} \
        -notesPath ${RELEASE_NOTES_PATH} \
        -groupAliases ${DISTRIBUTION_LISTS}

    check_failure "Error uploaing to testflight"
}

crashlytics()
{
    upload_to_crashlytics
}


# main function
main()
{
    # check arguments
    echo "Checking arguments ..."
    check_arguments

    # print options
    print_options

    crashlytics
}


#run the script
main

#restore current directory
cd "${CURRENT_DIR}"
