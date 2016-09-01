#!/usr/bin/bash

######################################################
#
# File Name:	example.sh
#
# Function:		使用样例程序
#
# Usage:		bash ./example.sh
#
# Input:		none
#
# Output:		none
#
# Author:		panwenhai
#
# Create Time:    2016-07-01 16:07:44
#
######################################################

source globals.sh
source log.sh

echo "WORK_PATH=${WORK_PATH}"
echo "PROG_NAME=${PROG_NAME}"
echo "TODAY=${TODAY}"

# log config
echo "LOG_PATH=${LOG_PATH}"
echo "LOG_DEBUG=${LOG_DEBUG}"
echo "LOG_WARN=${LOG_WARN}"
echo "LOG_FATAL=${LOG_FATAL}"

function init ()
{
	return $OK
}

function get_data ()
{
	return $OK
}

function store_result ()
{
	return $OK
}

function main ()
{
  if init
  then
    Write_Log_Debug "[main]: init success."
  else
    Write_Log_Fatal "[main]: init failed."
    Send_Fatal_Mail
    return $ERR
  fi

  if get_data $LAST_DAY
  then
    Write_Log_Debug "[main]: get_data success: $LAST_DAY"
  else
    Write_Log_Fatal "[main]: get_data failed: $LAST_DAY"
    Send_Fatal_Mail
    return $ERR
  fi

  if store_result
  then
    Write_Log_Debug "[main]: store_result success: $LAST_DAY"
  else
    Write_Log_Fatal "[main]: store_result failed: $LAST_DAY"
    Send_Fatal_Mail
    return $ERR
  fi
}

main $@

