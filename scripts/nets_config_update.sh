#!/usr/bin/env bash

# (C) Sergey Tyurin  2022-07-16 13:00:00

# Disclaimer
##################################################################################################################
# You running this script/function means you will not blame the author(s)
# if this breaks your stuff. This script/function is provided AS IS without warranty of any kind. 
# Author(s) disclaim all implied warranties including, without limitation, 
# any implied warranties of merchantability or of fitness for a particular purpose. 
# The entire risk arising out of the use or performance of the sample scripts and documentation remains with you.
# In no event shall author(s) be held liable for any damages whatsoever 
# (including, without limitation, damages for loss of business profits, business interruption, 
# loss of business information, or other pecuniary loss) arising out of the use of or inability 
# to use the script or documentation. Neither this script/function, 
# nor any part of it other than those parts that are explicitly copied from others, 
# may be republished without author(s) express written permission. 
# Author(s) retain the right to alter this disclaimer at any time.
##################################################################################################################

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
source "${SCRIPT_DIR}/env.sh"
source "${SCRIPT_DIR}/functions.shinc"

echo
echo "################################# All networks configs update script ###################################"
echo "+++INFO: $(basename "$0") BEGIN $(date +%s) / $(date)"

echo "Current network is $NETWORK_TYPE"

GLB_CFG_FNAME="ton-global.config.json"
TLC_CFG_FNAME="ton-lite-client.config.json"

MAIN_GLB_URL="https://raw.githubusercontent.com/everx-labs/main.ton.dev/master/configs/ton-global.config.json"
NET_GLB_URL="https://raw.githubusercontent.com/everx-labs/net.ton.dev/master/configs/ton-global.config.json"
FLD_GLB_URL="https://raw.githubusercontent.com/Everscale-Network/custler.uninode/main/configs/fld.ton.dev/ton-global.config.json"
RFLD_GLB_URL="https://raw.githubusercontent.com/FreeTON-Network/custler.uninode/main/configs/rfld.ton.dev/ton-global.config.json"
RST_GLB_URL="https://raw.githubusercontent.com/everx-labs/rustnet.ton.dev/main/configs/ton-global.config.json"

MAIN_CFG_DIR="$CONFIGS_DIR/main.ton.dev"
NET_CFG_DIR="$CONFIGS_DIR/net.ton.dev"
FLD_CFG_DIR="$CONFIGS_DIR/fld.ton.dev"
RFLD_CFG_DIR="$CONFIGS_DIR/rfld.ton.dev"
RST_CFG_DIR="$CONFIGS_DIR/rustnet.ton.dev"

[[ ! -d $HOME/logs ]] && mkdir -p $HOME/logs

declare -a net_list=("$MAIN_CFG_DIR" "$NET_CFG_DIR" "$FLD_CFG_DIR" "$RFLD_CFG_DIR" "$RST_CFG_DIR")
declare -a g_url_list=("$MAIN_GLB_URL" "$NET_GLB_URL" "$FLD_GLB_URL" "$RFLD_GLB_URL" "$RST_GLB_URL")
declare -a t_url_list=("$MAIN_TLC_URL" "$NET_TLC_URL" "$FLD_TLC_URL" "$RFLD_TLC_URL" "$RST_TLC_URL")
declare -a dir_list=("$MAIN_CFG_DIR" "$NET_CFG_DIR" "$FLD_CFG_DIR" "$RFLD_CFG_DIR" "$RST_CFG_DIR")

for i in $(seq 0 $((${#g_url_list[@]} - 1)) )
do
    [[ ! -d ${dir_list[i]} ]] && mkdir -p ${dir_list[i]}
    echo -n "Update global config for ${net_list[i]##*/} network... "
    curl -o ${dir_list[i]}/$GLB_CFG_FNAME ${g_url_list[i]}  &>/dev/null
    echo " ..DONE"
    if [[ ! "${t_url_list[i]}" == "xxx" ]];then
        echo -n "Update liteclient config for ${net_list[i]##*/} network... "
        curl -o ${dir_list[i]}/$TLC_CFG_FNAME ${t_url_list[i]} &>/dev/null
        echo " ..DONE"
    fi
done

ParentScript="$(ps -o command= $PPID |awk -F'/' '{print $2}')"
if [[ "${ParentScript}" != "Setup.sh" ]];then
    cp -f "${CONFIGS_DIR}/${NETWORK_TYPE}/ton-global.config.json" "${R_CFG_DIR}/"
fi

echo
echo "+++INFO: $(basename "$0") FINISHED $(date +%s) / $(date)"
echo "================================================================================================"

exit 0
