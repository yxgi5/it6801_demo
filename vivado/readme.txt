for Linux, 

Default installed path:
/opt/Xilinx/Vivado/2020.1

method 1:
export bd file
./export_bd.sh
clean folder and generate project only
./proj_gen.sh       ## this will del exist proj, so backup files like bd and xdc before execute
clean folder and generate project then build bitmap
./proj_build.sh     ## will not gen new proj if proj exists, and xsa will put out of proj folder, just in current folder
copy xsa file in current folder to vitis
./cp_xsa_to_vitis.sh

method 2:

source setenv.sh  [!!!]
make project_clean
make project
...
make bitstream


source tlc file:
vivado.bat -mode tcl





for Windows

Default installed path:
D:\Xilinx\Vivado\2020.1\

install base msys2(bash, rm, make...)
D:\msys64

method 1:
double click setenv_bash.bat, then in bash
./export_bd.sh
./proj_gen.sh
./proj_build.sh
./cp_xsa_to_vitis.sh

method 2:
double click setenv_bash.bat, then in bash

make project_clean
make project
...
make bitstream


source tlc file: open setenv_bash.bat or setenv_cmd.bat,then
vivado.bat -mode tcl
