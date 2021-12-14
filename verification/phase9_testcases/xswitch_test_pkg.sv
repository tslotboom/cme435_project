`ifndef _XSWITCH_PKG_
`define _XSWITCH_PKG_
package xswitch_test_pkg;
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

        logic [15:0] port_addresses [4];
        logic [7:0] port_priorities [4];

        constraint c_addr_in {
            soft addr_in[15:0] < 8;
            soft addr_in[31:16] < 8;
            soft addr_in[47:32] < 8;
            soft addr_in[63:48] < 8;
        }

        constraint c_port_addr {
            soft port_addr < 8;
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

        constraint unique_priority {
            soft prio_val != port_priorities[0];
            soft prio_val != port_priorities[1];
            soft prio_val != port_priorities[2];
            soft prio_val != port_priorities[3];
        }

        constraint no_repeated_addresses {
            soft port_addr != port_addresses[0];
            soft port_addr != port_addresses[1];
            soft port_addr != port_addresses[2];
            soft port_addr != port_addresses[3];
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
        $display();
        $display("%s: internal port addresses = 0X%4h_%4h_%4h_%4h", name, port_addresses[3], port_addresses[2], port_addresses[1], port_addresses[0]);
        $display("%s Port priorities: %2h %2h %2h %2h ", name, port_priorities[3], port_priorities[2], port_priorities[1], port_priorities[0]);

        endfunction
    endclass

    class fifo extends transaction;
        constraint wr_en_probability{
            wr_en[0] dist { 1'b1 := 7, 1'b0 := 1 };
            wr_en[1] dist { 1'b1 := 7, 1'b0 := 1 };
            wr_en[2] dist { 1'b1 := 7, 1'b0 := 1 };
            wr_en[3] dist { 1'b1 := 7, 1'b0 := 1 };
        }

        constraint rd_en_probability{
            rd_en[0] dist { 1'b1 := 1, 1'b0 := 7 };
            rd_en[1] dist { 1'b1 := 1, 1'b0 := 7 };
            rd_en[2] dist { 1'b1 := 1, 1'b0 := 7 };
            rd_en[3] dist { 1'b1 := 1, 1'b0 := 7 };
        }

        constraint no_port_change {
            port_sel == 0;
            port_en == 0;
            port_wr == 0;
            port_addr == 0;
        }

        constraint no_priority {
            prio_val == 0;
            prio_wr == 0;
        }
    endclass

    class fifo0 extends fifo;
        constraint ports {
            addr_in[15:0] == port_addresses[0];
            addr_in[31:16] == port_addresses[0];
            addr_in[47:32] == port_addresses[0];
            addr_in[63:48] == port_addresses[0];
        }
    endclass

    class fifo1 extends fifo;
        constraint ports {
            addr_in[15:0] == port_addresses[1];
            addr_in[31:16] == port_addresses[1];
            addr_in[47:32] == port_addresses[1];
            addr_in[63:48] == port_addresses[1];
        }
    endclass

    class fifo2 extends fifo;
        constraint ports {
            addr_in[15:0] == port_addresses[2];
            addr_in[31:16] == port_addresses[2];
            addr_in[47:32] == port_addresses[2];
            addr_in[63:48] == port_addresses[2];
        }
    endclass

    class fifo3 extends fifo;
        constraint ports {
            addr_in[15:0] == port_addresses[3];
            addr_in[31:16] == port_addresses[3];
            addr_in[47:32] == port_addresses[3];
            addr_in[63:48] == port_addresses[3];
        }
    endclass

    class all_addresses extends transaction;
        constraint c_addr_in_all {
            (addr_in[15:0] == port_addresses[0] ||
            addr_in[15:0] == port_addresses[1] ||
            addr_in[15:0] == port_addresses[2] ||
            addr_in[15:0] == port_addresses[3]);
            (addr_in[31:16] == port_addresses[0] ||
            addr_in[31:16] == port_addresses[1] ||
            addr_in[31:16] == port_addresses[2] ||
            addr_in[31:16] == port_addresses[3]);
            (addr_in[47:32] == port_addresses[0] ||
            addr_in[47:32] == port_addresses[1] ||
            addr_in[47:32] == port_addresses[2] ||
            addr_in[47:32] == port_addresses[3]);
            (addr_in[63:48] == port_addresses[0] ||
            addr_in[63:48] == port_addresses[1] ||
            addr_in[63:48] == port_addresses[2] ||
            addr_in[63:48] == port_addresses[3]);
        }

        constraint c_port_addr_all {
            port_addr < 16'hFFFF;
            port_addr > 16'h8;
        }
    endclass

    class no_port_or_prio_change extends transaction;

        constraint no_priority {
            soft prio_val == 0;
            soft prio_wr == 0;
        }

        constraint no_port_change {
        soft port_sel == 0;
            soft port_en == 0;
            soft port_wr == 0;
            soft port_addr == 0;
        }
    endclass

    class no_prio_change extends transaction;
        constraint no_priority {
            soft prio_val == 0;
            soft prio_wr == 0;
        }
    endclass

    class no_port_change extends transaction;
        constraint no_port_change {
            soft port_sel == 0;
            soft port_en == 0;
            soft port_wr == 0;
            soft port_addr == 0;
        }
    endclass

    class overlapping_addresses extends no_prio_change;
        constraint overlap {
            (addr_in[15:0] == addr_in[31:16] ||
            addr_in[15:0] == addr_in[47:32] ||
            addr_in[15:0] == addr_in[63:48]);
        }
    endclass

    class coverage;

        transaction trans;

        covergroup input_coverage;
            data_in0:    coverpoint trans.data_in[15:0]{
            bins a[64] = {[0:$]};
            }

            data_in1:    coverpoint trans.data_in[31:16]{
            bins a[64] = {[0:$]};
            }

            data_in2:    coverpoint trans.data_in[47:32]{
            bins a[64] = {[0:$]};
            }

            data_in3:    coverpoint trans.data_in[63:48]{
            bins a[64] = {[0:$]};
            }

            addr_in0:    coverpoint trans.addr_in[15:0]{
            bins a[64] = {[0:$]};
            }

            addr_in1:    coverpoint trans.addr_in[31:16]{
            bins a[64] = {[0:$]};
            }

            addr_in2:    coverpoint trans.addr_in[47:32]{
            bins a[64] = {[0:$]};
            }

            addr_in3:    coverpoint trans.addr_in[63:48]{
            bins a[64] = {[0:$]};
            }

            valid_in:   coverpoint trans.wr_en{
            bins a[] = {[0:$]};
            }

            valid_in0:   coverpoint trans.wr_en[0]{
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            valid_in1:   coverpoint trans.wr_en[1]{
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            valid_in2:   coverpoint trans.wr_en[2]{
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            valid_in3:   coverpoint trans.wr_en[3]{
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            data_read:   coverpoint trans.rd_en{
            bins a[] = {[0:$]};
            }

            data_read0:   coverpoint trans.rd_en[0]{
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            data_read1:   coverpoint trans.rd_en[1]{
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            data_read2:   coverpoint trans.rd_en[2]{
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            data_read3:   coverpoint trans.rd_en[3]{
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }


            reset: coverpoint trans.reset{
            bins low = {1'b0};
            bins high = {1'b1};
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            }

            prio_vals: coverpoint trans.prio_val{
            bins prio_vals[] = {[0:$]};
            }

            prio_wr: coverpoint trans.prio_wr{
            bins a = {1'b0};
            bins b = {1'b1};
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            port_en: coverpoint trans.port_en{
            bins a = {1'b0};
            bins b = {1'b1};
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            port_wr: coverpoint trans.port_wr{
            bins a = {1'b0};
            bins b = {1'b1};
            bins low_high = (0=>1);
            bins high_low = (1=>0);
            bins zero_consecutive = (0[*2]);
            bins one_consecutive = (1[*2]);
            }

            port_sel: coverpoint trans.port_sel{
            bins a[] = {[0:$]};
            }

            port_addr: coverpoint trans.port_addr{
            bins a[64] = {[0:$]};
            }

            // cross data_in0, data_in1, data_in2, data_in3, addr_in0, addr_in1, addr_in2, addr_in3, valid_in;
            // cross port_addr, port_sel, port_wr, port_en;
            // cross prio_vals, prio_wr, port_sel;
        endgroup

        covergroup output_coverage;
            data_rcv:    coverpoint trans.data_rcv{
            bins a[] = {[0:$]};
            }

            data_rdy:    coverpoint trans.data_rdy{
            bins a[] = {[0:$]};
            }

            data_out0:    coverpoint trans.data_out[15:0]{
            bins a[64] = {[0:$]};
            }

            data_out1:    coverpoint trans.data_out[31:16]{
            bins a[64] = {[0:$]};
            }

            data_out2:    coverpoint trans.data_out[47:32]{
            bins a[64] = {[0:$]};
            }

            data_out3:    coverpoint trans.data_out[63:48]{
            bins a[64] = {[0:$]};
            }

            addr_out0:    coverpoint trans.addr_out[15:0]{
            bins a[] = {[0:3]};
            }

            addr_out1:    coverpoint trans.addr_out[31:16]{
            bins a[] = {[0:3]};
            }

            addr_out2:    coverpoint trans.addr_out[47:32]{
            bins a[] = {[0:3]};
            }

            addr_out3:    coverpoint trans.addr_out[63:48]{
            bins a[] = {[0:3]};
            }

            fifo_empty0:    coverpoint trans.fifo_empty[0]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_empty1:    coverpoint trans.fifo_empty[1]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_empty2:    coverpoint trans.fifo_empty[2]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_empty3:    coverpoint trans.fifo_empty[3]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_full0:    coverpoint trans.fifo_full[0]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_full1:    coverpoint trans.fifo_full[1]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_full2:    coverpoint trans.fifo_full[2]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_full3:    coverpoint trans.fifo_full[3]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_ae0:    coverpoint trans.fifo_ae[0]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_ae1:    coverpoint trans.fifo_ae[1]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_ae2:    coverpoint trans.fifo_ae[2]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_ae3:    coverpoint trans.fifo_ae[3]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_af0:    coverpoint trans.fifo_af[0]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_af1:    coverpoint trans.fifo_af[1]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_af2:    coverpoint trans.fifo_af[2]{
            bins a = {1'b0};
            bins b = {1'b1};
            }

            fifo_af3:    coverpoint trans.fifo_af[3]{
            bins a = {1'b0};
            bins b = {1'b1};
            }
        endgroup

        function new();
            input_coverage = new();
            output_coverage = new();
        endfunction: new

        task sample(transaction trans);
            this.trans = trans;
            input_coverage.sample();
            output_coverage.sample();
        endtask:sample
    endclass
endpackage
`endif // _XSWITCH_PKG_
