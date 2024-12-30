module wave_select(sin,square,triangle,contral,data);
	input [7:0]sin;
	input [7:0]square;
	input [7:0]triangle;
	input [1:0]contral;
	output reg[7:0]data;
	always @(sin or square or triangle or contral)
	begin
		case(contral)
		2'b01:data<=sin;
		2'b10:data<=square;
		2'b11:data<=triangle;
		endcase
	end
endmodule
		
		