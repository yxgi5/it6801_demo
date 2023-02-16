#!/bin/bash

function pause(){
    read -n 1
}

source_file=$PWD/system_wrapper.xsa
#echo source_file=$source_file
destination_dir=$PWD/../vitis/xsa/
#echo destination_dir=$destination_dir

if [ ! -f "$source_file" ];then
    #echo -e "\n"
    echo -e "\033[41;36m $source_file is not exist! \033[0m"
    exit 1
elif [ ! -d "$destination_dir" ];then
    #echo -e "\n"
    echo -e "\033[41;36m $destination_dir is not exist! \033[0m"
    exit 1
else
    #echo -e "\n"
    echo -e "copying $source_file to $destination_dir"
    cp -r $source_file $destination_dir
fi

if [ $? != 0 ]
then
    echo -e "\n"
    echo -e "\033[41;36m fail!!! Press any key to exit \033[0m"
    exit 1
else
    echo -e "\n"
    echo -e "\033[42;31m done!!! Press any key to exit \033[0m"
fi

pause
