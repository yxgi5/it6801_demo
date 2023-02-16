@echo off
REM #################################################################
REM # Copyright (c) 1986-2022 Xilinx, Inc.  All rights reserved.    #
REM #################################################################

CALL D:\Xilinx\Vivado\2020.1\settings64.bat
set PATH=D:\msys64\usr\bin;%PATH%
rem start bash -i -c 'vivado -mode batch'
rem start bash -i -c 'vivado -mode tcl'
start bash.exe
rem bash
rem bash -i -c 'vivado -mode tcl'
