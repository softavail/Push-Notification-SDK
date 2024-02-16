#!/bin/bash

function usage {
  echo "A command-line interface for sending push notifications."
  echo ""
  echo "Usage: $0 -h"
  echo "Usage: $0 -d DEVICE_NAME [-a ALERT] [-u URL] [-p]"
  echo "  -h Print this help."
  echo "  -d Device name or token for which a token is selected"
  echo "     Supported device names are:"
  echo "         ANGEL, SE, ANGELI7"
  echo "  -a Optional alert string to be send with the push"
  echo "  -u Optional url to be send with the push"
  echo "  -p Use prod environment . Defaults to devel"
  exit 0
}

function send_push()
{
	local token=$1
	local environ=$2
	local key=$3
	local alert=$4

	echo "send_push ${token} ${key} ${environ}"

	./send_push_notification.sh -d "${token}" -c "${key}" -e "${environ}" -p "{\
	  \"aps\": {\
    	\"alert\": \"${alert}\",\
        \"mutable-content\": 1\
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

	echo "send_push_mutable ${token} ${key} ${environ}"

	./send_push_notification.sh -d "${token}" -c "${key}" -e "${environ}" -t "alert" -p "{\
	  \"aps\": {\
    	\"alert\": \"${alert}\",\
	    \"mutable-content\": 1\
	  },\
	  \"scgg-attachment-id\": \"${url}\"\
	}"

#	apn push "${token}" -c "$key" -e "$environ" -P "{\
#	  \"aps\": {\
#    	\"alert\": \"${alert}\",\
#	    \"mutable-content\": 1\
#	  },\
#	  \"scgg-attachment\": \"${url}\"\
#	}"
}

#default parameters
ANGEL="f3675eb15d650d85584c52ff93fe57ef16db9ff91cc8c187890d98142777ac71"
ANGELI7="ff99a88189d725c01396efb2700f2479475bee6613e3bd830cdc5cf1a29897cc"
SE="8fe1bdd7779083b0722c51faadb4ebe85abe18714b83fd7571faf99fea0a3b05"
RED="9eb5a3118791be307f362c8d86a570db82c59400ff4f6138c95513165523d781"
NELKO="e174d28c4e933907c1b3787f8f4d8bc29e3a4867c8a14da350cd78270942d012"

ALERT="Hello"
DEVICE=
TOKEN=""
URL=""
ENVIRON="devel"
KEY="APN_SCG_Push_Demo_Dev_Key.pem"
MUTABLE=0

# Parse arguments.
while getopts "hd:a:u:t:p" opt; do
  case "${opt}" in
    h) usage;;
    d) DEVICE="${OPTARG}";;
    a) ALERT="${OPTARG}";;
    u) URL="${OPTARG}";;
    t) TOKEN="${OPTARG}";;
    p) ENVIRON="prod";;
    *)
      usage
      exit 1
      ;;
  esac
done

if [ X"${DEVICE}" != X"" ]; then
	if [ X"${DEVICE}" == X"ANGEL" ]; then
		TOKEN="${ANGEL}"
	elif  [ X"${DEVICE}" == X"SE" ]; then
		TOKEN="${SE}"
	elif  [ X"${DEVICE}" == X"ANGELI7" ]; then
		TOKEN="${ANGELI7}"
	elif  [ X"${DEVICE}" == X"NELKO" ]; then
		TOKEN="${NELKO}"
	elif  [ X"${DEVICE}" == X"RED" ]; then
		TOKEN="${RED}"
	else
		TOKEN="${DEVICE}"
	fi
fi

if [ X"${ENVIRON}" == X"prod" ]; then
	KEY="APN_SCG_Push_Demo_Key.pem"
fi

if [ X"${URL}" == X"" ]; then
	echo "Sending regular push with alert"
	send_push "${TOKEN}" "${ENVIRON}" "${KEY}" "${ALERT}"
else
	echo "Sending mutable push with alert"
	send_push_mutable "${TOKEN}" "${ENVIRON}" "${KEY}" "${ALERT}" "${URL}"
fi
