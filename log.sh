#!/usr/bin/bash

######################################################
#
# File Name:	log.sh
#
# Function:		通用日志模块，提供日志打印，邮件发送等功能
#
# Usage:		source log	
#
# Input:		none
#
# Output:		none
#
# Author:		panwenhai
#
# Create Time:    2016-07-01 16:04:14
#
######################################################

# 日志配置
LOG_PATH=$WORK_PATH/log
LOG_DEBUG=$LOG_PATH/${PROG_NAME}.${TODAY}.log
LOG_WARN=$LOG_PATH/${PROG_NAME}.${TODAY}.log.wf
LOG_FATAL=$LOG_PATH/${PROG_NAME}.${TODAY}.log.wf
MAIL_TO="panwenhai@100tal.com"

# 建立日志目录
if [ ! -d $LOG_PATH ]; then
	mkdir -p $LOG_PATH
fi

# 日志、邮件函数
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

function Send_Debug_Mail ()
{
        tail $LOG_DEBUG | mail -s "$(echo -e "$PROG_NAME debug \nContent-Type: text/html")" ${MAIL_TO}
        return $OK
}

function Send_Fatal_Mail ()
{
        tail $LOG_FATAL | mail -s "$(echo -e "$PROG_NAME error!\nContent-Type: text/html")" ${MAIL_TO}
        return $OK
}

