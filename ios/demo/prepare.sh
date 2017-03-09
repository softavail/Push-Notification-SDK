#!/bin/bash


DEPENDENCIES_DIR_NAME="depends"

SCRIPT_DIR_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR_PATH="$(pwd)"

cd "$SCRIPT_DIR_PATH"

source ../scripts/update_functions.sh

BASE_URL="https://subversion.partners1993.com/scg/bin"
TEMP_DIR_NAME=".temp"
TEMP_DIR="$(pwd)/.temp"

CLEAN=$1

fabric_ar="fabric_ios_2.tar.gz"
fabric_dst="fabric_ios"
fabric_cfg=$(cat "$DEPENDENCIES_DIR_NAME/fabric.cfg")

clean()
{
    removeDir "$DEPENDENCIES_DIR_NAME/$fabric_dst"
}

provision_fabric()
{
    echo "Provisioning Fabric .."

    if [ X$fabric_cfg != X$fabric_ar ]; then
        fabric_cfg=$fabric_ar
        removeDir "$DEPENDENCIES_DIR_NAME/$fabric_dst"
    fi

    provision "$BASE_URL" "$fabric_ar" "$DEPENDENCIES_DIR_NAME" "$fabric_dst"
    echo $fabric_ar > "$DEPENDENCIES_DIR_NAME/fabric.cfg"
}

main()
{
    createDirIfMissing "$DEPENDENCIES_DIR_NAME"

    if [ X$CLEAN == X"clean" ]; then
        clean
    fi

    provisionDir $TEMP_DIR_NAME

    provision_fabric
}

main

cd "$CURRENT_DIR_PATH"
