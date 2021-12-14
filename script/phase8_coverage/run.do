vlib work
vmap work work
vlog +cover=t -f ./run.f
vsim -coverage -c tbench_top
coverage exclude -du tbench_top
coverage exclude -du xswitch
coverage exclude -du intf
coverage save -onexit phase_8.ucdb
run -all
exit
