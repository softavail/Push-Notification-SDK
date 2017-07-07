#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR="$(pwd)"

OPT_DST_DIR=
OPT_REVNUM=

while getopts ":d:v:" opt; do
case $opt in
    d)
        OPT_DST_DIR="$OPTARG"
        ;;
    v)
        OPT_REVNUM="$OPTARG"
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

# include script files
source scripts/set_common_variables.sh
source scripts/update_functions.sh

REVISION_NUMBER=

if [ X"${OPT_REVNUM}" != X"" ]; then
    REVISION_NUMBER="${OPT_REVNUM}"
else
    REVISION_NUMBER=$(git rev-list HEAD | wc -l | tr -d ' ')
fi


PRODUCT_NAME="SCGPushSDK"
FRAMEWORK_NAME="${PRODUCT_NAME}.framework"
DSYM_NAME="${FRAMEWORK_NAME}.dSYM"

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
    echo "Usage: `basename $0` -d <DST_DIR> -v REVISION"
    echo ""
    echo "Options:"
    echo "  -d ARG             : specifies base directory where framework will be installed"
    echo "  -v REVISION        : gets revision form command line"
    echo "==================================================================================="

    #restore current directory
    cd "${CURRENT_DIR}"
    do_exit "$1"
}

check_system()
{
	echo "checking mobileprovision-read ..."
	
	local MOBILEPROVISION_READ=($(which mobileprovision-read))
	if [  X"${MOBILEPROVISION_READ}" == X"" ]; then
		local MBR_URL="https://github.com/0xc010d/mobileprovision-read"
		do_exit "mobileprovision-read tool is not installed. Read more at: ${MBR_URL}"
	fi
}

# check input arguments
check_arguments()
{
    if [ X"${OPT_DST_DIR}" == X ]; then
        usage "Invalid usage: -d option is missing"
    fi
}

check_integrity()
{
    if [ X"${REVISION_NUMBER}" == X ]; then
        do_exit "This script must be executed from a directory which is under version control"
    fi

    if [ ! -d "${OPT_DST_DIR}" ]; then
        do_exit "Directory <${OPT_DST_DIR}> does not exist"
    fi
}

# print script settings and variables
print_options()
{
    echo "TEMP_DIR=${TEMP_DIR}"
    echo "REVISION_NUMBER=${REVISION_NUMBER}"
    echo "DST_DIR=${OPT_DST_DIR}"
}

prepare()
{
    provisionDir "${TEMP_DIR}"
}

# build sources and make archive
build_install()
{
    echo "Building ${PRODUCT_NAME} ... "

    xcodebuild -workspace ios.xcworkspace -scheme SCGPushSDK -configuration Release -jobs 8 clean install DSTROOT="${OPT_DST_DIR}" CONFIGURATION_BUILD_DIR="${OPT_DST_DIR}" REVISION_NUMBER=${REVISION_NUMBER} SKIP_INSTALL=NO
    check_failure "Error building: ${PRODUCT_NAME}"

    # compress framework
    #zip -qr "${OPT_DST_DIR}/${FRAMEWORK_NAME}-${REVISION_NUMBER}.zip" "${OPT_DST_DIR}/${FRAMEWORK_NAME}"
    #rm -rf "${OPT_DST_DIR}/${FRAMEWORK_NAME}"

    # compress dSYM
    zip -qr "${OPT_DST_DIR}/${FRAMEWORK_NAME}-${REVISION_NUMBER}.dSYM.zip" "${OPT_DST_DIR}/${FRAMEWORK_NAME}.dSYM"
    rm -rf "${OPT_DST_DIR}/${FRAMEWORK_NAME}.dSYM"
}

cleanup()
{
    removeDir "${TEMP_DIR}"
}

# main function
main()
{
	check_system
	
    # check arguments
    echo "Checking arguments ..."
    check_arguments

    # check integrity before a build
    echo "Checking integrity ..."
    check_integrity

    # print options
    echo "Print options ..."
    print_options

    # prepare
    echo "Preparing ..."
    prepare

    # build sources and make archive
    build_install

    # clean up
    cleanup
}


#run the script
main

#restore current directory
cd "${CURRENT_DIR}"
