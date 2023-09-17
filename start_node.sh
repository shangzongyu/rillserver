###############################################################################
# Copyright(C)   machine studio                                                #
# Author:        donney                                                       #
# Email:         donney_luck@sina.cn                                          #
# Date:          2022-02-22                                                   #
# Description:   use to start server                                          #
# Modification:  null                                                         #
###############################################################################
#!/usr/bin/env bash

COLOR_RED='\033[31m'
COLOR_GREEN='\033[32m'
COLOR_RESET='\033[0m'

export ROOT=$(cd `dirname $0`; pwd)
export SKYNET_ROOT=$ROOT/skynet
export DAEMON=false
NODE=1
## echo $ROOT
echo $SKYNET_ROOT
while getopts ":Dk" arg
do
	case $arg in
		D)
			export DAEMON=true
			;;
		k)
			kill `cat $ROOT/run/skynet.pid`
			exit 0;
			;;
	esac
done

shift $[$OPTIND-1]

#$SKYNET_ROOT/skynet $ROOT/etc/config_node${1:-1}
case "$1" in
    1|2|3|4|5|6)
    ;;
	*)
        echo -e "${COLOR_RED}Usage: $0 {-D node_id | -k | node_id}${COLOR_RESET}"
        echo -e "${COLOR_GREEN}-D node_id  -run server daemon (need node_id) ${COLOR_RESET}"
        echo -e "${COLOR_GREEN}-k          -kill server ${COLOR_RESET}"
        echo -e "${COLOR_GREEN}node_id     -run server ${COLOR_RESET}"
        exit 2
esac

$SKYNET_ROOT/skynet $ROOT/etc/config_node$1
