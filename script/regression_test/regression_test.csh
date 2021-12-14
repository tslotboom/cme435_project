#!/bin/csh
source /CMC/scripts/mentor.questasim.2019.2.csh
set rootdir = `dirname $0`
cd $rootdir

set phase_name = $rootdir:t:r


echo "$1"

set testcase_list = ( \
                    "sanity_directed" "sanity" \
                    "random" "random_no_reset" \
                    "fifo0" "fifo1" "fifo2" "fifo3" \
                    "all_addresses" "ports" "priority" "overlapping_addresses" \
                    )

set ucdb_list = ""

foreach testcase ($testcase_list)
    set ucdb_list = "$ucdb_list ../../report/${phase_name}_${testcase}.ucdb"
end

vlib work
vmap work work
vlog -f ./run.f

# functional coverage
foreach testcase ($testcase_list)
    vlog +cover=t ../../verification/$phase_name/test_${testcase}.sv
    vsim tbench_top -c -do "coverage exclude -du tbench_top; coverage exclude -du xswitch; coverage exclude -du intf; coverage save -onexit ../../report/${phase_name}_${testcase}.ucdb; run -all; exit"
end
vcover merge ../../report/xswitch_cov.ucdb $ucdb_list

vcover report ../../report/xswitch_cov.ucdb -output ../../report/xswitch_fc.rpt
vcover report -html ../../report/xswitch_cov.ucdb -output ../../report/xswitch_fc

code coverage
foreach testcase ($testcase_list)
    vlog +cover ../../verification/$phase_name/test_${testcase}.sv
    vsim -coverage tbench_top -c -do "coverage exclude -du tbench_top; coverage exclude -du xswitch; coverage exclude -du intf; coverage save -onexit ../../report/${phase_name}_${testcase}.ucdb; run -all; exit"
end
vcover merge ../../report/xswitch_cov.ucdb $ucdb_list

vcover report ../../report/xswitch_cov.ucdb -output ../../report/xswitch_cc.rpt
vcover report -html ../../report/xswitch_cov.ucdb -output ../../report/xswitch_cc



rm -r work
rm transcript
rm modelsim.ini
