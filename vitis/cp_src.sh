#!/bin/bash

mkdir -p src/vitis_proj/src
cp -r sdk_workspace/vitis_proj/src src/vitis_proj/

if [ $? != 0 ]
then
    echo -e "\n"
    echo -e "\033[41;36m copy src fail!!! Press any key to exit \033[0m"
    exit 1
else
    echo -e "\n"
    echo -e "\033[42;31m copy src done!!! Press any key to exit \033[0m"
fi


function pause(){
    read -n 1
}
pause

