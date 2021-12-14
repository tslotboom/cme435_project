`ifndef _TBENCH_TOP_
`define _TBENCH_TOP_
// `include "../../dut/dut_top.sv"
// `include "../../dut/xswitch64_bugs.sv"
`include "interface.sv"
`include "assertions.sv"
module tbench_top;

    bit clk = 1'b1;
    bit reset;

    always #5 clk = ~clk;

    always begin
        reset = 1;
        $display("[Tbench Top]: Reset applied at %0d", $time);
        #2 reset = 0;
        wait(reset_trigger.triggered);
    end

    event reset_trigger;

    intf i_intf(clk, reset);
    test testbench(i_intf.generator, i_intf.driver, i_intf.monitor);
    dut_top dut(i_intf.dut);
    // assertions ass(i_intf.dut);

    bind dut assertions assertion_bind (
        .intf_dut(i_intf)
    );

    // initial begin
    //     dut.dut_core.student_no = 11221182;
    //     dut.dut_core.enable_dut_bugs;
    // end

    // initial begin
    // $dumpfile("dumpfile.vcd"); $dumpvars;
    // end
endmodule
`endif // _TBENCH_TOP_
