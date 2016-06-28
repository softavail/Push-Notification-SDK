#!/bin/bash


DEPENDENCIES_DIR_NAME="depends"

SCRIPT_DIR_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR_PATH="$(pwd)"

cd "$SCRIPT_DIR_PATH"

source scripts/set_common_variables.sh
source scripts/update_functions.sh

CLEAN=$1

poco_ar="poco_ios_1.tar.gz"
poco_dst="poco_ios"
poco_cfg=$(cat "$DEPENDENCIES_DIR_NAME/poco.cfg")

#openssl_ar="openssl_ios_1.tar.gz"
#openssl_dst="openssl_ios"
#openssl_cfg=$(cat "$DEPENDENCIES_DIR_NAME/openssl.cfg")

#fabric_ar="fabric_ios_1.tar.gz"
#fabric_dst="fabric_ios"
#fabric_cfg=$(cat "$DEPENDENCIES_DIR_NAME/fabric.cfg")

clean()
{
    #removeDir "$DEPENDENCIES_DIR_NAME/$openssl_dst"
    removeDir "$DEPENDENCIES_DIR_NAME/$poco_dst"
    #removeDir "$DEPENDENCIES_DIR_NAME/$fabric_dst"
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

provision_poco()
{
    echo "Provisioning POCO .."

    if [ X$poco_cfg != X$poco_ar ]; then
        poco_cfg=$poco_ar
        removeDir "$DEPENDENCIES_DIR_NAME/$poco_dst"
    fi

    provision "$BASE_URL" "$poco_ar" "$DEPENDENCIES_DIR_NAME" "$poco_dst"
    echo $poco_ar > "$DEPENDENCIES_DIR_NAME/poco.cfg"
}

provision_openssl()
{
    echo "Provisioning openssl .."

    if [ X$openssl_cfg != X$openssl_ar ]; then
        openssl_cfg=$openssl_ar
        removeDir "$DEPENDENCIES_DIR_NAME/$openssl_dst"
    fi

    provision "$BASE_URL" "$openssl_ar" "$DEPENDENCIES_DIR_NAME" "$openssl_dst"
    echo $openssl_ar > "$DEPENDENCIES_DIR_NAME/openssl.cfg"
}

main()
{
    createDirIfMissing "$DEPENDENCIES_DIR_NAME"

    if [ X$CLEAN == X"clean" ]; then
        clean
    fi

    provisionDir $TEMP_DIR_NAME

    #provision_fabric
    provision_poco
    #provision_openssl
}


main

cd "$CURRENT_DIR_PATH"
