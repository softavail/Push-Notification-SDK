#!/bin/bash

function usage {
  echo "A command-line interface for sending push notifications."
  echo ""
  echo "Usage: $0 -h"
  echo "Usage: $0 -d DEVICE_NAME [-a ALERT] [-u URL] [-s]"
  echo "  -h Print this help."
  echo "  -d Device name or token for which a token is selected"
  echo "     Supported device names are:"
  echo "         ANGEL, SLAV, ANGELPAD"
  echo "  -a Optional alert string to be send with the push"
  echo "  -u Optional url to be send with the push"
  echo "  -s Use sandbox environment. Defaults to production"
  exit 0
}

function send_push()
{
	local token=$1
	local environ=$2
	local key=$3
	local alert=$4

	apn push "${token}" -c "$key" -e "$environ" -P "{\
	  \"aps\": {\
    	\"alert\": \"${alert}\"\
	  }\
	}"
}

function send_push_mutable()
{
	local token=$1
	local environ=$2
	local key=$3
	local alert=$4
	local url=$5

	apn push "${token}" -c "$key" -e "$environ" -P "{\
	  \"aps\": {\
    	\"alert\": \"${alert}\",\
	    \"mutable-content\": 1\
	  },\
	  \"scgg-attachment\": \"${url}\"\
	}"
}

#default parameters
ANGEL="a82bd62c5be35d6dd1bbdd373c4ecb814f8db8e7f2af7a183ddafff2193f1964"
SLAV="38060159fe3e0be0deff841dba033299bd654afe58b0ab567993f61b0750126c"
ANGELPAD="bb154fa17923e56040c6d09259de4c48261a698cada0094f0250f8826408324e"
ALERT="Hello"
DEVICE=
TOKEN=""
URL=""
ENVIRON="production"
KEY="APN_SCG_Push_Demo_Dev_Key.pem"
MUTABLE=0

# Parse arguments.
while getopts "hd:a:u:t:e:" opt; do
  case "${opt}" in
    h) usage;;
    d) DEVICE="${OPTARG}";;
    a) ALERT="${OPTARG}";;
    u) URL="${OPTARG}";;
    t) TOKEN="${OPTARG}";;
    s) ENVIRON="development";;
    *)
      usage
      exit 1
      ;;
  esac
done

if [ X"${DEVICE}" != X"" ]; then
	if [ X"${DEVICE}" == X"ANGEL" ]; then
		TOKEN="${ANGEL}"
	elif  [ X"${DEVICE}" == X"SLAV" ]; then
		TOKEN="${SLAV}"
	elif  [ X"${DEVICE}" == X"ANGELPAD" ]; then
		TOKEN="${ANGELPAD}"
	else
		TOKEN="${DEVICE}"
	fi
fi

if [ X"${ENVIRON}" == X"production" ]; then
	KEY="APN_SCG_Push_Demo_Key.pem"
fi

if [ X"${URL}" == X"" ]; then
	echo "Sending regular push with alert"
	send_push "${TOKEN}" "${ENVIRON}" "${KEY}" "${ALERT}"
else
	echo "Sending mutable push with alert"
	send_push_mutable "${TOKEN}" "${ENVIRON}" "${KEY}" "${ALERT}" "${URL}"
fi
