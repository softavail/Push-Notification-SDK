#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR="$(pwd)"

# change current directory where scripts file is
cd "${SCRIPT_DIR}"

REVISION_NUMBER=93
ARCHIVE_PATH="${SCRIPT_DIR}/demo.xcarchive"
IPA_FILE_ADHOC="${SCRIPT_DIR}/demo-adhoc-$REVISION_NUMBER.ipa"

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

create_ipa_files()
{
    export_archive "adhoc" "exportOptionsAdHoc.plist" "${IPA_FILE_ADHOC}"
}

# main function
main()
{
    # clean up
    create_ipa_files
}

#run the script
main

#restore current directory
cd "${CURRENT_DIR}"
