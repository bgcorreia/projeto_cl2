module Topeira(
	input CLOCK_50,
	input [3:0] KEY,
	output [7:0] LEDG,
	output [6:0] HEX0,
	output [6:0] HEX1
);

integer count = 0;
integer count1 = 0;
integer count2 = 0;

reg [7:0] ledg = 8'b00000001;
reg [6:0] hex0;
reg [6:0] hex1;
reg [26:0] contador;
assign LEDG = ledg;

assign HEX0 = hex0;
assign HEX1 = hex1;

always @(posedge CLOCK_50) begin

	contador <= contador + 1;

	if(~KEY[0] && contador==99_999_999 ) begin
		ledg = ledg <<1;
		count = 0;
	end
	
	case (count1)
		0 : hex0 = 7'b1000000;
		1 : hex0 = 7'b1111001;
		2 : hex0 = 7'b0100100; 
		3 : hex0 = 7'b0110000;
		4 : hex0 = 7'b0011001;
		5 : hex0 = 7'b0010010;  
		6 : hex0 = 7'b0000010;
		7 : hex0 = 7'b1111000;
		8 : hex0 = 7'b0000000;
		9 : hex0 = 7'b0010000;
	endcase

	case (count2)
		0 : hex1 = 7'b1000000;
		1 : hex1 = 7'b1111001;
		2 : hex1 = 7'b0100100; 
		3 : hex1 = 7'b0110000;
		4 : hex1 = 7'b0011001;
		5 : hex1 = 7'b0010010;  
		6 : hex1 = 7'b0000010;
		7 : hex1 = 7'b1111000;
		8 : hex1 = 7'b0000000;
		9 : hex1 = 7'b0010000;
	endcase


end

endmodule

