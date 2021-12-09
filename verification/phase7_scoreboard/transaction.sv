`ifndef _TRANSACTION_
`define _TRANSACTION_
class transaction;
    logic reset;

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
        soft addr_in[15:0] < 4;
        soft addr_in[31:16] < 4;
        soft addr_in[47:32] < 4;
        soft addr_in[63:48] < 4;
    }

    constraint unique_address {
        unique {addr_in[15:0], addr_in[31:16], addr_in[47:32], addr_in[63:48]};
    }

    constraint c_port_addr {
        soft port_addr[15:0] < 4;
    }

    constraint c_rd_en {
        if (data_rdy[0] == 1'b0)
            soft rd_en[0] == 1'b0;
        if (data_rdy[1] == 1'b0)
            soft rd_en[1] == 1'b0;
        if (data_rdy[2] == 1'b0)
            soft rd_en[2] == 1'b0;
        if (data_rdy[3] == 1'b0)
            soft rd_en[3] == 1'b0;
    }

    constraint make_life_easy {
        soft prio_val == 0;
        soft prio_wr == 0;
        soft port_en == 0;
        soft port_wr == 0;
        soft port_sel == 0;
        soft port_addr == 0;
    }

    function void display(string name);
    $display("------------------------------------------------------------");
    $display("%s: Time = %0d", name, $time);
    $display("%s: Reset = %0b", name, reset);
    $display();
    $display("%s: addr_in =     0X%4h_%4h_%4h_%4h  addr_out =   0X%4h_%4h_%4h_%4h", name, addr_in[63:48], addr_in[47:32], addr_in[31:16], addr_in[15:0], addr_out[63:48], addr_out[47:32], addr_out[31:16], addr_out[15:0]);
    $display("%s: data_in =     0X%4h_%4h_%4h_%4h  data_out =   0X%4h_%4h_%4h_%4h", name, data_in[63:48], data_in[47:32], data_in[31:16], data_in[15:0], data_out[63:48], data_out[47:32], data_out[31:16], data_out[15:0]);
    $display();
    $display("%s: data_rcv =    0B%4b   data_rdy =    0B%4b", name, data_rcv, data_rdy);
    $display("%s: wr_en =       0B%4b   rd_en =       0B%4b", name, wr_en, rd_en);
    $display();
    $display("%s: fifo_empty =  0B%4b   fifo_full =   0B%4b", name, fifo_empty, fifo_full);
    $display("%s: fifo_ae =     0B%4b   fifo_af =     0B%4b", name, fifo_ae, fifo_af);
    $display();
    $display("%s: port_en =     0B%1b   port_wr =     0B%1b", name, port_en, port_wr);
    $display("%s: port_sel =    0X%1h   port_addr =   0X%4h", name, port_sel, port_addr);
    $display("%s: prio_val =    0X%2h   prio_wr =     0B%1b", name, prio_val, prio_wr);

    endfunction
endclass

`endif //_TRANSACTION_
