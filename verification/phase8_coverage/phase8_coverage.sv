`ifndef _COVERAGE_
`define _COVERAGE_
`include "transaction.sv"

class coverage;

    transaction trans;

    covergroup input_coverage;
        data_in:    coverpoint trans.data_in{
        bins a[256] = {[0:$]};
        }

        addr_in0:    coverpoint trans.addr_in[15:0]{
        bins a[] = {[0:8]};
        }

        addr_in1:    coverpoint trans.addr_in[31:16]{
        bins a[] = {[0:8]};
        }

        addr_in2:    coverpoint trans.addr_in[47:32]{
        bins a[] = {[0:8]};
        }

        addr_in3:    coverpoint trans.addr_in[63:48]{
        bins a[] = {[0:8]};
        }

        addr_in4:    coverpoint trans.addr_in[15:0]{
        bins a[] = {[0:$]};
        }

        addr_in5:    coverpoint trans.addr_in[31:16]{
        bins a[] = {[0:$]};
        }

        addr_in6:    coverpoint trans.addr_in[47:32]{
        bins a[] = {[0:$]};
        }

        addr_in7:    coverpoint trans.addr_in[63:48]{
        bins a[] = {[0:$]};
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
        bins low[10] = {1'b0};
        bins high[10] = {1'b1};
        bins low_high = (0=>1);
        bins high_low = (1=>0);
        bins zero_consecutive = (0[*2]);
        }

        prio_vals: coverpoint trans.prio_val{
        bins prio_vals[] = {[0:$]};
        }

        prio_wr: coverpoint trans.prio_wr{
        bins a[10] = {1'b0};
        bins b[10] = {1'b1};
        bins low_high = (0=>1);
        bins high_low = (1=>0);
        bins zero_consecutive = (0[*2]);
        bins one_consecutive = (1[*2]);
        }

        port_en: coverpoint trans.port_en{
        bins a[10] = {1'b0};
        bins b[10] = {1'b1};
        bins low_high = (0=>1);
        bins high_low = (1=>0);
        bins zero_consecutive = (0[*2]);
        bins one_consecutive = (1[*2]);
        }

        port_wr: coverpoint trans.port_wr{
        bins a[10] = {1'b0};
        bins b[10] = {1'b1};
        bins low_high = (0=>1);
        bins high_low = (1=>0);
        bins zero_consecutive = (0[*2]);
        bins one_consecutive = (1[*2]);
        }

        port_sel: coverpoint trans.port_sel{
        bins a[] = {[0:$]};
        }

        port_addr: coverpoint trans.port_addr{
        bins a[] = {[0:$]};
        }

        cross data_in, addr_in0, addr_in1, addr_in2, addr_in3, valid_in;
        cross port_addr, port_sel, port_wr, port_en;
        cross prio_vals, prio_wr, port_sel;
    endgroup

    covergroup output_coverage;
        data_rcv:    coverpoint trans.data_rcv{
        bins a[] = {[0:$]};
        }

        data_rdy:    coverpoint trans.data_rdy{
        bins a[] = {[0:$]};
        }

        data_out:    coverpoint trans.data_out{
        bins a[256] = {[0:$]};
        }

        addr_out0:    coverpoint trans.addr_out[15:0]{
        bins a[] = {[0:8]};
        }

        addr_out1:    coverpoint trans.addr_out[31:16]{
        bins a[] = {[0:8]};
        }

        addr_out2:    coverpoint trans.addr_out[47:32]{
        bins a[] = {[0:8]};
        }

        addr_out3:    coverpoint trans.addr_out[63:48]{
        bins a[] = {[0:8]};
        }

        addr_out4:    coverpoint trans.addr_out[15:0]{
        bins a[] = {[0:$]};
        }

        addr_out5:    coverpoint trans.addr_out[31:16]{
        bins a[] = {[0:$]};
        }

        addr_out6:    coverpoint trans.addr_out[47:32]{
        bins a[] = {[0:$]};
        }

        addr_out7:    coverpoint trans.addr_out[63:48]{
        bins a[] = {[0:$]};
        }

        fifo_empty:    coverpoint trans.fifo_empty{
        bins a[] = {[0:$]};
        }

        fifo_full:    coverpoint trans.fifo_full{
        bins a[] = {[0:$]};
        }

        fifo_ae:    coverpoint trans.fifo_ae{
        bins a[] = {[0:$]};
        }

        fifo_af:    coverpoint trans.fifo_af{
        bins a[] = {[0:$]};
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
`endif // _COVERAGE_
