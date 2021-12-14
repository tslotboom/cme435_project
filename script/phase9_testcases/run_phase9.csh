#!/bin/csh
source /CMC/scripts/mentor.questasim.2019.2.csh
set rootdir = `dirname $0`
cd $rootdir

if ($#argv == 0 || $#argv > 2 ) then
  echo "ERROR: Too many or too few arguments"
  echo "USAGE: $script_name -l | -t <testcase>"
  exit 0
endif



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

if ( "$1" == "-l" ) then
    foreach testcase ($testcase_list)
        echo $testcase
    end
    exit 0
else if ( "$1" == "-t" && $#argv == 2) then
    vlib work
    vmap work work
    vlog -f ./run.f
    set testcase_found = 0
    foreach testcase ($testcase_list)
        if ($testcase == "$2") then
            set testcase_found = 1
            vlog +cover=t ../../verification/$phase_name/test_${testcase}.sv
            vsim tbench_top -c -coverage -do "coverage exclude -du tbench_top; coverage exclude -du xswitch; coverage exclude -du intf; coverage save -onexit ../../report/phase_9_${testcase}.ucdb; run -all; exit"
        endif
    end
    if ("$testcase_found" == 0) then
        echo "Testcase ${2} not found in list of testcases"
    endif
else
    echo "ERROR: invalid arguments"
    exit 0
endif


rm -r work
rm transcript
rm modelsim.ini
