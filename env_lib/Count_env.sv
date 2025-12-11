

class count_env;

    virtual count_if.WR_DRV_MP wr_drv_if;
    virtual count_if.WR_MON_MP wr_mon_if;
    virtual count_if.RD_MON_MP rd_mon_if;

    mailbox #(count_trans) gen2wr = new;
    mailbox #(count_trans) wr2rm  = new;
    mailbox #(count_trans) rd2sb  = new;
    mailbox #(count_trans) rm2sb  = new;

    count_gen       gen_h;
    count_wr_drv    wr_drv_h;                  
    count_rd_mon    rd_mon_h;                   
    count_wr_mon    wr_mon_h;                          
    count_model     ref_mod_h;                            
    count_sb        sb_h;                                         

    function new(virtual count_if.WR_DRV_MP wr_drv_if,
                 virtual count_if.WR_MON_MP wr_mon_if,
                 virtual count_if.RD_MON_MP rd_mon_if);
        this.wr_drv_if = wr_drv_if;
        this.wr_mon_if = wr_mon_if;
        this.rd_mon_if = rd_mon_if;
    endfunction

    task build();
        gen_h     = new(gen2wr);
        wr_drv_h  = new(wr_drv_if, gen2wr);
        wr_mon_h  = new(wr_mon_if, wr2rm);
        rd_mon_h  = new(rd_mon_if, rd2sb);
        ref_mod_h = new(wr2rm, rm2sb);    
        sb_h      = new(rm2sb, rd2sb);        
    endtask: build

    virtual task reset_dut();
		begin
			@(wr_drv_if.WR_DRV_CB);
			wr_drv_if.WR_DRV_CB.rst <= 1'b1;

			repeat(2)
			@(wr_drv_if.WR_DRV_CB);
			wr_drv_if.WR_DRV_CB.rst <= 1'b0;
		end
    endtask: reset_dut
	
    task start();
	$display("Time=%0t", $time);
        gen_h.start;
        wr_drv_h.start;
        rd_mon_h.start;
        wr_mon_h.start;
        ref_mod_h.start;
        sb_h.start;    
    endtask: start

    virtual task stop();
        wait(sb_h.DONE.triggered);
    endtask: stop

    task run();
		reset_dut;
        start;
        stop;
        sb_h.report;
    endtask: run
	
endclass: count_env

