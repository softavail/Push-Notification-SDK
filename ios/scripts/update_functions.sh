#!/bin/bash

clean()
{
    dir_to_be_cleaned=$1
    rm -rf $1
}

downloadFile()
{
    FILE_SRC_URL=$1
    FILE_DEST_NAME=$2

    curl -L -k -o $FILE_DEST_NAME $FILE_SRC_URL
}

provisionDir()
{
    DIR_NAME=$1

    rm -rf $DIR_NAME
    mkdir $DIR_NAME
}

removeDir()
{
    DIR_NAME=$1

    rm -rf $DIR_NAME
}

directoryExists()
{
    DIRECTORY_NAME=$1

    directoryExists=""

    if [ -d "$DIRECTORY_NAME" ]; then
        directoryExists="true"
    else
        directoryExists="false"
    fi

    echo $directoryExists
}

isDirEmpty()
{
    DIRECTORY_NAME=$1

    directoryIsEmpty=""

    if [ "$(ls -A $DIRECTORY_NAME)" ]; then
        directoryIsEmpty="false"
    else
        directoryIsEmpty="true"
    fi

    echo "$directoryIsEmpty"
}

untarFile()
{
    TAR_GZ_FILE=$1
    DEST_DIR_NAME=$2

    tar -zxvf $TAR_GZ_FILE -C $DEST_DIR_NAME
}

update()
{
    FILE_SRC_DIR_URL=$1
    FILE_NAME=$2
    DEST_DIR=$3

    FILE_SRC_URL="$FILE_SRC_DIR_URL/$FILE_NAME"
    DOWNLOAD_FILE_NAME="$TEMP_DIR_NAME/$FILE_NAME"

    downloadFile $FILE_SRC_URL $DOWNLOAD_FILE_NAME

    FILE_DEST_NAME="$FILE_DEST_DIR/$FILE_NAME"
    untarFile $DOWNLOAD_FILE_NAME $DEST_DIR
}

provision()
{
    FILE_SRC_DIR_URL=$1
    FILE_NAME=$2
    DEST_DIR=$3
    TAR_ROOT_DIR_NAME=$4

    DEST_ROOT_DIR_NAME="$DEST_DIR/$TAR_ROOT_DIR_NAME"

    retval=$( directoryExists "$DEST_ROOT_DIR_NAME" )

    if [ $retval == "false" ]; then
        provisionDir "$DEST_ROOT_DIR_NAME"
    fi

    retval=$( isDirEmpty "$DEST_ROOT_DIR_NAME" )

    if [ $retval == "true" ]; then
        update $FILE_SRC_DIR_URL $FILE_NAME $DEST_DIR
    fi
}

createDirIfMissing()
{
    DIR_NAME=$1

    retval=$( directoryExists "$DIR_NAME" )

    if [ $retval == "false" ]; then
        provisionDir "$DIR_NAME"
    fi
}
