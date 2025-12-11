

module mod13_updown_counter (
    input clk,
    input rst,
    input load,
    input mode,
    input [3:0] data_in,
    output reg [3:0] count
);

    always @(posedge clk) 
		begin
			if(rst) 
				count <= 4'b0;
			else if (load)
				count <= data_in;
			else if(mode) 
				begin
					if (count == 12)
						count <= 0;
					else
						count <= count + 1;
				end 
			else 
				begin
					if(count == 0)
						count <= 12;
					else
						count <= count - 1;
				end
		end
		
endmodule

