#!/bin/bash

######################################################
#
# File Name:  common.sh
#
# Function:  some common definitions for most shell scripts 
#
# Usage:  source common.sh
#
# Author: panwenhai
#
# Create Time:    2016-06-22 14:40:44
#
######################################################

# return values
OK=0
ERR=1

# global definitions
WORK_PATH=$(cd "$(dirname "$0")"; pwd)
PROG_NAME=$(basename "$0")
TODAY=`date +%Y%m%d`

# log config
LOG_PATH=$WORK_PATH/log
LOG_DEBUG=$LOG_PATH/${PROG_NAME}.${TODAY}.log
LOG_WARN=$LOG_PATH/${PROG_NAME}.${TODAY}.log.wf
LOG_FATAL=$LOG_PATH/${PROG_NAME}.${TODAY}.log.wf

# create log director if necessary
if [ ! -d $LOG_PATH ]; then
	mkdir -p $LOG_PATH
fi

# log functions
function Write_Log_Debug ()
{
	time_day=`date +%m-%d`
	time_hms=`date +%T`
	echo "DEBUG: $time_day $time_hms $@" >> $LOG_DEBUG;
	return $OK
}

function Write_Log_Warn ()
{
	time_day=`date +%m-%d`
	time_hms=`date +%T`
	echo "WARNING: $time_day $time_hms $@" >> $LOG_WARN;
	return $OK
}

function Write_Log_Fatal ()
{
	time_day=`date +%m-%d`
	time_hms=`date +%T`
	echo "FATAL: $time_day $time_hms $@" >> $LOG_FATAL;
	return $OK
}

# add your global definitions here:


