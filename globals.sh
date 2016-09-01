#!/usr/bin/bash

######################################################
#
# File Name:	globals.sh
#
# Function:		shell全局变量定义
#
# Usage:		source globals
#
# Input:		none
#
# Output:		none
#
# Author:		panwenhai
#
# Create Time:    2016-07-01 15:50:34
#
######################################################

# 返回值，0表示成功，1表示失败
OK=0
ERR=1

# 工作目录
WORK_PATH=$(cd "$(dirname "$0")"; pwd)

# 脚本名
PROG_NAME=$(basename "$0")

# 常用日期
TODAY=`date +%Y%m%d`
YESTERDAY=`date -d last-day +%Y%m%d`

# 其他全局变量


