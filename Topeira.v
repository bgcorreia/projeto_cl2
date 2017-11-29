module Topeira(
	input CLOCK_50,
	input [3:0] KEY,
	output [7:0] LEDG,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7,
	output LCD_ON,    // LCD Power ON/OFF
	output LCD_BLON,	// LCD Back Light ON/OFF
	output LCD_RW,    // LCD Read/Write Select, 0 = Write, 1 = Read
	output LCD_EN,    // LCD Enable
	output LCD_RS,    // LCD Command/Data Select, 0 = Command, 1 = Data
	inout [7:0] LCD_DATA
);
 
integer topvivas = 10;
integer topperdidas = 0;
integer topacertos = 0;
integer nivel = 1;
integer pontos = 0;
integer tempo = 3;
integer valor = 50;
 
reg [7:0] ledg;

reg [6:0] hex1;
reg [6:0] hex2;
reg [6:0] hex3;
reg [6:0] hex4;
reg [6:0] hex5;
reg [6:0] hex6;
reg [6:0] hex7;
reg [26:0] contador;
reg [31:0] clock;
reg [31:0] x;
 
assign LEDG = ledg;
 
assign HEX0 = ~7'h3F;
assign HEX1 = hex1;
assign HEX2 = hex2;
assign HEX3 = hex3;
assign HEX4 = hex4;
assign HEX5 = hex5;
assign HEX6 = hex6;
assign HEX7 = hex7;
 
reg [3:0] casa_da_toupeira;
 
reg [3:0] num_botao;
 
wire [7:0] blank = ~7'h3F;
 
reg ResetLCD = 0;
wire RESET;
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;

parameter nivel1 = 3'd1, nivel2 = 3'd2, nivel3 = 3'd3, nivel4 = 3'd4;

reg [2:0] estado_atual = 3'd1 ;

Reset_Delay r0(
	.iCLK(CLOCK_50),
	.oRESET(RESET)
);

LCD_TEST u1(
// Host Side
   .iCLK(CLOCK_50),
   .iRST_N(RESET),
// LCD Side
   .LCD_DATA(LCD_DATA),
   .LCD_RW(LCD_RW),
   .LCD_EN(LCD_EN),
   .LCD_RS(LCD_RS),
   .estado_atual(estado_atual),
   .ResetLCD(ResetLCD)
);
 
initial begin
 
	num_botao <= 0;
 
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
	 
	endcase // fim case botao
	
end // fim inital
 
always @(posedge clock) begin

	ResetLCD = 0;

	// Passa o nivel quando acabaram as toupeiras
	// Na primeira execucao passa direto
	if (topvivas == 0) begin
	
		case (nivel)
		
			1 : begin
				topvivas <= 15;
				topacertos <= 0;
				topperdidas <= 0;
				tempo <= 2;
				nivel <= 2;
				estado_atual = nivel2;
				valor <= 70;
				num_botao <= 0;
				ResetLCD = 1;
			end
			
			2 : begin
				topvivas <= 20;
				topacertos <= 0;
				topperdidas <= 0;
				tempo <= 1;
				nivel <= 3;
				estado_atual = nivel3;
				valor <= 100;
				num_botao <= 0;
				ResetLCD = 1;
			end
			
			3 : begin
				topvivas <= 0;
				topacertos <= 0;
				topperdidas <= 0;
				tempo <= 0;
				nivel <= 4;			
				estado_atual = nivel4;
				valor <= 0;
				num_botao <= 0;
				ResetLCD = 1;
			end
		
		endcase // fim case niveis
	
	end // fim if "passa nivel"
 
 	contador <= contador + 1;
	
	// if nivel
	if ( nivel < 4 ) begin 
 
		// PERDEUUUUUU/ERROOOOOOOU!!!
		if((KEY != 4'b1111 && KEY != casa_da_toupeira) || contador==tempo ) begin
	 
			//perdeu incrementar o contador de topeiras perdidas
			topperdidas <= topperdidas + 1;
		 
			//decrementa o contador de topeiras vivas
			topvivas <= topvivas - 1;
		 
			//zerar o contador 
			contador <= 0;

			//decrementa o valor se pontos > 0
			if (pontos < valor) begin
				pontos <= 0;
			end else begin
				pontos <= pontos - valor;
			end
		 
			//verificar se ainda tem topeira para aparecer, se tiver rodar o random dnv
			if(topvivas > 0) begin
	 
				//mudando a casa da topeira
				//TODO - IMPLEMENTAR PSEUDO-RANDOM
				if(num_botao > 3) begin
					num_botao <= 0;
				end else begin
					num_botao <= num_botao + 1;
				end
		 
				case(num_botao) 
			 
					0 : begin
						casa_da_toupeira = 4'b1110;
						ledg = 8'b00000011;
					end
			
					1 : begin
						casa_da_toupeira = 4'b1101;
						ledg = 8'b00001100;
					end
					
					2 : begin
						casa_da_toupeira = 4'b1011;
						ledg = 8'b00110000;
					end
					
					3 : begin
						casa_da_toupeira = 4'b0111;
						ledg = 8'b11000000;
					end
			 
				endcase // fim case
				
			end // fim if se ainda tem topeiras
			 
		end // fim if PERDEUUUUUU!!!
	 
		// ACERTOOOOOOOOU!!!!
		if (KEY == casa_da_toupeira) begin
	 
			//ganhou incrementar o contador
			topacertos <= topacertos + 1;
					 
			//decrementa o contador de toupeiras vivas
			topvivas <= topvivas - 1;
		 
			//zerar o contador 
			contador <= 0;

			//incrementa o valor
			pontos <= pontos + valor;
	 
			//verificar se ainda tem topeira para aparecer, se tiver rodar o random dnv
			if(topvivas > 0) begin
		  
				//mudando a casa da topeira
				//TODO - IMPLEMENTAR PSEUDO-RANDOM
				if(num_botao > 3) begin
					num_botao <= 0;
				end else begin
					num_botao <= num_botao + 1;
				end
			 
				case(num_botao)
			 
					0 : begin
						casa_da_toupeira = 4'b1110;
						ledg = 8'b00000011;
					end

					1 : begin
						casa_da_toupeira = 4'b1101;
						ledg = 8'b00001100;
					end

					2 : begin
						casa_da_toupeira = 4'b1011;
						ledg = 8'b00110000;
					end
					
					3 : begin
						casa_da_toupeira = 4'b0111;
						ledg = 8'b11000000;
					end
				 
				endcase // fim case
				
			end // fim if se ainda tem topeira para aparecer
		
		end // fim if ACERTOOOOOOOU!!!
	
	end else begin // else if nivel - entra caso fim do jogo
		
			// apaga os leds verdes no fim do jogo
			ledg = 8'b00000000;
	
	end // end if nivel
	
end // fim always
 
/*
		DISPLAY
*/
always @(*) begin
		
	case (pontos/1000) //milhar (1000)
		9'd0: hex3 = ~7'h3F;
		9'd1: hex3 = ~7'h06;
		9'd2: hex3 = ~7'h5B;
		9'd3: hex3 = ~7'h4F;
		9'd4: hex3 = ~7'h66;
		9'd5: hex3 = ~7'h6D;
		9'd6: hex3 = ~7'h7D;
		9'd7: hex3 = ~7'h07;
		9'd8: hex3 = ~7'h7F;
		9'd9: hex3 = ~7'h67;
		default:
			hex3 = blank;
	endcase
	
	case ((pontos%1000)/100) //centena (0100)
		9'd0: hex2 = ~7'h3F;
		9'd1: hex2 = ~7'h06;
		9'd2: hex2 = ~7'h5B;
		9'd3: hex2 = ~7'h4F;
		9'd4: hex2 = ~7'h66;
		9'd5: hex2 = ~7'h6D;
		9'd6: hex2 = ~7'h7D;
		9'd7: hex2 = ~7'h07;
		9'd8: hex2 = ~7'h7F;
		9'd9: hex2 = ~7'h67;
		default:
			hex2 = blank;
	endcase

	case (((pontos%1000)%100)/10) //dezena (0010)
		9'd0: hex1 = ~7'h3F;
		9'd1: hex1 = ~7'h06;
		9'd2: hex1 = ~7'h5B;
		9'd3: hex1 = ~7'h4F;
		9'd4: hex1 = ~7'h66;
		9'd5: hex1 = ~7'h6D;
		9'd6: hex1 = ~7'h7D;
		9'd7: hex1 = ~7'h07;
		9'd8: hex1 = ~7'h7F;
		9'd9: hex1 = ~7'h67;
		default:
			hex1 = blank;
	endcase
	
	/*
	case (((pontos%9'd1000)%9'd100)%9'd10) //unidade (0001)
		9'd0: hex0 = ~7'h3F;
		9'd1: hex0 = ~7'h06;
		9'd2: hex0 = ~7'h5B;
		9'd3: hex0 = ~7'h4F;
		9'd4: hex0 = ~7'h66;
		9'd5: hex0 = ~7'h6D;
		9'd6: hex0 = ~7'h7D;
		9'd7: hex0 = ~7'h07;
		9'd8: hex0 = ~7'h7F;
		9'd9: hex0 = ~7'h67;
		default:
			hex0 = ~7'h3F;
	endcase
	*/

end
 
always @(posedge CLOCK_50) begin

	/*
		CASE - TOUPEIRAS ACERTADAS
	*/
 	case (topacertos)
 
		0 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b1000000; // 0
		end
 
		1 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b1111001; // 1
		end
 
		2 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b0100100; // 2
		end
 
		3 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b0110000; // 3
		end
 
		4 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b0011001; // 4
		end
 
		5 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b0010010; // 5
		end
 
		6 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b0000010; // 6
		end
 
		7 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b1111000; // 7
		end
 
		8 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b0000000; // 8
		end
 
		9 : begin
			hex7 = 7'b1000000; // 0
			hex6 = 7'b0010000; // 9
		end
 
		10 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b1000000; // 0
		end
 
		11 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b1111001; // 1
		end
 
		12 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b0100100; // 2	
		end
 
		13 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b0110000; // 3
		end
 
		14 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b0011001; // 4
		end
 
		15 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b0010010; // 5
		end
 
		16 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b0000010; // 6
		end
 
		17 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b1111000; // 7
		end
 
		18 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b0000000; // 8
		end
 
		19 : begin
			hex7 = 7'b1111001; // 1
			hex6 = 7'b0010000; // 9
		end
 
		20 : begin
			hex7 = 7'b0100100; // 2
			hex6 = 7'b1000000; // 0
		end
 
	endcase // fim case acertos

	/*
		CASE - TOUPEIRAS DISPONIVEIS
	*/
	case (topvivas)
 
		0 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b1000000; // 0
		end
 
		1 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b1111001; // 1
		end
 
		2 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b0100100; // 2
		end
 
		3 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b0110000; // 3
		end
 
		4 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b0011001; // 4
		end
 
		5 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b0010010; // 5
		end
 
		6 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b0000010; // 6
		end
 
		7 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b1111000; // 7
		end
 
		8 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b0000000; // 8
		end
 
		9 : begin
			hex5 = 7'b1000000; // 0
			hex4 = 7'b0010000; // 9
		end
 
		10 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b1000000; // 0
		end
 
		11 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b1111001; // 1
		end
 
		12 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b0100100; // 2	
		end
 
		13 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b0110000; // 3
		end
 
		14 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b0011001; // 4
		end
 
		15 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b0010010; // 5
		end
 
		16 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b0000010; // 6
		end
 
		17 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b1111000; // 7
		end
 
		18 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b0000000; // 8
		end
 
		19 : begin
			hex5 = 7'b1111001; // 1
			hex4 = 7'b0010000; // 9
		end
 
		20 : begin
			hex5 = 7'b0100100; // 2
			hex4 = 7'b1000000; // 0
		end
 
	endcase // fim case topeiras "vivas"
 
end // fim always display

always @(posedge CLOCK_50) begin
	if (x==0) begin
		x <= 24999999;
		clock <= ~clock;
	end else begin
		x <= x - 1;
	end
end
 
endmodule
