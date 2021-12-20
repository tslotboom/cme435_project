#!/bin/csh

set rootdir = `dirname $0`
cd $rootdir
./phase1_top/run_phase1.csh
./phase2_environment/run_phase2.csh
./phase3_base/run_phase3.csh
./phase4_generator/run_phase4.csh
./phase5_driver/run_phase5.csh
./phase6_monitor/run_phase6.csh
./phase7_scoreboard/run_phase7.csh
./phase8_coverage/run_phase8.csh
./phase9_testcases/run_phase9.csh -t sanity
./regression_test/regression_test.csh
