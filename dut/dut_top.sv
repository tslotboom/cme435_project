`ifndef _DUT_TOP_
`define _DUT_TOP_
module dut_top(intf.dut i_intf);
    xswitch xsw(
    i_intf.data_in,
    i_intf.addr_in,
    i_intf.data_rcv,
    i_intf.wr_en,
    i_intf.fifo_empty,
    i_intf.fifo_full,
    i_intf.fifo_ae,
    i_intf.fifo_af,
    i_intf.data_out,
    i_intf.addr_out,
    i_intf.rd_en,
    i_intf.data_rdy,
    i_intf.prio_val,
    i_intf.prio_wr,
    i_intf.port_en,
    i_intf.port_wr,
    i_intf.port_sel,
    i_intf.port_addr,
    i_intf.reset,
    i_intf.clk
    );
endmodule
`endif // _DUT_TOP_
