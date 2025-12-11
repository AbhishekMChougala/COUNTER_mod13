

class count_sb;

    event DONE;

    count_trans rm_data;
    count_trans rcvd_data;
    count_trans cov_data;

    static int data_verified  = 0;
    static int rm_data_count  = 0;
    static int mon_data_count = 0;

    mailbox #(count_trans) rm2sb;
    mailbox #(count_trans) rd2sb;

    covergroup coverage;
		option.per_instance = 1;
		
		// Coverpoint for reset signal with bins for 0 and 1
		RESET : coverpoint cov_data.rst {
			bins rst = {0, 1};
		}
		
		// Coverpoint for load signal with bins for 0 and 1
		LOAD : coverpoint cov_data.load {
			bins load = {0, 1};
		}

		// Coverpoint for mode signal with bins for 0 and 1
		MODE : coverpoint cov_data.mode {
			bins mode = {0, 1};
		}

		// Detailed coverpoint for data_in signal with specific ranges
		DATA : coverpoint cov_data.data_in {
			bins data_in_low  = {[0:6]};       
			bins data_in_high = {[7:12]};  
		}

		// Detailed coverpoint for data_out signal with specific ranges
		COUNT : coverpoint cov_data.count {
			bins data_out_low  = {[0:6]};      
			bins data_out_high = {[7:12]};  
		}
    endgroup: coverage

    function new(mailbox #(count_trans) rm2sb,
                 mailbox #(count_trans) rd2sb);
        this.rm2sb = rm2sb;
        this.rd2sb = rd2sb;
        coverage = new;
    endfunction

    virtual task start();
		fork
			forever
				begin
					rm2sb.get(rm_data);
					rm_data_count++;
					rd2sb.get(rcvd_data);
					mon_data_count++;
					check(rcvd_data);
				end
		join_none
    endtask: start

    virtual task check(count_trans rc_data);
		begin
			if(rm_data.count == rc_data.count)
				$display("\n\tCOUNT MATCHING\n");
			else
				$display("\n\tCOUNT NOT MATCHING\n");
		end
		
		cov_data = new rm_data;
		coverage.sample;
		data_verified++;
		
        if(data_verified >= number_of_transactions)
			begin
				->DONE;
			end
			
    endtask: check

    virtual function void report();
      $display("\n------------------------ SCOREBOARD REPORT -----------------------\n ");
      $display("Data_generated = %d", mon_data_count);
      $display("Data_verified  = %d", data_verified);
      $display("\n------------------------------------------------------------------\n ");
    endfunction: report
    
endclass: count_sb


