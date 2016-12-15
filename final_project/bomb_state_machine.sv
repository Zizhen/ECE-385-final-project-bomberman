module bomb_state_machine(input Clk, Run, Reset,
								  output logic [1:0] state_index
								  //output logic [27:0] clock
);
//0: start
//1: placed
//2: explode
//3: gone
logic [27:0] count;
	enum logic [1:0] {start, placed, explode, gone} state, next_state;
	always_ff @ (posedge Clk)
	begin
		if(Reset)
			state <= start;
		else
			state <= next_state;

	end
	
	always_ff @ (posedge Clk)
	begin	
		if(state == start)
			count <= 0;
		else	
			count <= count + 1;
	end
	
	always_comb
	begin 
	next_state = state;
	
	unique case (state)
	start: if (Run)
		next_state <= placed;
	placed: if(count >= 150000000)
		next_state <= explode;
	explode: if(count >= 200000000)
		next_state <= gone;
	gone: if(!Run && count >= 201000000)
		next_state <= start;
	endcase 
	end 
	
	always@(state)
	begin 
	case(state)
	start:
		begin 
		state_index = 2'b00;
	   end
	placed:
		begin 
		state_index = 2'b01;
	   end
	explode:
		begin 
		state_index = 2'b10;
	   end
	gone:
		begin 
		state_index = 2'b11;
	   end
	endcase 
	end 
		
	
endmodule	
	