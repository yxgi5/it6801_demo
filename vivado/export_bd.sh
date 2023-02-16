#!/bin/bash

#exit | source clean.sh -b
#source /opt/Xilinx/Vivado/xxx/settings64.sh
source setenv.sh
#vivado -mode tcl -source create_proj.tcl
vivado -mode batch -source export_bd.tcl
if [ $? != 0 ]
then
    echo -e "\n"
    echo -e "\033[41;36m export bd fail!!! Press any key to exit \033[0m"
    exit 1
else
    echo -e "\n"
    echo -e "\033[42;31m export bd done!!! Press any key to exit \033[0m"
fi
function pause(){
    read -n 1
}
exit | source clean.sh -b
pause
