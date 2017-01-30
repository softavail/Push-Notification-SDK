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
	local environ=$4
	local key=$5
	local mutable=$6

	apn push "${token}" -c "$key" -e "$environ" -P "{\
	  \"aps\": {\
    	\"alert\": \"${alert}\",\
	    \"mutable-content\": $mutable\
	  },\
	  \"scgg-attachment\": \"${url}\"\
	}"
}

#default parameters
ANGEL="608ac7bfcc3c3ae61dac339665e1cc8a12e310bb1df843aff237cf1e34c95d27"
SLAV="38060159fe3e0be0deff841dba033299bd654afe58b0ab567993f61b0750126c"
ANGELPAD="bb154fa17923e56040c6d09259de4c48261a698cada0094f0250f8826408324e"
ALERT="Hello"
DEVICE=
TOKEN=""
URL="http://auto.ferrari.com/en_EN/wp-content/uploads/sites/5/2016/09/ferrari-70anni-home.jpg"
ENVIRON="development"
KEY="CSG_Demo_APNS_Devel_Key.pem"
MUTABLE=1

# Parse arguments.
while getopts "hd:a:u:t:e:m" opt; do
  case "${opt}" in
    h) usage;;
    m) MUTABLE=0;;
    d) DEVICE="${OPTARG}";;
    a) ALERT="${OPTARG}";;
    u) URL="${OPTARG}";;
    t) TOKEN="${OPTARG}";;
    e) ENVIRON="${OPTARG}";;
    *)
      usage
      exit 1
      ;;
  esac
done

if [ X"${DEVICE}" != "" ]; then
if [ X"${DEVICE}" == X"ANGEL" ]; then
TOKEN="${ANGEL}"
elif  [ X"${DEVICE}" == X"SLAV" ]; then
TOKEN="${SLAV}"
elif  [ X"${DEVICE}" == X"ANGELPAD" ]; then
TOKEN="${ANGELPAD}"
else
echo "Unsupported device name: ${DEVICE}"
usage
exit 1
fi
fi

if [ X"${ENVIRON}" == X"production" ]; then
	KEY="CSG_Demo_APNS_Key.pem"
fi


send_push "${TOKEN}" "${ALERT}" "${URL}" "${ENVIRON}" "${KEY}" $MUTABLE
