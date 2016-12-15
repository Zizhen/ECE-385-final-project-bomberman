module game_state(
		 input Clk,
		 input [15:0] keycode, keycode1,
		 input logic player_GG, player1_GG, 
		 output logic load_map, game_end
);

enum logic [1:0] {init, load_map_state, game_begin, GG} curr_state, next_state;

always_ff@(posedge Clk)
begin
	curr_state <= next_state;
end

always_comb
	begin 
	next_state = curr_state;
	unique case(curr_state)
		init: 
		if((keycode & 16'h00ff) == 16'h0029 || (keycode1 & 16'h00ff) == 16'h0029 ||
			(keycode & 16'hff00) == 16'h2900 || (keycode1 & 16'hff00) == 16'h2900 )
			next_state <= load_map_state;
		load_map_state:
			next_state <= game_begin;
		game_begin: 
		if(player_GG||player1_GG)
			next_state <= GG;
		GG:
		if((keycode & 16'h00ff) == 16'h0029 || (keycode1 & 16'h00ff) == 16'h0029 ||
			(keycode & 16'hff00) == 16'h2900 || (keycode1 & 16'hff00) == 16'h2900)
			next_state <= init;
	endcase
	end
	
always@(curr_state)
begin
	case(curr_state)
		init:begin
			load_map = 0;
			game_end = 0;
		end load_map_state: begin
			load_map = 1;
			game_end = 0;
		end game_begin: begin
			load_map = 0;
			game_end = 0;
		end GG: begin
			load_map = 1;
			game_end = 1;
		end
		endcase
end

endmodule
