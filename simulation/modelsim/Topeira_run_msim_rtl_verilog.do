transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/brunoc/PROJETO_CL2 {/home/brunoc/PROJETO_CL2/Topeira.v}

