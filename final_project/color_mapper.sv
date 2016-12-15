//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//---------------------------------------------------------- ---------------


module  color_mapper ( input [9:0]  player1_X, player1_Y, player2_X, player2_Y, DrawX, DrawY,
							  //input [3:0] change_to, changeX, changeY,
							  input [0:12*16-1][3:0] map_array,treasure_array,
							  //input change_enable,
                       output logic [7:0]  Red, Green, Blue);
    
    logic box_on, grass_on, brick_on, player1_on, bomb_on, explosion_on, player2_on, shoe_on, potion_on;
	 logic [5:0] grass_X, grass_Y;
	 logic [5:0] box_X, box_Y;
	 logic [5:0] brick_X, brick_Y;
	 logic [5:0] player1module_X, player1module_Y, player2module_X, player2module_Y;
	 logic [5:0] bomb_X, bomb_Y;
	 logic [5:0] explosion_X, explosion_Y;
	 logic [5:0] shoe_X, shoe_Y;
	 logic [5:0] potion_X, potion_Y;
	 logic [3:0] xCoord, yCoord;
	 
	 logic [4:0] grass_color_out;
	 logic [4:0] box_color_out;
	 logic [4:0] brick_color_out;
	 logic [4:0] player1_color_out, player2_color_out;
	 logic [4:0] explosion_color_out;
	 logic [4:0] bomb_color_out;
	 logic [4:0] shoe_color_out;
	 logic [4:0] potion_color_out;
	 logic [4:0] colortable_in;
	 logic [3:0] sprite_index, treasure_index; 
	 
	 grass grass0(.grass_X, .grass_Y, .grass_color_out);
	 box box0(.box_X, .box_Y, .box_color_out);
	 brick brick0(.brick_X, .brick_Y, .brick_color_out);
	 bomb bomb0(.bomb_X,.bomb_Y,.bomb_color_out);
	 explosion explosion0(.explosion_X,.explosion_Y,.explosion_color_out);
	 player player1(.player_X(player1module_X), .player_Y(player1module_Y), .player_color_out(player1_color_out));
	 player player2(.player_X(player2module_X), .player_Y(player2module_Y), .player_color_out(player2_color_out));
	 shoe shoe0(.shoe_X,.shoe_Y,.shoe_color_out);
	 potion potion0(.potion_X,.potion_Y,.potion_color_out);
	 muxNto1 mux0(.sel({grass_on,box_on,brick_on,player1_on,bomb_on,explosion_on,player2_on,shoe_on,potion_on}),
					  .grass_in(grass_color_out),.box_in(box_color_out),
					  .brick_in(brick_color_out),.player_in1(player1_color_out),.bomb_in(bomb_color_out),
					  .explosion_in(explosion_color_out),
					  .player_in2(player2_color_out),.shoe_in(shoe_color_out),.potion_in(potion_color_out),
					  .Dout(colortable_in));
	 //end of declaring sprite modules
	 
	 colortable colortable0(.colortable_in, .Rout(Red), .Gout(Green), .Bout(Blue));
//	 map map0(.X(xCoord),.Y(yCoord),.*);
//	 assign colortable_in = temp;
	 assign grass_X = DrawX%40;
	 assign grass_Y = DrawY%40;
	 assign box_X = DrawX%40;
	 assign box_Y = DrawY%40;
	 assign brick_X = DrawX%40;
	 assign brick_Y = DrawY%40;
	 assign bomb_X = DrawX%40;
	 assign bomb_Y = DrawY%40;
	 assign explosion_X = DrawX%40;
	 assign explosion_Y = DrawY%40;
	 assign player1module_X = DrawX-player1_X+20;
	 assign player1module_Y = DrawY-player1_Y+20;
	 assign player2module_X = DrawX-player2_X+20;
	 assign player2module_Y = DrawY-player2_Y+20;
	 assign shoe_X = DrawX%40;
	 assign shoe_Y = DrawY%40;
	 assign potion_X = DrawX%40;
	 assign potion_Y = DrawY%40;
	 assign xCoord = DrawX/40;
	 assign yCoord = DrawY/40;
	 assign sprite_index = map_array[16*yCoord+xCoord];
	 assign treasure_index = treasure_array[16*yCoord+xCoord];

	 always_comb
    begin:On_What_Sprite
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if(DrawX >= player1_X-20 && DrawX < player1_X+20 && DrawY >= player1_Y-20 && DrawY < player1_Y+20)
			begin
			if(player1_color_out == 5'hf)
			begin
				if(sprite_index == 4'h3)
				begin
					if(bomb_color_out == 5'hf)
					begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b1;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
					else
					begin  
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b1;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
				end
				
				else if(treasure_index == 4'h5)
				begin
					if(shoe_color_out == 5'hf)
					begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b1;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
					else
					begin  
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b1;
						potion_on = 1'b0;
					end
				end
				
				else if(treasure_index == 4'h6)
				begin
					if(potion_color_out == 5'hf)
					begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b1;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
					else
					begin  
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b1;
					end
				end
				
				else if(sprite_index == 4'h1)
				begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b1;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
				end
				
				else if(sprite_index == 4'h2)
				begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b1;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
				
				else if(sprite_index == 4'h4)
				begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b1;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
				
				else begin
					player1_on = 1'b0;
					player2_on = 1'b0;
					grass_on = 1'b1;
					box_on = 1'b0;
					brick_on = 1'b0;
					bomb_on =1'b0;
					explosion_on = 1'b0;
					shoe_on = 1'b0;
					potion_on = 1'b0;
				end
			end
			else
				begin
					player1_on = 1'b1;
					player2_on = 1'b0;
					grass_on = 1'b0;
					box_on = 1'b0;
					brick_on = 1'b0;
					bomb_on =1'b0;
					explosion_on = 1'b0;
					shoe_on = 1'b0;
					potion_on = 1'b0;

				end
			end
			
///////////////////////////////////////////////////////////////////////////////////////////////////////////////					
			else if(DrawX >= player2_X-20 && DrawX < player2_X+20 && DrawY >= player2_Y-20 && DrawY < player2_Y+20)
			begin
			if(player2_color_out == 5'hf)
				begin
				if(sprite_index == 4'h3)begin
					if(bomb_color_out == 5'hf)
					begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b1;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
					else
					begin  
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b1;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
				end
				else if(treasure_index == 4'h5)
				begin
					if(shoe_color_out == 5'hf)
					begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b1;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
					else
					begin  
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b1;
						potion_on = 1'b0;
					end
				end
				
				else if(treasure_index == 4'h6)
				begin
					if(potion_color_out == 5'hf)
					begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b1;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
					else
					begin  
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b1;
					end
				end
				
				else if(sprite_index == 4'h1)
				begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b1;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
				end
				
				else if(sprite_index == 4'h2)
				begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b1;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
				
				else if(sprite_index == 4'h4)begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b0;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b1;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
				
				
				else begin
					player1_on = 1'b0;
					player2_on = 1'b0;
					grass_on = 1'b1;
					box_on = 1'b0;
					brick_on = 1'b0;
					bomb_on =1'b0;
					explosion_on = 1'b0;
					shoe_on = 1'b0;
					potion_on = 1'b0;
				end
				end
			else
				begin
					player1_on = 1'b0;
					player2_on = 1'b1;
					grass_on = 1'b0;
					box_on = 1'b0;
					brick_on = 1'b0;
					bomb_on =1'b0;
					explosion_on = 1'b0;
					shoe_on = 1'b0;
					potion_on = 1'b0;

				end
			end
			
			
///////////////////////////////////////////////////////////////////////////////////////////////////////////////								
			
			
			else if(sprite_index == 4'h1)
			begin
				player1_on = 1'b0;
				player2_on = 1'b0;
				grass_on = 1'b0;
				box_on = 1'b1;
				brick_on = 1'b0;
				bomb_on =1'b0;
				explosion_on = 1'b0;
				shoe_on = 1'b0;
				potion_on = 1'b0;
			end
			
			else if(sprite_index == 4'h2)
			begin
				player1_on = 1'b0;
				player2_on = 1'b0;
				grass_on = 1'b0;
				box_on = 1'b0;
				brick_on = 1'b1;
				bomb_on =1'b0;
				explosion_on = 1'b0;
				shoe_on = 1'b0;
				potion_on = 1'b0;
			end

			else if(sprite_index == 4'h3)begin
				if(bomb_color_out == 5'hf)
					begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b1;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
				else
				begin  
					player1_on = 1'b0;
					player2_on = 1'b0;
					grass_on = 1'b0;
					box_on = 1'b0;
					brick_on = 1'b0;
					bomb_on =1'b1;
					explosion_on = 1'b0;
					shoe_on = 1'b0;
					potion_on = 1'b0;
				end
			end

			else if(sprite_index == 4'h4)
			begin
				player1_on = 1'b0;
				player2_on = 1'b0;
				grass_on = 1'b0;
				box_on = 1'b0;
				brick_on = 1'b0;
				bomb_on =1'b0;
				explosion_on = 1'b1;
				shoe_on = 1'b0;
				potion_on = 1'b0;
			end
			
			else 
			begin
			
			if(treasure_index == 4'h5)begin
				if(shoe_color_out == 5'hf)
					begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b1;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
				else
				begin  
					player1_on = 1'b0;
					player2_on = 1'b0;
					grass_on = 1'b0;
					box_on = 1'b0;
					brick_on = 1'b0;
					bomb_on =1'b0;
					explosion_on = 1'b0;
					shoe_on = 1'b1;
					potion_on = 1'b0;
				end
			end
			else if(treasure_index == 4'h6)begin
				if(potion_color_out == 5'hf)
					begin
						player1_on = 1'b0;
						player2_on = 1'b0;
						grass_on = 1'b1;
						box_on = 1'b0;
						brick_on = 1'b0;
						bomb_on =1'b0;
						explosion_on = 1'b0;
						shoe_on = 1'b0;
						potion_on = 1'b0;
					end
				else
				begin  
					player1_on = 1'b0;
					player2_on = 1'b0;
					grass_on = 1'b0;
					box_on = 1'b0;
					brick_on = 1'b0;
					bomb_on =1'b0;
					explosion_on = 1'b0;
					potion_on = 1'b1;
					shoe_on = 1'b0;
				end
			end
			
			else begin
				player1_on = 1'b0;
				player2_on = 1'b0;
				grass_on = 1'b1;
				box_on = 1'b0;
				brick_on = 1'b0;
				bomb_on =1'b0;
				explosion_on = 1'b0;
				shoe_on = 1'b0;
				potion_on = 1'b0;
			end
			end

     end


endmodule
