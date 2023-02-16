
set project_name vivado_proj
set BD_name system
set design_name $BD_name

open_project ./${project_name}/${project_name}.xpr
open_bd_design ./$project_name/$project_name.srcs/sources_1/bd/$BD_name/$BD_name.bd
#update_compile_order -fileset sources_1

set obj [get_filesets sources_1]
if { [file exists ./$project_name/$project_name.srcs/sources_1/bd/$BD_name/$BD_name.bd] != 1 } {
	puts "bd file not exist"
    exit
} else {
	write_bd_tcl -force ./${BD_name}.tcl
}