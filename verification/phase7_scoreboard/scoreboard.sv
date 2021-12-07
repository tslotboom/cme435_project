`ifndef _SCOREBOARD_
`define _SCOREBOARD_
`include "transaction.sv"
class scoreboard;

    mailbox mon2scb;

    semaphore scb2gen;

    function new(mailbox mon2scb, semaphore scb2gen);
        this.mon2scb = mon2scb;
        this.scb2gen = scb2gen;
    endfunction

    int packets_checked;

    task main;
        transaction trans;
        forever begin
            mon2scb.get(trans);
            trans.display("[Scoreboard]");
            packets_checked++;

            scb2gen.put();
        end
    endtask
endclass
`endif // _SCOREBOARD_
