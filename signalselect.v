module signalselect(clk,addr,speed,reset);
input	speed;
input clk;
input reset;
output reg [7:0]addr;
reg [2:0]cnt=0;
	always @(speed or reset)
	begin
		if(!speed)
		begin
			if(cnt<3'b101)
				cnt<=cnt+1;
			else
				cnt<=0;
		end
		
		
		if(!reset)
			cnt<=0;
	end
	
	always @(posedge clk)
	begin	
		case(cnt)
			3'b000:
				if(addr<=255)
					addr=addr+1;
				else
					addr<=0;			
			3'b001:
				if(addr<=255-1)
					addr=addr+2;
				else
					addr<=0;
			3'b010:
				if(addr<=255-2)
					addr=addr+3;
				else
					addr<=0;
			3'b011:
				if(addr<=255-3)
					addr=addr+4;
				else
					addr<=0;
			3'b100:
				if(addr<=255-4)
					addr=addr+5;
				else
					addr<=0;			
		endcase
	end
endmodule	
		