#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR="$(pwd)"

# change current directory where scripts file is
cd "${SCRIPT_DIR}"

ARCHIVE_PATH=$1
OUT_DIR=$2
REVISION_NUMBER=$3

if [ X"${REVISION_NUMBER}" == X"" ]; then
    REVISION_NUMBER=$(git rev-list HEAD | wc -l | tr -d ' ')
fi

IPA_FILE_ADHOC="${OUT_DIR}/demo-adhoc-$REVISION_NUMBER.ipa"

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
    echo "Usage: `basename $0` <XCARCHIVE> <OUT_DIR> [REVNUM]"
    echo ""
    echo "Options:"
    echo "  <XCARCHIVE> Specifies path to the xcarchive file to be exported"
    echo "  <OUT_DIR>   Output folder where the ipa file will be placed"
    echo "  [REVNUM]    Revision number to be assigned to the build number"
    echo "              If not specified wiill be computed form git rev number"
    echo "==================================================================================="

    #restore current directory
    cd "${CURRENT_DIR}"
    do_exit "Invalid Usage"
}

# check input arguments
check_arguments()
{
    if [ X"${ARCHIVE_PATH}" == X"" ]; then
        usage "Invalid usage"
    fi

    if [ X"${OUT_DIR}" == X"" ]; then
        usage "Invalid usage"
    fi

    if [ ! -d "${OUT_DIR}" ]; then
        do_exit "OUT_DIR <${OUT_DIR}> does not exist."
    fi

    if [ ! -d "${ARCHIVE_PATH}" ]; then
        do_exit "Archive <${ARCHIVE_PATH}> does not exist."
    fi
}


# exports archive
# param 1 method appstore or adhoc
# param 2 optionsplist file
# param 3 final exported ipa file
export_archive()
{
    local EXPORT_PATH="${OUT_DIR}/$1"
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

create_ipa_files()
{
    export_archive "adhoc" "exportOptionsAdHoc.plist" "${IPA_FILE_ADHOC}"
}

# main function
main()
{
    # check arguments
    check_arguments

    # clean up
    create_ipa_files
}

#run the script
main

#restore current directory
cd "${CURRENT_DIR}"
