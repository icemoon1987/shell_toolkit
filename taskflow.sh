#!/usr/bin/bash

######################################################
#
# File Name:	taskflow.sh
#
# Function:		流程控制模块，通过配置文件，控制多个任务的运行。支持自动重试、错误忽略、发送邮件等功能。
#
# Usage:		source taskflow.sh，依赖于globals.sh, log.sh
#
# Input:		任务列表文件结构：任务执行目录 任务执行命令（命令中可包含空格），每个任务一行
#
# Output:		none
#
# Author: panwenhai
#
# Create Time:    2016-07-01 16:18:10
#
######################################################

source ./globals.sh
source ./log.sh

# TODO: 并行化任务执行

# 是否在一个任务执行失败后停止整个流程，0不停止，1停止
EXIT_ON_ERROR=0

# 是否发送失败状态邮件
SEND_EMAIL=1

# 最大重试次数
MAX_RETRY_NUM=3

# 重试之间等待的时间，单位：秒
RETRY_GAP=5

# 任务执行之间的等待时间，单位：秒
TASK_GAP=0


######################################################
#
# Function:   执行任务函数，执行一个任务
#
# Params:
#			TASK_DIR: 任务执行目录，在执行命令前，会先cd到这个目录中
#			TASK_CMD: 任务执行命令，命令中可以包含空格
#
# Return:   $OK, $ERR
#
######################################################
function Run_Task ()
{
	local task_dir=$1
	local task_cmd=""

	# 如果任务执行目录不存在，直接返回错误
	if [ ! -d $task_dir ]; then
		return $ERR
	fi
	
	# 解析任务执行命令，第一个参数为任务执行目录，其余参数组合成任务执行命令
	i=0
	for arg in $@; do
		if [ $i -ne 0 ]; then
			task_cmd=${task_cmd}" "${arg}
		fi
		((i=i+1))
	done

	# cd到任务目录，并执行任务命令，返回任务命令的执行返回值
	tmp=`pwd`
	cd $task_dir
	$task_cmd
	result=$?
	cd $tmp

	return $result
}


######################################################
#
# Function:   执行任务列表函数
#
# Params:
#			TASKFILE: 任务列表文件，结构为: 任务执行目录 任务执行命令（命令中可包含空格）
#
# Return:   $OK, $ERR
#
######################################################
function Run_Tasklist ()
{
	# 检查任务列表文件是否正常
	local taskfile=$1

	if [ ! -f $taskfile ]; then
		Write_Log_Fatal "$taskfile not exist!"
		if [ $SEND_EMAIL -eq 1 ]; then
			Send_Fatal_Mail
		fi
		return $ERR
	fi

	# 按行读取任务列表文件，执行每一个任务
	cat $taskfile | while read line
	do
		# 任务成功执行标志
		local success_flag=0

		# 如果任务执行错误，则按照配置进行自动重试
		for((retry_num=0; retry_num<$MAX_RETRY_NUM; retry_num++)); do
			Run_Task $line
			if [ $? -eq 0 ]; then
				success_flag=1
				break
			fi
			Write_Log_Debug "running task: $line failed, retrying. retry_num=$retry_num"
			sleep $RETRY_GAP
		done

		# 根据标志判断任务是否执行成功
		if [ $success_flag -eq 1 ]; then
			Write_Log_Debug "task: $line finished."
		else
			Write_Log_Fatal "task: $line failed."
			if [ $SEND_EMAIL -eq 1 ]; then
				Send_Fatal_Mail
			fi

			# 根据配置，决定是否在一个任务失败后退出整个任务流程
			if [ $EXIT_ON_ERROR -eq 1 ]; then
				return $ERR
			fi
		fi
		
		sleep $TASK_GAP
	done

	return $OK
}


