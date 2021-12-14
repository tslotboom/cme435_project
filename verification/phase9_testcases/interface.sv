`ifndef _INTERFACE_
`define _INTERFACE_
interface intf (
    input bit clk,
    input bit reset);

    logic [63:0]    data_in;
    logic [63:0]    addr_in;
    logic [3:0]     data_rcv;
    logic [3:0]     wr_en;

    logic [3:0]     fifo_empty;
    logic [3:0]     fifo_full;
    logic [3:0]     fifo_ae;
    logic [3:0]     fifo_af;

    logic [63:0]    data_out;
    logic [63:0]    addr_out;
    logic [3:0]     rd_en;
    logic [3:0]     data_rdy;

    logic [7:0]     prio_val;
    logic           prio_wr;

    logic           port_en;
    logic           port_wr;
    logic [1:0]     port_sel;
    logic [15:0]    port_addr;


    modport dut (
        input     reset,
        input     clk,

        input     data_in,
        input     addr_in,
        output    data_rcv,
        input     wr_en,

        output    fifo_empty,
        output    fifo_full,
        output    fifo_ae,
        output    fifo_af,

        output    data_out,
        output    addr_out,
        input     rd_en,
        output    data_rdy,

        input     prio_val,
        input     prio_wr,

        input     port_en,
        input     port_wr,
        input     port_sel,
        input     port_addr
    );

    modport generator (
        input reset,
        input clk,
        input data_rcv,
        input fifo_empty,
        input fifo_full,
        input fifo_ae,
        input fifo_af,
        input data_out,
        input addr_out,
        input data_rdy
    );

    modport driver (
        clocking driver_cb, clk, reset
    );

    clocking driver_cb@(posedge clk);
        output     data_in;
        output     addr_in;
        input    data_rcv;
        output     wr_en;

        input    fifo_empty;
        input    fifo_full;
        input    fifo_ae;
        input    fifo_af;

        input    data_out;
        input    addr_out;
        output     rd_en;
        input    data_rdy;

        output     prio_val;
        output     prio_wr;

        output     port_en;
        output     port_wr;
        output     port_sel;
        output     port_addr;
    endclocking

    modport monitor (
        clocking monitor_cb, clk, reset
    );

    clocking monitor_cb@(posedge clk);
        input     data_in;
        input     addr_in;
        input    data_rcv;
        input     wr_en;

        input    fifo_empty;
        input    fifo_full;
        input    fifo_ae;
        input    fifo_af;

        input    data_out;
        input    addr_out;
        input     rd_en;
        input    data_rdy;

        input     prio_val;
        input     prio_wr;

        input     port_en;
        input     port_wr;
        input     port_sel;
        input     port_addr;
    endclocking



endinterface
`endif // _INTERFACE_
