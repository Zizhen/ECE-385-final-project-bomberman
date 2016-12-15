module muxNto1 (input  logic[8:0] sel,
					 input  logic[4:0] grass_in,box_in,brick_in,player_in1,bomb_in,explosion_in,player_in2,shoe_in,potion_in,
					 output logic[4:0] Dout
					 );
					 
always @ (grass_in or box_in or brick_in or player_in1 or player_in2 or bomb_in or explosion_in or shoe_in or potion_in or sel) 

begin 
if   (sel==9'b100000000)
Dout = grass_in;
else if   (sel==9'b010000000)
Dout = box_in;
else if   (sel==9'b001000000)
Dout = brick_in;
else if   (sel==9'b000100000)
Dout = player_in1;
else if   (sel==9'b000000100)
Dout = player_in2;
else if   (sel==9'b000001000)
Dout = explosion_in;
else if   (sel==9'b000000010)
Dout = shoe_in;
else if   (sel==9'b000000001)
Dout = potion_in;
else 
Dout = bomb_in;
end 

endmodule 