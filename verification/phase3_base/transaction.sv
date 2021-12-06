`ifndef _TRANSACTION_
`define _TRANSACTION_
class transaction;
    rand logic [63:0]   data_in;
    rand logic [63:0]   addr_in;
    logic [3:0]         data_rcv;
    rand logic [3:0]    wr_en;

    logic [3:0]         fifo_empty;
    logic [3:0]         fifo_full;
    logic [3:0]         fifo_ae;
    logic [3:0]         fifo_af;

    logic [63:0]        data_out;
    logic [63:0]        addr_out;
    rand logic [3:0]    rd_en;
    logic [3:0]         data_rdy;

    rand logic [7:0]    prio_val;
    rand logic          prio_wr;

    rand logic          port_en;
    rand logic          port_wr;
    rand logic [1:0]    port_sel;
    rand logic [15:0]   port_addr;

    constraint c_addr_in {
        addr_in[15:0] < 4;
        addr_in[31:16] < 4;
        addr_in[47:32] < 4;
        addr_in[63:48] < 4;
    }

    constraint c_port_addr {
        port_addr[15:0] < 4;
    }

    function void display(string name);
    $display("------------------------------------------------------------");
    $display("%s: Time = %0d", name, $time);
    $display("%s: addr_in =     0x%4h_%4h_%4h_%4h  addr_out =   0x%4h_%4h_%4h_%4h", name, addr_in[63:48], addr_in[47:32], addr_in[31:16], addr_in[15:0], addr_out[63:48], addr_out[47:32], addr_out[31:16], addr_out[15:0]);
    $display("%s: data_in =     0x%4h_%4h_%4h_%4h  data_out =   0x%4h_%4h_%4h_%4h", name, data_in[63:48], data_in[47:32], data_in[31:16], data_in[15:0], data_out[63:48], data_out[47:32], data_out[31:16], data_out[15:0]);
    $display("%s: data_rcv =    0b%4b   data_rdy =    0b%4b", name, data_rcv, data_rdy);
    $display("%s: wr_en =       0b%4b   rd_en =       0b%4b", name, wr_en, rd_en);
    $display();
    $display("%s: fifo_empty =  0b%4b   fifo_full =   0b%4b", name, fifo_empty, fifo_full);
    $display("%s: fifo_ae =     0b%4b   fifo_af =     0b%4b", name, fifo_ae, fifo_af);
    $display();
    $display("%s: prio_val =    0x%2h   prio_wr =     0b%1b", name, prio_val, prio_wr);
    $display("%s: port_en =     0b%1b   port_wr =     0b%1b", name, port_en, port_wr);
    $display("%s: port_sel =    0x%2h   port_addr =   0x%4h", name, port_sel, port_addr);
    endfunction
endclass

`endif //_TRANSACTION_
