

class count_rd_mon;

	virtual count_if.RD_MON_MP rd_mon_if;

	count_trans data2sb;
	count_trans rddata;

	mailbox #(count_trans) rd2sb;

   	function new(virtual count_if.RD_MON_MP rd_mon_if,
                 mailbox #(count_trans) rd2sb);
      		this.rd_mon_if = rd_mon_if;
      		this.rd2sb     = rd2sb;
      		this.rddata    = new;
   	endfunction


   	virtual task monitor();

		@(rd_mon_if.RD_MON_CB);
      	    begin
         		rddata.count = rd_mon_if.RD_MON_CB.count;
         		rddata.display("\tDATA FROM READ MONITOR");    
      		end
   	endtask: monitor 

	virtual task start();
		fork
		    forever
				begin
					monitor();
					data2sb = new rddata;
					rd2sb.put(data2sb);
				end
		join_none
	endtask: start

endclass: count_rd_mon

