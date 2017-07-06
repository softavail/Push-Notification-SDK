#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR="$(pwd)"

# set archive base dir
OPT_SCHEME="SCGPushDemo"
OPT_STRIPREVNUMDIR_FLAG=0

OPT_ARCHIVE_BASE_DIR=
OPT_REVNUM=
OPT_METHOD="adhoc"

while getopts ":m:a:v:n" opt; do
case $opt in
    m)
        OPT_METHOD="$OPTARG"
        ;;
    a)
        OPT_ARCHIVE_BASE_DIR="$OPTARG"
        ;;
    n)
        OPT_STRIPREVNUMDIR_FLAG=1
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

ARCHIVE_INTERMEDIATE_PATH=
ARCHIVE_PATH=
APP_FILE=
IPA_FILE=
IPA_FILE_ADHOC=
IPA_FILE_APPSTORE=
DSYM_FILE=
CL_RELEASE_NOTES="notes.txt"
PRODUCT_NAME="SCGPushDemo"
ADHOC_MOBILEPROVISION_NAME="SCGPushDemoAdHoc.mobileprovision"
APPSTORE_MOBILEPROVISION_NAME="SCGPushDemoAppStore.mobileprovision"
EXPORT_ADHOC_FLAG=0
EXPORT_APPSTORE_FLAG=0

TEMP_DIR="$(pwd)/.temp"

# application
APP_NAME="SCGPushDemo"
DSYM_NAME="${APP_NAME}.app.dSYM"

XCODE_EXPORT_FORMAT="ipa"

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
    echo "Usage: `basename $0` -a <ARCHIVE_PATH> -v REVISION [-m <METHOD>] [-n]"
    echo ""
    echo "Options:"
    echo "  -m METHOD          : Describes how to export the archive. Available options: "
    echo "                         adhoc, appstore, both. Defaults to adhoc"
    echo "  -a ARG             : specifies base directory where archive will be placed"
    echo "  -v REVISION        : gets revision form command line"
    echo "  -n                 : do not append REVNUM to the end of <ARCHIVE_PATH>"
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
    if [ X"${OPT_ARCHIVE_BASE_DIR}" == X ]; then
        usage "Invalid usage: -a option is missing"
    fi

	if [ X"${OPT_METHOD}" == X"both" ]; then
		EXPORT_ADHOC_FLAG=1
		EXPORT_APPSTORE_FLAG=1
	elif [ X"${OPT_METHOD}" == X"adhoc" ]; then
		EXPORT_ADHOC_FLAG=1
		EXPORT_APPSTORE_FLAG=0
	elif [ X"${OPT_METHOD}" == X"appstore" ]; then
		EXPORT_ADHOC_FLAG=0
		EXPORT_APPSTORE_FLAG=1
	else
		usage "Unknown method: ${OPT_METHOD}"
	fi

    if [ ${OPT_STRIPREVNUMDIR_FLAG} == 1 ]; then
        ARCHIVE_INTERMEDIATE_PATH="${OPT_ARCHIVE_BASE_DIR}"
    else
        ARCHIVE_INTERMEDIATE_PATH="${OPT_ARCHIVE_BASE_DIR}/${REVISION_NUMBER}"
    fi

    ARCHIVE_PATH="${ARCHIVE_INTERMEDIATE_PATH}/${PRODUCT_NAME}.xcarchive"
    APP_FILE="${ARCHIVE_PATH}/Products/Applications/${PRODUCT_NAME}.app"
    IPA_FILE="${ARCHIVE_INTERMEDIATE_PATH}/${PRODUCT_NAME}-$REVISION_NUMBER.${XCODE_EXPORT_FORMAT}"
    IPA_FILE_ADHOC="${ARCHIVE_INTERMEDIATE_PATH}/${PRODUCT_NAME}-adhoc-$REVISION_NUMBER.${XCODE_EXPORT_FORMAT}"
    IPA_FILE_APPSTORE="${ARCHIVE_INTERMEDIATE_PATH}/${PRODUCT_NAME}-appstore-$REVISION_NUMBER.${XCODE_EXPORT_FORMAT}"
    DSYM_FILE="${TEMP_DIR}/${PRODUCT_NAME}.app.dSYM.zip"
}

check_integrity()
{
    local PROJECT_WROKSPACE="ios.xcworkspace"
    if [ ! -d "${PROJECT_WROKSPACE}" ]; then
        do_exit "Project workspace '${PROJECT_WROKSPACE}' is missing."
    fi

    if [ X"${REVISION_NUMBER}" == X ]; then
        do_exit "This script must be executed from a directory which is under version control"
    fi

    if [ ! -d "${OPT_ARCHIVE_BASE_DIR}" ]; then
        do_exit "Directory <${OPT_ARCHIVE_BASE_DIR}> does not exist"
    fi
}

# print script settings and variables
print_options()
{
    echo "TEMP_DIR=${TEMP_DIR}"
    echo "REVISION_NUMBER=${REVISION_NUMBER}"
    echo "ARCHIVE_PATH=${ARCHIVE_PATH}"
    echo "IPA_FILE=${IPA_FILE}"
    echo "IPA_FILE_ADHOC=${IPA_FILE_ADHOC}"
    echo "IPA_FILE_APPSTORE=${IPA_FILE_APPSTORE}"
    echo "DSYM_FILE=${DSYM_FILE}"
}

updateProvisioningProfileById()
{
    echo "Checking prov profile '$1' ..."

    local PROV_PROF_NAME=$1
    local DEST_PROV="${HOME}/Library/MobileDevice/Provisioning Profiles"
    local SRC_PROV_PROF="${SCRIPT_DIR}/${PROV_PROF_NAME}"
    local PROV_PROFILE_UUID=($(mobileprovision-read -f ${SRC_PROV_PROF} -o UUID))
    local PROV_PROFILE_NAME=($(mobileprovision-read -f ${SRC_PROV_PROF} -o Name))
    local DEST_PROV_PROF="${DEST_PROV}/${PROV_PROFILE_UUID}.mobileprovision"
    local DEST_FILES="${DEST_PROV}/*.mobileprovision"

    #echo "PROV_PROF_NAME=${PROV_PROF_NAME}"
    #echo "SRC_PROV_PROF=${SRC_PROV_PROF}"
    #echo "DEST_PROV_PROF=${DEST_PROV_PROF}"
    #echo "DEST_FILES=${DEST_FILES}"

    OLDIFS="$IFS"  # save it
    IFS="" # don't split on any white space

    for f in ${DEST_FILES}
    do
        #echo "Processing $f file ..."

        # take action on each file. $f store current file name
        local PROF_UDID=($(mobileprovision-read -f $f -o UUID))
        local PROF_NAME=($(mobileprovision-read -f $f -o Name))
        #echo "PROF_NAME: $PROF_NAME"
        #echo "PROF_UUID: $PROF_UDID"

        if [ $PROF_NAME == $PROV_PROFILE_NAME ]; then
            if [ $PROV_PROFILE_UUID != $PROF_UDID ]; then
                echo "!!!!! DELETE ${f}"
                rm ${f}
            fi
        fi

    done

    IFS=$OLDIFS # restore IFS

    if [ ! -e "${DEST_PROV_PROF}" ]; then
        echo "Copying ${DEST_PROV_PROF} ..."
        cp "${SRC_PROV_PROF}" "${DEST_PROV_PROF}"
    else
        local md5_src=($(md5 -q "${SRC_PROV_PROF}"))
        local md5_dst=($(md5 -q "${DEST_PROV_PROF}"))
        #echo "md5_src=$md5_src"
        #echo "md5_dst=$md5_dst"
        if [ $md5_src != $md5_dst ]; then
            echo "Updating ${DEST_PROV_PROF} ..."
            cp "${SRC_PROV_PROF}" "${DEST_PROV_PROF}"
        fi
    fi

}

prepare()
{
    provisionDir "${TEMP_DIR}"

    updateProvisioningProfileById $ADHOC_MOBILEPROVISION_NAME
    updateProvisioningProfileById $APPSTORE_MOBILEPROVISION_NAME
}

# build sources and make archive
build_archive()
{
    echo "Building ${OPT_SCHEME} ... "
    createDirIfMissing "${ARCHIVE_INTERMEDIATE_PATH}"

    xcodebuild -workspace ios.xcworkspace -scheme "${OPT_SCHEME}" -configuration "Release" archive -archivePath "${ARCHIVE_PATH}" -jobs 8 REVISION_NUMBER=${REVISION_NUMBER}
    check_failure "Error archiving project: ${OPT_SCHEME}"

	if [ ${EXPORT_ADHOC_FLAG} == 1 ]; then
		export_archive "adhoc" "${SCRIPT_DIR}/demo/exportOptionsAdHoc.plist" "${IPA_FILE_ADHOC}"
    fi

	if [ ${EXPORT_APPSTORE_FLAG} == 1 ]; then
		export_archive "appstore" "${SCRIPT_DIR}/demo/exportOptionsAppStore.plist" "${IPA_FILE_APPSTORE}"
    fi

    # zip xcode archive
    zip -qr "${ARCHIVE_PATH}-$REVISION_NUMBER.zip" "${ARCHIVE_PATH}"
    check_failure "Error archiving ${ARCHIVE_PATH}"

    echo "Removing archive ..."
    rm -rf "${ARCHIVE_PATH}"
}

# exports archive
# param 1 method appstore or adhoc
# param 2 optionsplist file
# param 3 final exported ipa file
export_archive()
{
	local EXPORT_PATH="${ARCHIVE_PATH}/$1"
	local EXPORT_OPTIONS_PLIST="${2}"
	local EXPORTED_IPA_FILE="${3}"
	
    xcodebuild  -exportArchive \
                -archivePath "${ARCHIVE_PATH}" \
                -exportPath "${EXPORT_PATH}" \
                -exportOptionsPlist "${EXPORT_OPTIONS_PLIST}"
                
	check_failure "Error exporting: ${ARCHIVE_PATH} for $1"

	local IPA_FILES="${EXPORT_PATH}/*.ipa"
	
	for f in ${IPA_FILES}
	do
		mv ${f} ${EXPORTED_IPA_FILE}
	done

	rm -rf ${EXPORT_PATH}
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
    build_archive

    # clean up
    cleanup
}


#run the script
main

#restore current directory
cd "${CURRENT_DIR}"
