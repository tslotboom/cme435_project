#!/bin/csh
source /CMC/scripts/mentor.questasim.2019.2.csh
set rootdir = `dirname $0`
cd $rootdir
# vsim -c -do "run.do" | tee out.txt
vsim -c -do "run.do"

vcover report -details ../../report/phase_8.ucdb -output phase_8.rpt
vcover report -details -html ../../report/phase_8.ucdb -output phase_8

rm -r work
rm transcript
rm modelsim.ini
