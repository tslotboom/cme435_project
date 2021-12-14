`ifndef _TBENCH_TOP_
`define _TBENCH_TOP_
module tbench_top;

    bit clk;
    bit reset;

    always #5 clk = ~clk;

    always begin
        reset = 1;
        #2 reset = 0;
        wait(reset_trigger.triggered);
    end

    event reset_trigger;

    intf i_intf(clk, reset);
    test testbench(i_intf);
    dut_top dut(i_intf.dut);

    // initial begin
    // $dumpfile("dumpfile.vcd"); $dumpvars;
    // end
endmodule
`endif // _TBENCH_TOP_
