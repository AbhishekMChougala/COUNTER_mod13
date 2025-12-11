

class count_model;

    count_trans wrmon_data;
	
    mailbox #(count_trans) wr2rm;
    mailbox #(count_trans) rm2sb;

    static logic[3:0] ref_count = 0;

    function new(mailbox #(count_trans) wr2rm,
                 mailbox #(count_trans) rm2sb);
        this.wr2rm = wr2rm;
        this.rm2sb = rm2sb;
    endfunction

    virtual task count_mod(count_trans wrmon_data);
		begin
			if(wrmon_data.rst)
				ref_count <= 0;
			else if(wrmon_data.load)
				ref_count <= wrmon_data.data_in;
			else if(wrmon_data.mode)
				if(ref_count == 12)
					ref_count <= 0;
				else    
					ref_count <= ref_count + 1;
			else
				if(ref_count == 0)
					ref_count <= 12;
				else
					ref_count <= ref_count - 1; 
		end
    endtask: count_mod

    virtual task start();
		fork
			forever 
				begin
					wr2rm.get(wrmon_data);
					count_mod(wrmon_data);
					wrmon_data.count = ref_count;
					rm2sb.put(wrmon_data);
				end
		join_none
	endtask : start

endclass: count_model

