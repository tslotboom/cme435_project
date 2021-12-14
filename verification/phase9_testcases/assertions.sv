`ifndef _ASSERTIONS_
`define _ASSERTIONS_
module assertions(intf.dut intf_dut);

    // sequence s_data_in;
    //     @(posedge intf_dut.clk) intf_dut.data_in[15:0] !=
    //         $past(intf_dut.data_in[15:0], 1) && ;
    // endsequence
    //
    // a_data_in: assert property (s_data_in)
    //     else $display("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA time=%0d", $time);

    property p_data_out_0;
        @(posedge intf_dut.clk)
            intf_dut.data_out[15:0] != $past(intf_dut.data_out[15:0], 1) |-> intf_dut.data_rdy[0];
    endproperty
    a_data_out_0: assert property (p_data_out_0);
    c_data_out_0: cover property (p_data_out_0);

    property p_data_out_1;
        @(posedge intf_dut.clk)
            intf_dut.data_out[31:16] != $past(intf_dut.data_out[31:16], 1) |-> intf_dut.data_rdy[1];
    endproperty
    a_data_out_1: assert property (p_data_out_1);
    c_data_out_1: cover property (p_data_out_1);

    property p_data_out_2;
        @(posedge intf_dut.clk)
            intf_dut.data_out[47:32] != $past(intf_dut.data_out[47:32], 1) |-> intf_dut.data_rdy[2];
    endproperty
    a_data_out_2: assert property (p_data_out_2);
    c_data_out_2: cover property (p_data_out_0);

    property p_data_out_3;
        @(posedge intf_dut.clk)
            intf_dut.data_out[63:48] != $past(intf_dut.data_out[63:48], 1) |-> intf_dut.data_rdy[3];
    endproperty
    a_data_out_3: assert property (p_data_out_3);
    c_data_out_3: cover property (p_data_out_3);


    property p_addr_out_0;
        @(posedge intf_dut.clk)
            intf_dut.addr_out[15:0] != $past(intf_dut.addr_out[15:0], 1) |-> intf_dut.data_rdy[0];
    endproperty
    a_addr_out_0: assert property (p_addr_out_0);
    c_addr_out_0: cover property (p_addr_out_0);

    property p_addr_out_1;
        @(posedge intf_dut.clk)
            intf_dut.addr_out[31:16] != $past(intf_dut.addr_out[31:16], 1) |-> intf_dut.data_rdy[1];
    endproperty
    a_addr_out_1: assert property (p_addr_out_1);
    c_addr_out_1: cover property (p_addr_out_1);

    property p_addr_out_2;
        @(posedge intf_dut.clk)
            intf_dut.addr_out[47:32] != $past(intf_dut.addr_out[47:32], 1) |-> intf_dut.data_rdy[2];
    endproperty
    a_addr_out_2: assert property (p_addr_out_2);
    c_addr_out_2: cover property (p_addr_out_0);

    property p_addr_out_3;
        @(posedge intf_dut.clk)
            intf_dut.addr_out[63:48] != $past(intf_dut.addr_out[63:48], 1) |-> intf_dut.data_rdy[3];
    endproperty
    a_addr_out_3: assert property (p_addr_out_3);
    c_addr_out_3: cover property (p_addr_out_3);

endmodule
`endif
