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
integer teste =0;

integer topvivas = 30;
integer topperdidas = 0;
integer topacertos = 0;

reg [7:0] ledg = 8'b00000001;
reg [6:0] hex0;
reg [6:0] hex1;
reg [26:0] contador;
assign LEDG = ledg;

assign HEX0 = hex0;
assign HEX1 = hex1;

reg [3:0] casa_da_toupeira;
//integer num_botao = {$random} % 4;

reg [31:0] doidera = 65735124645;

integer num_botao = (doidera<<5)%4 ;
reg [26:0] temp_cont;

initial begin
	
	case(num_botao) 

	0 : begin
	casa_da_toupeira = 4'b1110;
	ledg = ~casa_da_toupeira;
	end
	1 : begin
	 casa_da_toupeira = 4'b1101;
	 ledg = ~casa_da_toupeira;
	end
	2 : begin
	 casa_da_toupeira = 4'b1011;
	 ledg = ~casa_da_toupeira;
	 end
	3 : begin
	 casa_da_toupeira = 4'b0111;
	 ledg = ~casa_da_toupeira;
	 end

	endcase
end



always @(posedge CLOCK_50) begin



//ledg = ledg <<1;

	contador <= contador + 1;
	
	doidera <= doidera + 7;

	if((KEY != 4'b1111 && KEY != casa_da_toupeira) || contador==49_999_999 ) begin
	//perdeu incrementar o contador de topeiras perdidas
	topperdidas <= topperdidas + 1;

	//decrementa o contador de topeiras vivas
	topvivas <= topvivas - 1;

	//zerar o contador 
	contador <= 0;

	//verificar se ainda tem topeira para aparecer, se tiver rodar o random dnv
	if(topvivas > 0) begin
	num_botao = (doidera<<1)%4 ;
	case(num_botao) 

	0 : begin
	casa_da_toupeira = 4'b1110;
	ledg = ~casa_da_toupeira;
	end
	1 : begin
	 casa_da_toupeira = 4'b1101;
	 ledg = ~casa_da_toupeira;
	end
	2 : begin
	 casa_da_toupeira = 4'b1011;
	 ledg = ~casa_da_toupeira;
	 end
	3 : begin
	 casa_da_toupeira = 4'b0111;
	 ledg = ~casa_da_toupeira;
	 end

	endcase
	end
	end

	temp_cont = temp_cont + 1;
	
	if(temp_cont < 10000000 && teste == 1)
	begin 
	end
	
	else if(temp_cont > 10000000 && teste == 1)
	teste = 0;

	else if(KEY == casa_da_toupeira) begin
	
	teste =1;
	temp_cont = 0;

	//ganhou incrementar o contador 
	topacertos <= topacertos + 1;

	//decrementa o contador de tomeiras vivas
	topvivas <= topvivas - 1;

	//zerar o contador 
	contador <= 0;

	//verificar se ainda tem topeira para aparecer, se tiver rodar o random dnv
	if(topvivas > 0) begin
	num_botao = (doidera<<1)%4 ;
	case(num_botao)

	0 : begin
	casa_da_toupeira = 4'b1110;
	ledg = ~casa_da_toupeira;
	end
	1 : begin
	 casa_da_toupeira = 4'b1101;
	 ledg = ~casa_da_toupeira;
	end
	2 : begin
	 casa_da_toupeira = 4'b1011;
	 ledg = ~casa_da_toupeira;
	 end
	3 : begin
	 casa_da_toupeira = 4'b0111;
	 ledg = ~casa_da_toupeira;
	 end

	endcase
	end
	end

	case (topacertos)
		
		0 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b1000000; // 0
		end
		
		1 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b1111001; // 1
		end
		
		2 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b0100100; // 2
		end
		
		3 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b0110000; // 3
		end
		
		4 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b0011001; // 4
		end
		
		5 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b0010010; // 5
		end
		
		6 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b0000010; // 6
		end
		
		7 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b1111000; // 7
		end
		
		8 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b0000000; // 8
		end
		
		9 : begin
		hex1 = 7'b1000000; // 0
		hex0 = 7'b0010000; // 9
		end
		
		10 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b1000000; // 0
		end
		
		11 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b1111001; // 1
		end
		
		12 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b0100100; // 2	
		end
		
		13 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b0110000; // 3
		end
		
		14 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b0011001; // 4
		end
		
		15 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b0010010; // 5
		end
		
		16 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b0000010; // 6
		end
		
		17 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b1111000; // 7
		end
		
		18 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b0000000; // 8
		end
		
		19 : begin
		hex1 = 7'b1111001; // 1
		hex0 = 7'b0010000; // 9
		end
		
		20 : begin
		hex1 = 7'b0100100; // 2
		hex0 = 7'b1000000; // 0
		end
	
	endcase
	

end

endmodule
