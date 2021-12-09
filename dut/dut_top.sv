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

    // always @ * begin
    //     $display("Time: %0d", $time);
    //     $display("Reset: %0b", i_intf.reset);
    //     $display("addr_in =     0X%4h_%4h_%4h_%4h  addr_out =   0X%4h_%4h_%4h_%4h", i_intf.addr_in[63:48], i_intf.addr_in[47:32], i_intf.addr_in[31:16], i_intf.addr_in[15:0], i_intf.addr_out[63:48], i_intf.addr_out[47:32], i_intf.addr_out[31:16], i_intf.addr_out[15:0]);
    //     $display("data_in =     0X%4h_%4h_%4h_%4h  data_out =   0X%4h_%4h_%4h_%4h", i_intf.data_in[63:48], i_intf.data_in[47:32], i_intf.data_in[31:16], i_intf.data_in[15:0], i_intf.data_out[63:48], i_intf.data_out[47:32], i_intf.data_out[31:16], i_intf.data_out[15:0]);
    //     $display();
    //     $display("data_rcv =    0B%4b   data_rdy =    0B%4b", i_intf.data_rcv, i_intf.data_rdy);
    //     $display("wr_en =       0B%4b   rd_en =       0B%4b", i_intf.wr_en, i_intf.rd_en);
    //     $display();
    //     $display("fifo_empty =  0B%4b   fifo_full =   0B%4b", i_intf.fifo_empty, i_intf.fifo_full);
    //     $display("fifo_ae =     0B%4b   fifo_af =     0B%4b", i_intf.fifo_ae, i_intf.fifo_af);
    //     $display();
    //     $display("prio_val =    0X%2h   prio_wr =     0B%1b", i_intf.prio_val, i_intf.prio_wr);
    //     $display("port_en =     0B%1b   port_wr =     0B%1b", i_intf.port_en, i_intf.port_wr);
    //     $display("port_sel =    0X%1h   port_addr =   0X%4h", i_intf.port_sel, i_intf.port_addr);
    // end
endmodule
`endif // _DUT_TOP_
