#!/bin/bash

function usage {
  echo "A command-line interface for sending push notifications."
  echo ""
  echo "Usage: $0 -h"
  echo "Usage: $0 -d DEVICE_NAME [-a ALERT] [-u URL]"
  echo "  -h Print this help."
  echo "  -d Device name for which a token is selected"
  echo "     Supported device names are:"
  echo "         ANGEL, SLAV"
  echo "  -a Optional alert string to be send with the push"
  echo "  -u Optional url to be send with the push"
  exit 0
}

function send_push()
{
	local token=$1
	local alert=$2
	local url=$3

	apn push "${token}" -c CSG_Demo_APNS_Devel_Key.pem -P "{\
	  \"aps\": {\
    	\"alert\": \"${alert}\",\
	    \"mutable-content\": 1\
	  },\
	  \"scgg-attachment\": \"${url}\"\
	}"
}

#default parameters
ANGEL="608ac7bfcc3c3ae61dac339665e1cc8a12e310bb1df843aff237cf1e34c95d27"
SLAV="b260b947b8388bd964fe22afd3fc23ca6fb2581a64ae6108d387eff573808a7b"
ALERT="Hello"
DEVICE=
TOKEN=
URL="http://auto.ferrari.com/en_EN/wp-content/uploads/sites/5/2016/09/ferrari-70anni-home.jpg"

# Parse arguments.
while getopts "hd:a:u:" opt; do
  case "${opt}" in
    h) usage;;
    d) DEVICE="${OPTARG}";;
    a) ALERT="${OPTARG}";;
    u) URL="${OPTARG}";;
    *)
      usage
      exit 1
      ;;
  esac
done

if [ X"${DEVICE}" == X"ANGEL" ]; then
	TOKEN="${ANGEL}"
elif  [ X"${DEVICE}" == X"SLAV" ]; then
	TOKEN="${SLAV}"
else
	echo "Unsupported device name: ${DEVICE}" 
	usage
	exit 1
fi

send_push "${TOKEN}" "${ALERT}" "${URL}"
