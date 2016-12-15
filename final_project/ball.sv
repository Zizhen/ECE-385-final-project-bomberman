//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  bomberman ( input Reset, frame_clk, Clk,
					input [15:0] keycode, keycode1,
					input logic [0:12*16-1][3:0] map_array,treasure_array,
//player 1
					input logic [3:0][1:0] state_index,
					input logic [3:0] sprite_index, left_sprite_index, right_sprite_index, upper_sprite_index,lower_sprite_index,
								  upper_right_sprite_index,upper_left_sprite_index,lower_right_sprite_index,lower_left_sprite_index,
               output logic [9:0] BallX, BallY, BallS,
					output logic [3:0] LED,
					output logic [3:0][3:0] changeX, changeY,
					output logic [3:0][3:0] change_to, upper_change_to, lower_change_to, left_change_to, right_change_to,
					output logic [3:0] change_enable,explode_change_enable, Run,
					output logic [3:0] bomb_count,
//player 2					
					input logic [3:0][1:0] state_index1,
					input logic [3:0] sprite_index1, left_sprite_index1, right_sprite_index1, upper_sprite_index1,lower_sprite_index1,
								  upper_right_sprite_index1,upper_left_sprite_index1,lower_right_sprite_index1,lower_left_sprite_index1,
               output logic [9:0] BallX1, BallY1, BallS1,
					output logic [3:0] LED1,
					output logic [3:0][3:0] changeX1, changeY1,
					output logic [3:0][3:0] change_to1, upper_change_to1, lower_change_to1, left_change_to1, right_change_to1,
					output logic [3:0] change_enable1,explode_change_enable1, Run1,
					output logic [3:0] bomb_count1,
					output logic player_GG, player1_GG,
					output logic [3:0] treasure_change_X, treasure_change_Y,
					output logic [3:0] treasure_change_to,
					output logic treasure_change_enable,
					output logic [3:0] treasure_change_X1, treasure_change_Y1,
					output logic [3:0] treasure_change_to1,
					output logic treasure_change_enable1,
					output logic [1:0] player1_health, player2_health
					);
					
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 logic [9:0] LX,RX,UY,DY,LX1,RX1,UY1,DY1;
	 logic [3:0] X, Y;
	 logic [3:0][3:0] bombX, bombY;
	 logic [27:0] counter, counter1;
    logic [9:0] Ball_X_Pos1, Ball_X_Motion1, Ball_Y_Pos1, Ball_Y_Motion1, Ball_Size1;
	 logic [3:0] X1, Y1;
	 logic [3:0][3:0] bombX1, bombY1;
	 logic [2:0] player1_step, player2_step;
	 logic [2:0] player1_max_bomb, player2_max_bomb;
//	 logic [5:0] health_counter, health_counter1;
    parameter [9:0] Ball_X_Initial=20;  // Center position on the X axis
    parameter [9:0] Ball_Y_Initial=20;  // Center position on the Y axis
    parameter [9:0] Ball_X_Initial1=619;  // Center position on the X axis
    parameter [9:0] Ball_Y_Initial1=20;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=640;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=480;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 parameter [3:0] bomb_max_count=4;
	 parameter [1:0] Ball_Max_Step=3;
	 
	 assign X = Ball_X_Pos/40;
	 assign Y = Ball_Y_Pos/40;
	 assign X1 = Ball_X_Pos1/40;
	 assign Y1 = Ball_Y_Pos1/40;
    assign Ball_Size = 20;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
    assign LX = (Ball_X_Pos-15)/40;
	 assign RX = (Ball_X_Pos+15)/40;
	 assign UY = (Ball_Y_Pos-15)/40;
	 assign DY = (Ball_Y_Pos+15)/40;
    assign LX1 = (Ball_X_Pos1-15)/40;
	 assign RX1 = (Ball_X_Pos1+15)/40;
	 assign UY1 = (Ball_Y_Pos1-15)/40;
	 assign DY1 = (Ball_Y_Pos1+15)/40;


 
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
					counter <= 0;
					counter1 <= 0;
					bomb_count <= 4'b0;
					bomb_count1 <= 4'b0;
					Run <= 0;
					Run1 <= 0;
					player1_step <= 0;
					player2_step <= 0;
					player1_max_bomb <= 1;
					player2_max_bomb <= 1;
					player_GG <= 0;
					player1_GG <= 0;
					player1_health <= 3;
					player2_health <= 3;
					Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
					Ball_X_Motion <= 10'd0; //Ball_X_Step;
					Ball_Y_Pos <= Ball_Y_Initial;
					Ball_X_Pos <= Ball_X_Initial;

					Ball_Y_Motion1 <= 10'd0; //Ball_Y_Step;
					Ball_X_Motion1 <= 10'd0; //Ball_X_Step;
					Ball_Y_Pos1 <= Ball_Y_Initial1;
					Ball_X_Pos1 <= Ball_X_Initial1;
		  end
        else
		  begin
//health logic		  
		  if(player1_health == 0)begin
				player_GG = 1'b1;
				player1_GG = 1'b0;
		  end
		  if(player2_health == 0)begin
				player_GG = 1'b0;
				player1_GG = 1'b1;
		  end
		  
		  
//treasure logic	
//player1	  
		  if(treasure_array[16*Y+X] == 4'h5) begin
				change_enable <= 4'b0;
				change_enable1 <= 4'b0;
				explode_change_enable <= 4'b0;
				explode_change_enable1 <= 4'b0;
				if(player1_step < Ball_Max_Step)
					player1_step <= player1_step + 1;
				else
					player1_step <= player1_step;
				treasure_change_enable <= 1'b1;
				treasure_change_enable1 <= 1'b0;
				treasure_change_X <= X;
				treasure_change_Y <= Y;
				treasure_change_to <= 4'h0;			
		  end
		  
		  else if(treasure_array[16*Y+X] == 4'h6) begin
				change_enable <= 4'b0;
				change_enable1 <= 4'b0;
				explode_change_enable <= 4'b0;
				explode_change_enable1 <= 4'b0;
				if(player1_max_bomb < bomb_max_count) begin
					player1_max_bomb <= player1_max_bomb + 1;
				end
				else begin
					player1_max_bomb <= player1_max_bomb;
				end
				treasure_change_enable <= 1'b1;
				treasure_change_enable1 <= 1'b0;
				treasure_change_X <= X;
				treasure_change_Y <= Y;
				treasure_change_to <= 4'h0;				
		  end
//player2		  
		  if(treasure_array[16*Y1+X1] == 4'h5) begin
				change_enable <= 4'b0;
				change_enable1 <= 4'b0;
				explode_change_enable <= 4'b0;
				explode_change_enable1 <= 4'b0;
				if(player2_step < Ball_Max_Step)
					player2_step <= player2_step + 1;
				else
					player2_step <= player2_step;
				treasure_change_enable <= 1'b0;
				treasure_change_enable1 <= 1'b1;
				treasure_change_X1 <= X1;
				treasure_change_Y1 <= Y1;
				treasure_change_to1 <= 4'h0;			
		  end
		  
		  else if(map_array[16*Y1+X1] == 4'h6) begin
				change_enable <= 4'b0;
				change_enable1 <= 4'b0;
				explode_change_enable <= 4'b0;
				explode_change_enable1 <= 4'b0;
				if(player2_max_bomb < bomb_max_count) begin
					player2_max_bomb <= player2_max_bomb + 1;
				end
				else begin
					player2_max_bomb <= player2_max_bomb;
				end
				treasure_change_enable1 <= 1'b1;
				treasure_change_enable <= 1'b0;
				treasure_change_X1 <= X1;
				treasure_change_Y1 <= Y1;
				treasure_change_to1 <= 4'h0;				
		  end
		  
//position logic		  
		  if((keycode & 16'h00ff) == 16'h0007 || (keycode & 16'hff00) == 16'h0700 ||
		  (keycode1 & 16'h00ff) == 16'h0007 || (keycode1 & 16'hff00) == 16'h0700)//D
		  begin		
					counter <= 0;
					Run <= 0;
				
					Ball_Y_Motion <= 10'd0;
					Ball_X_Motion <=  Ball_X_Step+player1_step;


					if(Ball_X_Pos + Ball_Size >= Ball_X_Max)//checks boundary
						Ball_X_Pos <= Ball_X_Max - Ball_Size;
					else if(Ball_X_Pos%40 >= 20 && (right_sprite_index == 1 || right_sprite_index == 2 || right_sprite_index == 3))	
						Ball_X_Pos <= Ball_X_Pos/40*40+20;
					else if(Ball_Y_Pos%40 > 20 && Ball_X_Pos%40 >= 19 && (lower_right_sprite_index == 1 || lower_right_sprite_index == 2 || lower_right_sprite_index == 3))
						Ball_X_Pos <= Ball_X_Pos/40*40+20;
					else if(Ball_Y_Pos%40 < 20 && Ball_X_Pos%40 >= 19 && (upper_right_sprite_index == 1 || upper_right_sprite_index == 2 || upper_right_sprite_index == 3))
						Ball_X_Pos <= Ball_X_Pos/40*40+20;
					else
						Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
					LED[0] = 1'b1;
					LED[1] = 1'b0;
					LED[2] = 1'b0;
					LED[3] = 1'b0;
		  end
		  
		  else if((keycode & 16'h00ff)  == 16'h0004||(keycode & 16'hff00)  == 16'h0400||
		  (keycode1 & 16'h00ff)  == 16'h0004||(keycode1 & 16'hff00)  == 16'h0400)//A
		  begin
					counter <= 0;
					Run <= 0;
			
					Ball_Y_Motion <= 10'd0;
					Ball_X_Motion <= (~(Ball_X_Step+player1_step)+ 1'b1);
					if(Ball_X_Pos - Ball_Size <= Ball_X_Min)
						Ball_X_Pos <= Ball_X_Min + Ball_Size;
					else if(Ball_X_Pos%40 <= 20 && (left_sprite_index == 1 || left_sprite_index == 2 || left_sprite_index == 3))	
						Ball_X_Pos <= Ball_X_Pos/40*40+20;
					else if(Ball_Y_Pos%40 > 20 && Ball_X_Pos%40 <= 19 && (lower_left_sprite_index == 1 || lower_left_sprite_index == 2 || lower_left_sprite_index == 3))
						Ball_X_Pos <= Ball_X_Pos/40*40+20;
					else if(Ball_Y_Pos%40 < 20 && Ball_X_Pos%40 <= 19 && (upper_left_sprite_index == 1 || upper_left_sprite_index == 2 || upper_left_sprite_index == 3))
						Ball_X_Pos <= Ball_X_Pos/40*40+20;
					else
						Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
					LED[0] = 1'b0;
					LED[1] = 1'b1;
					LED[2] = 1'b0;
					LED[3] = 1'b0;
		  end
		  
		  else if((keycode & 16'h00ff) == 16'h001A||(keycode & 16'hff00) == 16'h1A00||
		  (keycode1 & 16'h00ff) == 16'h001A||(keycode1 & 16'hff00) == 16'h1A00)//W
		  begin
					counter <= 0;
					Run <= 0;
		
					Ball_X_Motion <= 10'd0;
					Ball_Y_Motion <= (~(Ball_Y_Step+player1_step)+ 1'b1);
					if((Ball_Y_Pos - Ball_Size) <= Ball_Y_Min)
						Ball_Y_Pos <= Ball_Y_Min + Ball_Size;
					else if(Ball_Y_Pos%40 <= 20 && (upper_sprite_index == 1 || upper_sprite_index == 2 || upper_sprite_index == 3))	
						Ball_Y_Pos <= Ball_Y_Pos/40*40+20;
					else if(Ball_X_Pos%40 > 20 && Ball_Y_Pos%40 <= 19 && (upper_right_sprite_index == 1 || upper_right_sprite_index == 2 || upper_right_sprite_index == 3))
						Ball_Y_Pos <= Ball_Y_Pos/40*40+20;
					else if(Ball_X_Pos%40 < 20 && Ball_Y_Pos%40 <= 19 && (upper_left_sprite_index == 1 || upper_left_sprite_index == 2 || upper_left_sprite_index == 3))
						Ball_Y_Pos <= Ball_Y_Pos/40*40+20;
					else
						Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
					LED[0] = 1'b0;
					LED[1] = 1'b0;
					LED[2] = 1'b1;
					LED[3] = 1'b0;
		  end
		  
		  else if((keycode & 16'h00ff) == 16'h0016||(keycode & 16'hff00) == 16'h1600||
		  (keycode1 & 16'h00ff) == 16'h0016||(keycode1 & 16'hff00) == 16'h1600)//S
		  begin
					counter <= 0;
					Run <= 0;
	
					Ball_X_Motion <= 10'd0;
					Ball_Y_Motion <= Ball_Y_Step+player1_step;
					if((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max)
						Ball_Y_Pos <= Ball_Y_Max - Ball_Size;
					else if(Ball_Y_Pos%40 >= 20 && (lower_sprite_index == 1 || lower_sprite_index == 2 || lower_sprite_index == 3))	
						Ball_Y_Pos <= Ball_Y_Pos/40*40+20;
					else if(Ball_X_Pos%40 > 20 && Ball_Y_Pos%40 >= 19 && (lower_right_sprite_index == 1 || lower_right_sprite_index == 2 || lower_right_sprite_index == 3))
						Ball_Y_Pos <= Ball_Y_Pos;
					else if(Ball_X_Pos%40 < 20 && Ball_Y_Pos%40 >= 19 && (lower_left_sprite_index == 1 || lower_left_sprite_index == 2 || lower_left_sprite_index == 3))
						Ball_Y_Pos <= Ball_Y_Pos;
					else
						Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
					LED[0] = 1'b0;
					LED[1] = 1'b0;
					LED[2] = 1'b0;
					LED[3] = 1'b1;
		  end

        else 
        begin  
				 counter <= 0;
				 Run <= 0;
				 player1_step <= player1_step;
				 player1_max_bomb <= player1_max_bomb;
				 Ball_Y_Pos <= Ball_Y_Pos;  // Update ball position
				 Ball_X_Pos <= Ball_X_Pos;
				 bomb_count <= bomb_count;
		  end
		  
		  if(((keycode & 16'h00ff) == 16'h002C||(keycode & 16'hff00) == 16'h2C00||
		  (keycode1 & 16'h00ff) == 16'h002C||(keycode1 & 16'hff00) == 16'h2C00)&& bomb_count < player1_max_bomb)//Space
		  begin
					counter <= counter + 1;
					Run[bomb_count] <= 1;
					
					bombX[bomb_count] <= X;
					bombY[bomb_count] <= Y;
					LED[0] = 1'b1;
					LED[1] = 1'b1;
					LED[2] = 1'b1;
					LED[3] = 1'b1;					
		  end

		  if(counter > 0 && (keycode & 16'h00ff) != 16'h002C && (keycode & 16'hff00) != 16'h2C00 && 
		  (keycode1 & 16'h00ff) != 16'h002C && (keycode1 & 16'hff00) != 16'h2C00)begin					
						bomb_count <= bomb_count + 1;
		  end	  

//bomb 0
		  if(state_index[0] == 2'b00)begin
				change_enable[0] <= 1'b0;
				explode_change_enable[0] <= 1'b0;
		  end
		  
		  else if(state_index[0] == 2'b01)begin //placed
				change_enable[0] <= 1'b1;
				explode_change_enable[0] <= 1'b0;
				change_to[0] <= 4'h3;
				changeX[0] <= bombX[0];
				changeY[0] <= bombY[0];
		  end
		  
		  else if(state_index[0] == 2'b10)begin //explode
				change_enable[0] <= 1'b1;
				explode_change_enable[0] <= 1'b1;
				change_to[0] <= 4'h4;
				//UPPER
				if(map_array[16*(bombY[0]-1)+bombX[0]] == 4'h0 || map_array[16*(bombY[0]-1)+bombX[0]] == 4'h1)
					upper_change_to[0] <= 4'h4;
				else
					upper_change_to[0] <= map_array[16*(bombY[0]-1)+bombX[0]];
				//LOWER	
				if(map_array[16*(bombY[0]+1)+bombX[0]] == 4'h0 || map_array[16*(bombY[0]+1)+bombX[0]] == 4'h1)
					lower_change_to[0] <= 4'h4;
				else
					lower_change_to[0] <= map_array[16*(bombY[0]+1)+bombX[0]];
				//RIGHT	
				if(bombX[0] != 15 && (map_array[16*bombY[0]+bombX[0]+1] == 4'h0 || map_array[16*bombY[0]+bombX[0]+1] == 4'h1))
					right_change_to[0] <= 4'h4;
				else 
					right_change_to[0] <= map_array[16*bombY[0]+bombX[0]+1];
				//LEFT
				if(bombX[0] != 0 && (map_array[16*bombY[0]+bombX[0]-1] == 4'h0 || map_array[16*bombY[0]+bombX[0]-1] == 4'h1))
					left_change_to[0] <= 4'h4;
				else
					left_change_to[0] <= map_array[16*bombY[0]+bombX[0]-1];
				if((LX >= (bombX[0]+1) && UY >= (bombY[0]+1)) || (LX >= bombX[0]+1 && DY <= bombY[0]-1) || LX >= bombX[0]+2|| 
					(RX <= bombX[0]-1 && UY >= bombY[0]+1) || (RX <= bombX[0]-1 && DY <= bombY[0]-1) || RX <= bombX[0]-2||
					 DY <= bombY[0]-2 || UY >= bombY[0]+2)
					player1_health <= player1_health;
				else begin
					change_enable <= 4'b0;
					explode_change_enable <= 4'b0;
					player1_health <= player1_health-1;
				end
				if((LX1 >= bombX[0]+1 && UY1 >= bombY[0]+1) || (LX1 >= bombX[0]+1 && DY1 <= bombY[0]-1) || LX1 >= bombX[0]+2|| 
					(RX1 <= bombX[0]-1 && UY1 >= bombY[0]+1) || (RX1 <= bombX[0]-1 && DY1 <= bombY[0]-1) || RX1 <= bombX[0]-2||
					 DY1 <= bombY[0]-2 || UY1 >= bombY[0]+2)
					player2_health <= player2_health;
				else begin
					change_enable <= 4'b0;
					explode_change_enable <= 4'b0;
					player2_health <= player2_health-1;
				end
				changeX[0] <= bombX[0];
				changeY[0] <= bombY[0];
		  end
		  
		  else if(state_index[0] == 2'b11)begin //gone
				change_enable[0] <= 1'b1;
				explode_change_enable[0] <= 1'b1;
				change_to[0] <= 4'h0;
				if(map_array[16*(bombY[0]-1)+bombX[0]] == 4'h4 && treasure_array[16*(bombY[0]-1)+bombX[0]]!=4'h0)
					upper_change_to[0] <= treasure_array[16*(bombY[0]-1)+bombX[0]];
				else if(map_array[16*(bombY[0]-1)+bombX[0]] == 4'h4 && treasure_array[16*(bombY[0]-1)+bombX[0]]==4'h0)
					upper_change_to[0] <= 4'h0;
				else
					upper_change_to[0] <= map_array[16*(bombY[0]-1)+bombX[0]];
					
				if(map_array[16*(bombY[0]+1)+bombX[0]] == 4'h4 && treasure_array[16*(bombY[0]+1)+bombX[0]] != 4'h0)
					lower_change_to[0] <= treasure_array[16*(bombY[0]+1)+bombX[0]];
				else if(map_array[16*(bombY[0]+1)+bombX[0]] == 4'h4 && treasure_array[16*(bombY[0]+1)+bombX[0]] == 4'h0)
					lower_change_to[0] <= 4'h0;
				else
					lower_change_to[0] <= map_array[16*(bombY[0]+1)+bombX[0]];
					
				if(map_array[16*bombY[0]+bombX[0]+1] == 4'h4 && treasure_array[16*bombY[0]+bombX[0]+1] != 4'h0)
					right_change_to[0] <= treasure_array[16*bombY[0]+bombX[0]+1];
				else if(map_array[16*bombY[0]+bombX[0]+1] == 4'h4 && treasure_array[16*bombY[0]+bombX[0]+1] == 4'h0)
					right_change_to[0] <= 4'h0;					
				else
					right_change_to[0] <= map_array[16*bombY[0]+bombX[0]+1];
					
				if(map_array[16*bombY[0]+bombX[0]-1] == 4'h4 && treasure_array[16*bombY[0]+bombX[0]-1] != 4'h0)
					left_change_to[0] <= treasure_array[16*bombY[0]+bombX[0]-1];
				else if(map_array[16*bombY[0]+bombX[0]-1] == 4'h4 && treasure_array[16*bombY[0]+bombX[0]-1] == 4'h0)
					left_change_to[0] <= 4'h0;
				else
					left_change_to[0] <= map_array[16*bombY[0]+bombX[0]-1];
					
				changeX[0] <= bombX[0];
				changeY[0] <= bombY[0];
				bomb_count <= bomb_count - 1;
		  end
		

//bomb 1
		  if(state_index[1] == 2'b00)begin
				change_enable[1] <= 1'b0;
				explode_change_enable[1] <= 1'b0;
		  end
		  
		  else if(state_index[1] == 2'b01)begin //placed
				change_enable[1] <= 1'b1;
				explode_change_enable[1] <= 1'b0;
				change_to[1] <= 4'h3;
				changeX[1] <= bombX[1];
				changeY[1] <= bombY[1];
		  end
		  
		  else if(state_index[1] == 2'b10)begin //explode
				change_enable[1] <= 1'b1;
				explode_change_enable[1] <= 1'b1;
				change_to[1] <= 4'h4;
				//UPPER
				if(map_array[16*(bombY[1]-1)+bombX[1]] == 4'h0 || map_array[16*(bombY[1]-1)+bombX[1]] == 4'h1)
					upper_change_to[1] <= 4'h4;
				else
					upper_change_to[1] <= map_array[16*(bombY[1]-1)+bombX[1]];
				//LOWER	
				if(map_array[16*(bombY[1]+1)+bombX[1]] == 4'h0 || map_array[16*(bombY[1]+1)+bombX[1]] == 4'h1)
					lower_change_to[1] <= 4'h4;
				else
					lower_change_to[1] <= map_array[16*(bombY[1]+1)+bombX[1]];
				//RIGHT	
				if(bombX[1] != 15 && (map_array[16*bombY[1]+bombX[1]+1] == 4'h0 || map_array[16*bombY[1]+bombX[1]+1] == 4'h1))
					right_change_to[1] <= 4'h4;
				else
					right_change_to[1] <= map_array[16*bombY[1]+bombX[1]+1];
				//LEFT
				if(bombX[1] != 0 && (map_array[16*bombY[1]+bombX[1]-1] == 4'h0 || map_array[16*bombY[1]+bombX[1]-1] == 4'h1))
					left_change_to[1] <= 4'h4;
				else
					left_change_to[1] <= map_array[16*bombY[1]+bombX[1]-1];
				if((LX >= bombX[1]+1 && UY >= bombY[1]+1) || (LX >= bombX[1]+1 && DY <= bombY[1]-1) || LX >= bombX[1]+2|| 
					(RX <= bombX[1]-1 && UY >= bombY[1]+1) || (RX <= bombX[1]-1 && DY <= bombY[1]-1) || RX <= bombX[1]-2||
					 DY <= bombY[1]-2 || UY >= bombY[1]+2)
					player1_health <= player1_health;
				else begin
					player1_health <= player1_health-1;
					explode_change_enable <= 4'b0;
					change_enable <= 4'b0;
				end
				if((LX1 >= bombX[1]+1 && UY1 >= bombY[1]+1) || (LX1 >= bombX[1]+1 && DY1 <= bombY[1]-1) || LX1 >= bombX[1]+2|| 
					(RX1 <= bombX[1]-1 && UY1 >= bombY[1]+1) || (RX1 <= bombX[1]-1 && DY1 <= bombY[1]-1) || RX1 <= bombX[1]-2||
					 DY1 <= bombY[1]-2 || UY1 >= bombY[1]+2)
					player2_health <= player2_health;
				else begin
					player2_health <= player2_health-1;
					explode_change_enable <= 4'b0;
					change_enable <= 4'b0;
				end
				changeX[1] <= bombX[1];
				changeY[1] <= bombY[1];
		  end
		  
		  else if(state_index[1] == 2'b11)begin //gone
				change_enable[1] <= 1'b1;
				explode_change_enable[1] <= 1'b1;
				change_to[1] <= 4'h0;
				if(map_array[16*(bombY[1]-1)+bombX[1]] == 4'h4 && treasure_array[16*(bombY[1]-1)+bombX[1]]!=4'h0)
					upper_change_to[1] <= treasure_array[16*(bombY[1]-1)+bombX[1]];
				else if(map_array[16*(bombY[1]-1)+bombX[1]] == 4'h4 && treasure_array[16*(bombY[1]-1)+bombX[1]]==4'h0)
					upper_change_to[1] <= 4'h0;
				else
					upper_change_to[1] <= map_array[16*(bombY[1]-1)+bombX[1]];
					
				if(map_array[16*(bombY[1]+1)+bombX[1]] == 4'h4 && treasure_array[16*(bombY[1]+1)+bombX[1]] != 4'h0)
					lower_change_to[1] <= treasure_array[16*(bombY[1]+1)+bombX[1]];
				else if(map_array[16*(bombY[1]+1)+bombX[1]] == 4'h4 && treasure_array[16*(bombY[1]+1)+bombX[1]] == 4'h0)
					lower_change_to[1] <= 4'h0;
				else
					lower_change_to[1] <= map_array[16*(bombY[1]+1)+bombX[1]];
					
				if(map_array[16*bombY[1]+bombX[1]+1] == 4'h4 && treasure_array[16*bombY[1]+bombX[1]+1] != 4'h0)
					right_change_to[1] <= treasure_array[16*bombY[1]+bombX[1]+1];
				else if(map_array[16*bombY[1]+bombX[1]+1] == 4'h4 && treasure_array[16*bombY[1]+bombX[1]+1] == 4'h0)
					right_change_to[1] <= 4'h0;					
				else
					right_change_to[1] <= map_array[16*bombY[1]+bombX[1]+1];
					
				if(map_array[16*bombY[1]+bombX[1]-1] == 4'h4 && treasure_array[16*bombY[1]+bombX[1]-1] != 4'h0)
					left_change_to[1] <= treasure_array[16*bombY[1]+bombX[1]-1];
				else if(map_array[16*bombY[1]+bombX[1]-1] == 4'h4 && treasure_array[16*bombY[1]+bombX[1]-1] == 4'h0)
					left_change_to[1] <= 4'h0;
				else 
					left_change_to[1] <= map_array[16*bombY[1]+bombX[1]-1];
					
				changeX[1] <= bombX[1];
				changeY[1] <= bombY[1];
				bomb_count <= bomb_count - 1;
		  end
		 

//bomb 2
		  if(state_index[2] == 2'b00)begin
				change_enable[2] <= 1'b0;
				explode_change_enable[2] <= 1'b0;
		  end
		  
		  else if(state_index[2] == 2'b01)begin //placed
				change_enable[2] <= 1'b1;
				explode_change_enable[2] <= 1'b0;
				change_to[2] <= 4'h3;
				changeX[2] <= bombX[2];
				changeY[2] <= bombY[2];
		  end
		  
		  else if(state_index[2] == 2'b10)begin //explode
				change_enable[2] <= 1'b1;
				explode_change_enable[2] <= 1'b1;
				change_to[2] <= 4'h4;
				//UPPER
				if(map_array[16*(bombY[2]-1)+bombX[2]] == 4'h0 || map_array[16*(bombY[2]-1)+bombX[2]] == 4'h1)
					upper_change_to[2] <= 4'h4;
				else
					upper_change_to[2] <= map_array[16*(bombY[2]-1)+bombX[2]];
				//LOWER	
				if(map_array[16*(bombY[2]+1)+bombX[2]] == 4'h0 || map_array[16*(bombY[2]+1)+bombX[2]] == 4'h1)
					lower_change_to[2] <= 4'h4;
				else
					lower_change_to[2] <= map_array[16*(bombY[2]+1)+bombX[2]];
				//RIGHT	
				if(bombX[2] != 15 && (map_array[16*bombY[2]+bombX[2]+1] == 4'h0 || map_array[16*bombY[2]+bombX[2]+1] == 4'h1))
					right_change_to[2] <= 4'h4;
				else
					right_change_to[2] <= map_array[16*bombY[2]+bombX[2]+1];
				//LEFT
				if(bombX[2] != 0 && (map_array[16*bombY[2]+bombX[2]-1] == 4'h0 || map_array[16*bombY[2]+bombX[2]-1] == 4'h1))
					left_change_to[2] <= 4'h4;
				else
					left_change_to[2] <= map_array[16*bombY[2]+bombX[2]-1];
				if((LX >= bombX[2]+1 && UY >= bombY[2]+1) || (LX >= bombX[2]+1 && DY <= bombY[2]-1) || LX >= bombX[2]+2|| 
					(RX <= bombX[2]-1 && UY >= bombY[2]+1) || (RX <= bombX[2]-1 && DY <= bombY[2]-1) || RX <= bombX[2]-2||
					 DY <= bombY[2]-2 || UY >= bombY[2]+2)
					player1_health <= player1_health;
				else begin
					change_enable <= 4'b0;
					explode_change_enable <= 4'b0;
					player1_health <= player1_health-1;
				end
				if((LX1 >= bombX[2]+1 && UY1 >= bombY[2]+1) || (LX1 >= bombX[2]+1 && DY1 <= bombY[2]-1) || LX1 >= bombX[2]+2|| 
					(RX1 <= bombX[2]-1 && UY1 >= bombY[2]+1) || (RX1 <= bombX[2]-1 && DY1 <= bombY[2]-1) || RX1 <= bombX[2]-2||
					 DY1 <= bombY[2]-2 || UY1 >= bombY[2]+2)
					player2_health <= player2_health;
				else begin
					player2_health <= player2_health-1;
					explode_change_enable <= 4'b0;
					change_enable <= 4'b0;
				end
				changeX[2] <= bombX[2];
				changeY[2] <= bombY[2];
		  end
		  
		  else if(state_index[2] == 2'b11)begin //gone
				change_enable[2] <= 1'b1;
				explode_change_enable[2] <= 1'b1;
				change_to[2] <= 4'h0;
				if(map_array[16*(bombY[2]-1)+bombX[2]] == 4'h4 && treasure_array[16*(bombY[2]-1)+bombX[2]]!=4'h0)
					upper_change_to[2] <= treasure_array[16*(bombY[2]-1)+bombX[2]];
				else if(map_array[16*(bombY[2]-1)+bombX[2]] == 4'h4 && treasure_array[16*(bombY[2]-1)+bombX[2]]==4'h0)
					upper_change_to[2] <= 4'h0;
				else
					upper_change_to[2] <= map_array[16*(bombY[2]-1)+bombX[2]];
					
				if(map_array[16*(bombY[2]+1)+bombX[2]] == 4'h4 && treasure_array[16*(bombY[2]+1)+bombX[2]] != 4'h0)
					lower_change_to[2] <= treasure_array[16*(bombY[2]+1)+bombX[2]];
				else if(map_array[16*(bombY[2]+1)+bombX[2]] == 4'h4 && treasure_array[16*(bombY[2]+1)+bombX[2]] == 4'h0)
					lower_change_to[2] <= 4'h0;
				else
					lower_change_to[2] <= map_array[16*(bombY[2]+1)+bombX[2]];
					
				if(map_array[16*bombY[2]+bombX[2]+1] == 4'h4 && treasure_array[16*bombY[2]+bombX[2]+1] != 4'h0)
					right_change_to[2] <= treasure_array[16*bombY[2]+bombX[2]+1];
				else if(map_array[16*bombY[2]+bombX[2]+1] == 4'h4 && treasure_array[16*bombY[2]+bombX[2]+1] == 4'h0)
					right_change_to[2] <= 4'h0;					
				else
					right_change_to[2] <= map_array[16*bombY[2]+bombX[2]+1];
					
				if(map_array[16*bombY[2]+bombX[2]-1] == 4'h4 && treasure_array[16*bombY[2]+bombX[2]-1] != 4'h0)
					left_change_to[2] <= treasure_array[16*bombY[2]+bombX[2]-1];
				else if(map_array[16*bombY[2]+bombX[2]-1] == 4'h4 && treasure_array[16*bombY[2]+bombX[2]-1] == 4'h0)
					left_change_to[2] <= 4'h0;
				else
					left_change_to[2] <= map_array[16*bombY[2]+bombX[2]-1];
					
				changeX[2] <= bombX[2];
				changeY[2] <= bombY[2];
				bomb_count <= bomb_count - 1;
		  end
		

//bomb 3
		  if(state_index[3] == 2'b00)begin
				change_enable[3] <= 1'b0;
				explode_change_enable[3] <= 1'b0;
		  end
		  
		  else if(state_index[3] == 2'b01)begin //placed
				change_enable[3] <= 1'b1;
				explode_change_enable[3] <= 1'b0;
				change_to[3] <= 4'h3;
				changeX[3] <= bombX[3];
				changeY[3] <= bombY[3];
		  end
		  
		  else if(state_index[3] == 2'b10)begin //explode
				change_enable[3] <= 1'b1;
				explode_change_enable[3] <= 1'b1;
				change_to[3] <= 4'h4;
				//UPPER
				if(map_array[16*(bombY[3]-1)+bombX[3]] == 4'h0 || map_array[16*(bombY[3]-1)+bombX[3]] == 4'h1)
					upper_change_to[3] <= 4'h4;
				else
					upper_change_to[3] <= map_array[16*(bombY[3]-1)+bombX[3]];
				//LOWER	
				if(map_array[16*(bombY[3]+1)+bombX[3]] == 4'h0 || map_array[16*(bombY[3]+1)+bombX[3]] == 4'h1)
					lower_change_to[3] <= 4'h4;
				else
					lower_change_to[3] <= map_array[16*(bombY[3]+1)+bombX[3]];
				//RIGHT	
				if(bombX[3] != 15 && (map_array[16*bombY[3]+bombX[3]+1] == 4'h0 || map_array[16*bombY[3]+bombX[3]+1] == 4'h1))
					right_change_to[3] <= 4'h4;
				else
					right_change_to[3] <= map_array[16*bombY[3]+bombX[3]+1];
				//LEFT
				if(bombX[3] != 0 && (map_array[16*bombY[3]+bombX[3]-1] == 4'h0 || map_array[16*bombY[3]+bombX[3]-1] == 4'h1))
					left_change_to[3] <= 4'h4;
				else
					left_change_to[3] <= map_array[16*bombY[3]+bombX[3]-1];
				if((LX >= bombX[3]+1 && UY >= bombY[3]+1) || (LX >= bombX[3]+1 && DY <= bombY[3]-1) || LX >= bombX[3]+2|| 
					(RX <= bombX[3]-1 && UY >= bombY[3]+1) || (RX <= bombX[3]-1 && DY <= bombY[3]-1) || RX <= bombX[3]-2||
					 DY <= bombY[3]-2 || UY >= bombY[3]+2)
					player1_health <= player1_health;
				else begin
					change_enable <= 4'b0;
					explode_change_enable <= 4'b0;
					player1_health <= player1_health-1;
				end
				if((LX1 >= bombX[3]+1 && UY1 >= bombY[3]+1) || (LX1 >= bombX[3]+1 && DY1 <= bombY[3]-1) || LX1 >= bombX[3]+2|| 
					(RX1 <= bombX[3]-1 && UY1 >= bombY[3]+1) || (RX1 <= bombX[3]-1 && DY1 <= bombY[3]-1) || RX1 <= bombX[3]-2||
					 DY1 <= bombY[3]-2 || UY1 >= bombY[3]+2)
					player2_health <= player2_health;
				else begin
					change_enable <= 4'b0;
					explode_change_enable <= 4'b0;
					player2_health <= player2_health-1;
				end
				changeX[3] <= bombX[3];
				changeY[3] <= bombY[3];
		  end
		  
		  else if(state_index[3] == 2'b11)begin //gone
				change_enable[3] <= 1'b1;
				explode_change_enable[3] <= 1'b1;
				change_to[3] <= 4'h0;
								if(map_array[16*(bombY[0]-1)+bombX[0]] == 4'h4 && treasure_array[16*(bombY[0]-1)+bombX[0]]!=4'h0)
					upper_change_to[3] <= treasure_array[16*(bombY[3]-1)+bombX[3]];
				else if(map_array[16*(bombY[3]-1)+bombX[3]] == 4'h4 && treasure_array[16*(bombY[3]-1)+bombX[3]]==4'h0)
					upper_change_to[3] <= 4'h0;
				else
					upper_change_to[3] <= map_array[16*(bombY[3]-1)+bombX[3]];
					
				if(map_array[16*(bombY[3]+1)+bombX[3]] == 4'h4 && treasure_array[16*(bombY[3]+1)+bombX[3]] != 4'h0)
					lower_change_to[3] <= treasure_array[16*(bombY[3]+1)+bombX[3]];
				else if(map_array[16*(bombY[3]+1)+bombX[3]] == 4'h4 && treasure_array[16*(bombY[3]+1)+bombX[3]] == 4'h0)
					lower_change_to[3] <= 4'h0;
				else
					lower_change_to[3] <= map_array[16*(bombY[3]+1)+bombX[3]];
					
				if(map_array[16*bombY[3]+bombX[3]+1] == 4'h4 && treasure_array[16*bombY[3]+bombX[3]+1] != 4'h0)
					right_change_to[3] <= treasure_array[16*bombY[3]+bombX[3]+1];
				else if(map_array[16*bombY[3]+bombX[3]+1] == 4'h4 && treasure_array[16*bombY[3]+bombX[3]+1] == 4'h0)
					right_change_to[3] <= 4'h0;					
				else
					right_change_to[3] <= map_array[16*bombY[3]+bombX[3]+1];
					
				if(map_array[16*bombY[3]+bombX[3]-1] == 4'h4 && treasure_array[16*bombY[3]+bombX[3]-1] != 4'h0)
					left_change_to[3] <= treasure_array[16*bombY[3]+bombX[3]-1];
				else if(map_array[16*bombY[3]+bombX[3]-1] == 4'h4 && treasure_array[16*bombY[3]+bombX[3]-1] == 4'h0)
					left_change_to[3] <= 4'h0;
				else
					left_change_to[3] <= map_array[16*bombY[3]+bombX[3]-1];
					
				changeX[3] <= bombX[3];
				changeY[3] <= bombY[3];
				bomb_count <= bomb_count - 1;
		  end
	
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////


if((keycode & 16'h00ff) == 16'h004f || (keycode & 16'hff00) == 16'h4f00 ||
		  (keycode1 & 16'h00ff) == 16'h004f || (keycode1 & 16'hff00) == 16'h4f00)//right
		  begin		
					counter1 <= 0;
					Run1 <= 0;
				
					Ball_Y_Motion1 <= 10'd0;
					Ball_X_Motion1 <=  Ball_X_Step+player2_step;


					if(Ball_X_Pos1 + Ball_Size >= Ball_X_Max)//checks boundary
						Ball_X_Pos1 <= Ball_X_Max - Ball_Size;
					else if(Ball_X_Pos1%40 >= 20 && (right_sprite_index1 == 1 || right_sprite_index1 == 2 || right_sprite_index1 == 3))	
						Ball_X_Pos1 <= Ball_X_Pos1/40*40+20;
					else if(Ball_Y_Pos1%40 > 20 && Ball_X_Pos1%40 >= 19 && (lower_right_sprite_index1 == 1 || lower_right_sprite_index1 == 2 || lower_right_sprite_index1 == 3))
						Ball_X_Pos1 <= Ball_X_Pos1/40*40+20;
					else if(Ball_Y_Pos1%40 < 20 && Ball_X_Pos1%40 >= 19 && (upper_right_sprite_index1 == 1 || upper_right_sprite_index1 == 2 || upper_right_sprite_index1 == 3))
						Ball_X_Pos1 <= Ball_X_Pos1/40*40+20;
					else
						Ball_X_Pos1 <= (Ball_X_Pos1 + Ball_X_Motion1);
					LED1[0] = 1'b1;
					LED1[1] = 1'b0;
					LED1[2] = 1'b0;
					LED1[3] = 1'b0;
		  end
		  
		  else if((keycode & 16'h00ff)  == 16'h0050||(keycode & 16'hff00)  == 16'h5000||
		  (keycode1 & 16'h00ff)  == 16'h0050||(keycode1 & 16'hff00)  == 16'h5000)//left
		  begin
					counter1 <= 0;
					Run1 <= 0;
			
					Ball_Y_Motion1 <= 10'd0;
					Ball_X_Motion1 <= (~(Ball_X_Step+player2_step)+ 1'b1);
					if(Ball_X_Pos1 - Ball_Size <= Ball_X_Min)
						Ball_X_Pos1 <= Ball_X_Min + Ball_Size;
					else if(Ball_X_Pos1%40 <= 20 && (left_sprite_index1 == 1 || left_sprite_index1 == 2 || left_sprite_index1 == 3))	
						Ball_X_Pos1 <= Ball_X_Pos1/40*40+20;
					else if(Ball_Y_Pos1%40 > 20 && Ball_X_Pos1%40 <= 19 && (lower_left_sprite_index1 == 1 || lower_left_sprite_index1 == 2 || lower_left_sprite_index1 == 3))
						Ball_X_Pos1 <= Ball_X_Pos1/40*40+20;
					else if(Ball_Y_Pos1%40 < 20 && Ball_X_Pos1%40 <= 19 && (upper_left_sprite_index1 == 1 || upper_left_sprite_index1 == 2 || upper_left_sprite_index1 == 3))
						Ball_X_Pos1 <= Ball_X_Pos1/40*40+20;
					else
					Ball_X_Pos1 <= (Ball_X_Pos1 + Ball_X_Motion1);
					LED1[0] = 1'b0;
					LED1[1] = 1'b1;
					LED1[2] = 1'b0;
					LED1[3] = 1'b0;
		  end
		  
		  else if((keycode & 16'h00ff) == 16'h0052||(keycode & 16'hff00) == 16'h5200||
		  (keycode1 & 16'h00ff) == 16'h0052||(keycode1 & 16'hff00) == 16'h5200)//up
		  begin
					counter1 <= 0;
					Run1 <= 0;
		
					Ball_X_Motion1 <= 10'd0;
					Ball_Y_Motion1 <= (~(Ball_Y_Step+player2_step)+ 1'b1);
					if((Ball_Y_Pos1 - Ball_Size) <= Ball_Y_Min)
						Ball_Y_Pos1 <= Ball_Y_Min + Ball_Size;
					else if(Ball_Y_Pos1%40 <= 20 && (upper_sprite_index1 == 1 || upper_sprite_index1 == 2 || upper_sprite_index1 == 3))	
						Ball_Y_Pos1 <= Ball_Y_Pos1/40*40+20;
					else if(Ball_X_Pos1%40 > 20 && Ball_Y_Pos1%40 <= 19 && (upper_right_sprite_index1 == 1 || upper_right_sprite_index1 == 2 || upper_right_sprite_index1 == 3))
						Ball_Y_Pos1 <= Ball_Y_Pos1/40*40+20;
					else if(Ball_X_Pos1%40 < 20 && Ball_Y_Pos1%40 <= 19 && (upper_left_sprite_index1 == 1 || upper_left_sprite_index1 == 2 || upper_left_sprite_index1 == 3))
						Ball_Y_Pos1 <= Ball_Y_Pos1/40*40+20;
					else
						Ball_Y_Pos1 <= (Ball_Y_Pos1 + Ball_Y_Motion1);
					LED1[0] = 1'b0;
					LED1[1] = 1'b0;
					LED1[2] = 1'b1;
					LED1[3] = 1'b0;
		  end
		  
		  else if((keycode & 16'h00ff) == 16'h0051||(keycode & 16'hff00) == 16'h5100||
		  (keycode1 & 16'h00ff) == 16'h0051||(keycode1 & 16'hff00) == 16'h5100)//down
		  begin
					counter1 <= 0;
					Run1 <= 0;
	
					Ball_X_Motion1 <= 10'd0;
					Ball_Y_Motion1 <= Ball_Y_Step+player2_step;
					if((Ball_Y_Pos1 + Ball_Size) >= Ball_Y_Max+1)
						Ball_Y_Pos1 <= Ball_Y_Max - Ball_Size + 1;
					else if(Ball_Y_Pos1%40 >= 20 && (lower_sprite_index1 == 1 || lower_sprite_index1 == 2 || lower_sprite_index1 == 3))	
						Ball_Y_Pos1 <= Ball_Y_Pos1/40*40+20;
					else if(Ball_X_Pos1%40 > 20 && Ball_Y_Pos1%40 >= 19 && (lower_right_sprite_index1 == 1 || lower_right_sprite_index1 == 2 || lower_right_sprite_index1 == 3))
						Ball_Y_Pos1 <= Ball_Y_Pos1/40*40+20;
					else if(Ball_X_Pos1%40 < 20 && Ball_Y_Pos1%40 >= 19 && (lower_left_sprite_index1 == 1 || lower_left_sprite_index1 == 2 || lower_left_sprite_index1 == 3))
						Ball_Y_Pos1 <= Ball_Y_Pos1/40*40+20;
					else
						Ball_Y_Pos1 <= (Ball_Y_Pos1 + Ball_Y_Motion1);
					LED1[0] = 1'b0;
					LED1[1] = 1'b0;
					LED1[2] = 1'b0;
					LED1[3] = 1'b1;
		  end

        else 
        begin  
				 counter1 <= 0;
				 Run1 <= 0;
				 player2_step <= player2_step;
				 player2_max_bomb <= player2_max_bomb;

				 Ball_Y_Pos1 <= Ball_Y_Pos1;  // Update ball position
				 Ball_X_Pos1 <= Ball_X_Pos1;
				 bomb_count1 <= bomb_count1;
		  end
		  
		  if(((keycode & 16'h00ff) == 16'h0028||(keycode & 16'hff00) == 16'h2800||
		  (keycode1 & 16'h00ff) == 16'h0028||(keycode1 & 16'hff00) == 16'h2800)&& bomb_count1 < player2_max_bomb)//Enter
		  begin
					counter1 <= counter1 + 1;
					Run1[bomb_count1] <= 1;
					
					bombX1[bomb_count1] <= X1;
					bombY1[bomb_count1] <= Y1;
					LED1[0] = 1'b1;
					LED1[1] = 1'b1;
					LED1[2] = 1'b1;
					LED1[3] = 1'b1;					
		  end

		  if(counter1 > 0 && (keycode & 16'h00ff) != 16'h0028 && (keycode & 16'hff00) != 16'h2800 && 
		  (keycode1 & 16'h00ff) != 16'h0028 && (keycode1 & 16'hff00) != 16'h2800)begin					
						bomb_count1 <= bomb_count1 + 1;
		  end	  

//bomb 0
		  if(state_index1[0] == 2'b00)begin
				change_enable1[0] <= 1'b0;
				explode_change_enable1[0] <= 1'b0;
		  end
		  
		  else if(state_index1[0] == 2'b01)begin //placed
				change_enable1[0] <= 1'b1;
				explode_change_enable1[0] <= 1'b0;
				change_to1[0] <= 4'h3;
				changeX1[0] <= bombX1[0];
				changeY1[0] <= bombY1[0];
		  end
		  
		  else if(state_index1[0] == 2'b10)begin //explode
				change_enable1[0] <= 1'b1;
				explode_change_enable1[0] <= 1'b1;
				change_to1[0] <= 4'h4;
				//UPPER
				if(map_array[16*(bombY1[0]-1)+bombX1[0]] == 4'h0 || map_array[16*(bombY1[0]-1)+bombX1[0]] == 4'h1)
					upper_change_to1[0] <= 4'h4;
				else
					upper_change_to1[0] <= map_array[16*(bombY1[0]-1)+bombX1[0]];
				//LOWER	
				if(map_array[16*(bombY1[0]+1)+bombX1[0]] == 4'h0 || map_array[16*(bombY1[0]+1)+bombX1[0]] == 4'h1)
					lower_change_to1[0] <= 4'h4;
				else
					lower_change_to1[0] <= map_array[16*(bombY1[0]+1)+bombX1[0]];
				//RIGHT	
				if(bombX1[0] != 15 && (map_array[16*bombY1[0]+bombX1[0]+1] == 4'h0 || map_array[16*bombY1[0]+bombX1[0]+1] == 4'h1))
					right_change_to1[0] <= 4'h4;
				else
					right_change_to1[0] <= map_array[16*bombY1[0]+bombX1[0]+1];
				//LEFT
				if(bombX1[0] != 0 && (map_array[16*bombY1[0]+bombX1[0]-1] == 4'h0 || map_array[16*bombY1[0]+bombX1[0]-1] == 4'h1))
					left_change_to1[0] <= 4'h4;
				else
					left_change_to1[0] <= map_array[16*bombY1[0]+bombX1[0]-1];
				if((LX >= bombX1[0]+1 && UY >= bombY1[0]+1) || (LX >= bombX1[0]+1 && DY <= bombY1[0]-1) || LX >= bombX1[0]+2|| 
					(RX <= bombX1[0]-1 && UY >= bombY1[0]+1) || (RX <= bombX1[0]-1 && DY <= bombY1[0]-1) || RX <= bombX1[0]-2||
					 DY <= bombY1[0]-2 || UY >= bombY1[0]+2)
					player1_health <= player1_health;
				else begin
					explode_change_enable1 <= 4'b0;
					change_enable1 <= 4'b0;
					player1_health <= player1_health-1;
				end
				if((LX1 >= bombX1[0]+1 && UY1 >= bombY1[0]+1) || (LX1 >= bombX1[0]+1 && DY1 <= bombY1[0]-1) || LX1 >= bombX1[0]+2|| 
					(RX1 <= bombX1[0]-1 && UY1 >= bombY1[0]+1) || (RX1 <= bombX1[0]-1 && DY1 <= bombY1[0]-1) || RX1 <= bombX1[0]-2||
					 DY1 <= bombY1[0]-2 || UY1 >= bombY1[0]+2)
					player2_health <= player2_health;
				else begin
					explode_change_enable1 <= 4'b0;
					change_enable1 <= 4'b0;
					player2_health <= player2_health-1;
				end
				changeX1[0] <= bombX1[0];
				changeY1[0] <= bombY1[0];
		  end
		  
		  else if(state_index1[0] == 2'b11)begin //gone
				change_enable1[0] <= 1'b1;
				explode_change_enable1[0] <= 1'b1;
				change_to1[0] <= 4'h0;
				if(map_array[16*(bombY1[0]-1)+bombX1[0]] == 4'h4 && treasure_array[16*(bombY1[0]-1)+bombX1[0]]!=4'h0)
					upper_change_to1[0] <= treasure_array[16*(bombY1[0]-1)+bombX1[0]];
				else if(map_array[16*(bombY1[0]-1)+bombX1[0]] == 4'h4 && treasure_array[16*(bombY1[0]-1)+bombX1[0]]==4'h0)
					upper_change_to1[0] <= 4'h0;
				else
					upper_change_to1[0] <= map_array[16*(bombY1[0]-1)+bombX1[0]];
					
				if(map_array[16*(bombY1[0]+1)+bombX1[0]] == 4'h4 && treasure_array[16*(bombY1[0]+1)+bombX1[0]] != 4'h0)
					lower_change_to1[0] <= treasure_array[16*(bombY1[0]+1)+bombX1[0]];
				else if(map_array[16*(bombY1[0]+1)+bombX1[0]] == 4'h4 && treasure_array[16*(bombY1[0]+1)+bombX1[0]] == 4'h0)
					lower_change_to1[0] <= 4'h0;
				else
					lower_change_to1[0] <= map_array[16*(bombY1[0]+1)+bombX1[0]];
					
				if(map_array[16*bombY1[0]+bombX1[0]+1] == 4'h4 && treasure_array[16*bombY1[0]+bombX1[0]+1] != 4'h0)
					right_change_to1[0] <= treasure_array[16*bombY1[0]+bombX1[0]+1];
				else if(map_array[16*bombY1[0]+bombX1[0]+1] == 4'h4 && treasure_array[16*bombY1[0]+bombX1[0]+1] == 4'h0)
					right_change_to1[0] <= 4'h0;					
				else
					right_change_to1[0] <= map_array[16*bombY1[0]+bombX1[0]+1];
					
				if(map_array[16*bombY1[0]+bombX1[0]-1] == 4'h4 && treasure_array[16*bombY1[0]+bombX1[0]-1] != 4'h0)
					left_change_to1[0] <= treasure_array[16*bombY1[0]+bombX1[0]-1];
				else if(map_array[16*bombY1[0]+bombX1[0]-1] == 4'h4 && treasure_array[16*bombY1[0]+bombX1[0]-1] == 4'h0)
					left_change_to1[0] <= 4'h0;
				else
					left_change_to1[0] <= map_array[16*bombY1[0]+bombX1[0]-1];
				changeX1[0] <= bombX1[0];
				changeY1[0] <= bombY1[0];
				bomb_count1 <= bomb_count1 - 1;
		  end
		

//bomb 1
		  if(state_index1[1] == 2'b00)begin
				change_enable1[1] <= 1'b0;
				explode_change_enable1[1] <= 1'b0;
		  end
		  
		  else if(state_index1[1] == 2'b01)begin //placed
				change_enable1[1] <= 1'b1;
				explode_change_enable1[1] <= 1'b0;
				change_to1[1] <= 4'h3;
				changeX1[1] <= bombX1[1];
				changeY1[1] <= bombY1[1];
		  end
		  
		  else if(state_index1[1] == 2'b10)begin //explode
				change_enable1[1] <= 1'b1;
				explode_change_enable1[1] <= 1'b1;
				change_to1[1] <= 4'h4;
				//UPPER
				if(map_array[16*(bombY1[1]-1)+bombX1[1]] == 4'h0 || map_array[16*(bombY1[1]-1)+bombX1[1]] == 4'h1)
					upper_change_to1[1] <= 4'h4;
				else
					upper_change_to1[1] <= map_array[16*(bombY1[1]-1)+bombX1[1]];
				//LOWER	
				if(map_array[16*(bombY1[1]+1)+bombX1[1]] == 4'h0 || map_array[16*(bombY1[1]+1)+bombX1[1]] == 4'h1)
					lower_change_to1[1] <= 4'h4;
				else
					lower_change_to1[1] <= map_array[16*(bombY1[1]+1)+bombX1[1]];
				//RIGHT	
				if(bombX1[1] != 15 && (map_array[16*bombY1[1]+bombX1[1]+1] == 4'h0 || map_array[16*bombY1[1]+bombX1[1]+1] == 4'h1))
					right_change_to1[1] <= 4'h4;
				else
					right_change_to1[1] <= map_array[16*bombY1[1]+bombX1[1]+1];
				//LEFT
				if(bombX1[1] != 0 && (map_array[16*bombY1[1]+bombX1[1]-1] == 4'h0 || map_array[16*bombY1[1]+bombX1[1]-1] == 4'h1))
					left_change_to1[1] <= 4'h4;
				else
					left_change_to1[1] <= map_array[16*bombY1[1]+bombX1[1]-1];
				if((LX >= bombX1[1]+1 && UY >= bombY1[1]+1) || (LX >= bombX1[1]+1 && DY <= bombY1[1]-1) || LX >= bombX1[1]+2|| 
					(RX <= bombX1[1]-1 && UY >= bombY1[1]+1) || (RX <= bombX1[1]-1 && DY <= bombY1[1]-1) || RX <= bombX1[1]-2||
					 DY <= bombY1[1]-2 || UY >= bombY1[1]+2)
					player1_health <= player1_health;
				else begin
					explode_change_enable1 <= 4'b0;
					change_enable1 <= 4'b0;
					player1_health <= player1_health-1;
				end
				if((LX1 >= bombX1[1]+1 && UY1 >= bombY1[1]+1) || (LX1 >= bombX1[1]+1 && DY1 <= bombY1[1]-1) || LX1 >= bombX1[1]+2|| 
					(RX1 <= bombX1[1]-1 && UY1 >= bombY1[1]+1) || (RX1 <= bombX1[1]-1 && DY1 <= bombY1[1]-1) || RX1 <= bombX1[1]-2||
					 DY1 <= bombY1[1]-2 || UY1 >= bombY1[1]+2)
					player2_health <= player2_health;
				else begin
					explode_change_enable1 <= 4'b0;
					change_enable1 <= 4'b0;
					player2_health <= player2_health-1;
				end
				changeX1[1] <= bombX1[1];
				changeY1[1] <= bombY1[1];
		  end
		  
		  else if(state_index1[1] == 2'b11)begin //gone
				change_enable1[1] <= 1'b1;
				explode_change_enable1[1] <= 1'b1;
				change_to1[1] <= 4'h0;
				if(map_array[16*(bombY1[1]-1)+bombX1[1]] == 4'h4 && treasure_array[16*(bombY1[1]-1)+bombX1[1]]!=4'h0)
					upper_change_to1[1] <= treasure_array[16*(bombY1[1]-1)+bombX1[1]];
				else if(map_array[16*(bombY1[1]-1)+bombX1[1]] == 4'h4 && treasure_array[16*(bombY1[1]-1)+bombX1[1]]==4'h0)
					upper_change_to1[1] <= 4'h0;
				else
					upper_change_to1[1] <= map_array[16*(bombY1[1]-1)+bombX1[1]];
					
				if(map_array[16*(bombY1[1]+1)+bombX1[1]] == 4'h4 && treasure_array[16*(bombY1[1]+1)+bombX1[1]] != 4'h0)
					lower_change_to1[1] <= treasure_array[16*(bombY1[1]+1)+bombX1[1]];
				else if(map_array[16*(bombY1[1]+1)+bombX1[1]] == 4'h4 && treasure_array[16*(bombY1[1]+1)+bombX1[1]] == 4'h0)
					lower_change_to1[1] <= 4'h0;
				else
					lower_change_to1[1] <= map_array[16*(bombY1[1]+1)+bombX1[1]];
					
				if(map_array[16*bombY1[1]+bombX1[1]+1] == 4'h4 && treasure_array[16*bombY1[1]+bombX1[1]+1] != 4'h0)
					right_change_to1[1] <= treasure_array[16*bombY1[1]+bombX1[1]+1];
				else if(map_array[16*bombY1[1]+bombX1[1]+1] == 4'h4 && treasure_array[16*bombY1[1]+bombX1[1]+1] == 4'h0)
					right_change_to1[1] <= 4'h0;					
				else
					right_change_to1[1] <= map_array[16*bombY1[1]+bombX1[1]+1];
					
				if(map_array[16*bombY1[1]+bombX1[1]-1] == 4'h4 && treasure_array[16*bombY1[1]+bombX1[1]-1] != 4'h0)
					left_change_to1[1] <= treasure_array[16*bombY1[1]+bombX1[1]-1];
				else if(map_array[16*bombY1[1]+bombX1[1]-1] == 4'h4 && treasure_array[16*bombY1[1]+bombX1[1]-1] == 4'h0)
					left_change_to1[1] <= 4'h0;
				else
					left_change_to1[1] <= map_array[16*bombY1[1]+bombX1[1]-1];
				changeX1[1] <= bombX1[1];
				changeY1[1] <= bombY1[1];
				bomb_count1 <= bomb_count1 - 1;
		  end
		 

//bomb 2
		  if(state_index1[2] == 2'b00)begin
				change_enable1[2] <= 1'b0;
				explode_change_enable1[2] <= 1'b0;
		  end
		  
		  else if(state_index1[2] == 2'b01)begin //placed
				change_enable1[2] <= 1'b1;
				explode_change_enable1[2] <= 1'b0;
				change_to1[2] <= 4'h3;
				changeX1[2] <= bombX1[2];
				changeY1[2] <= bombY1[2];
		  end
		  
		  else if(state_index1[2] == 2'b10)begin //explode
				change_enable1[2] <= 1'b1;
				explode_change_enable1[2] <= 1'b1;
				change_to1[2] <= 4'h4;
				//UPPER
				if(map_array[16*(bombY1[2]-1)+bombX1[2]] == 4'h0 || map_array[16*(bombY1[2]-1)+bombX1[2]] == 4'h1)
					upper_change_to1[2] <= 4'h4;
				else
					upper_change_to1[2] <= map_array[16*(bombY1[2]-1)+bombX1[2]];
				//LOWER	
				if(map_array[16*(bombY1[2]+1)+bombX1[2]] == 4'h0 || map_array[16*(bombY1[2]+1)+bombX1[2]] == 4'h1)
					lower_change_to1[2] <= 4'h4;
				else
					lower_change_to1[2] <= map_array[16*(bombY1[2]+1)+bombX1[2]];
				//RIGHT	
				if(bombX1[2] != 15 && (map_array[16*bombY1[2]+bombX1[2]+1] == 4'h0 || map_array[16*bombY1[2]+bombX1[2]+1] == 4'h1))
					right_change_to1[2] <= 4'h4;
				else
					right_change_to1[2] <= map_array[16*bombY1[2]+bombX1[2]+1];
				//LEFT
				if(bombX1[2] != 0 && (map_array[16*bombY1[2]+bombX1[2]-1] == 4'h0 || map_array[16*bombY1[2]+bombX1[2]-1] == 4'h1))
					left_change_to1[2] <= 4'h4;
				else
					left_change_to1[2] <= map_array[16*bombY1[2]+bombX1[2]-1];
				if((LX >= bombX1[2]+1 && UY >= bombY1[2]+1) || (LX >= bombX1[2]+1 && DY <= bombY1[2]-1) || LX >= bombX1[2]+2|| 
					(RX <= bombX1[2]-1 && UY >= bombY1[2]+1) || (RX <= bombX1[2]-1 && DY <= bombY1[2]-1) || RX <= bombX1[2]-2||
					 DY <= bombY1[2]-2 || UY >= bombY1[2]+2)
					player1_health <= player1_health;
				else begin
					explode_change_enable1 <= 4'b0;
					change_enable1 <= 4'b0;
					player1_health <= player1_health-1;
				end
				if((LX1 >= bombX1[2]+1 && UY1 >= bombY1[2]+1) || (LX1 >= bombX1[2]+1 && DY1 <= bombY1[2]-1) || LX1 >= bombX1[2]+2|| 
					(RX1 <= bombX1[2]-1 && UY1 >= bombY1[2]+1) || (RX1 <= bombX1[2]-1 && DY1 <= bombY1[2]-1) || RX1 <= bombX1[2]-2||
					 DY1 <= bombY1[2]-2 || UY1 >= bombY1[2]+2)
					player2_health <= player2_health;
				else begin
					explode_change_enable1 <= 4'b0;
					change_enable1 <= 4'b0;
					player2_health <= player2_health-1;
				end
				changeX1[2] <= bombX1[2];
				changeY1[2] <= bombY1[2];
		  end
		  
		  else if(state_index1[2] == 2'b11)begin //gone
				change_enable1[2] <= 1'b1;
				explode_change_enable1[2] <= 1'b1;
				change_to1[2] <= 4'h0;
				if(map_array[16*(bombY1[2]-1)+bombX1[2]] == 4'h4 && treasure_array[16*(bombY1[2]-1)+bombX1[2]]!=4'h0)
					upper_change_to1[2] <= treasure_array[16*(bombY1[2]-1)+bombX1[2]];
				else if(map_array[16*(bombY1[2]-1)+bombX1[2]] == 4'h4 && treasure_array[16*(bombY1[2]-1)+bombX1[2]]==4'h0)
					upper_change_to1[2] <= 4'h0;
				else
					upper_change_to1[2] <= map_array[16*(bombY1[2]-1)+bombX1[2]];
					
				if(map_array[16*(bombY1[2]+1)+bombX1[2]] == 4'h4 && treasure_array[16*(bombY1[2]+1)+bombX1[2]] != 4'h0)
					lower_change_to1[2] <= treasure_array[16*(bombY1[2]+1)+bombX1[2]];
				else if(map_array[16*(bombY1[2]+1)+bombX1[2]] == 4'h4 && treasure_array[16*(bombY1[2]+1)+bombX1[2]] == 4'h0)
					lower_change_to1[2] <= 4'h0;
				else
					lower_change_to1[2] <= map_array[16*(bombY1[2]+1)+bombX1[2]];
					
				if(map_array[16*bombY1[2]+bombX1[2]+1] == 4'h4 && treasure_array[16*bombY1[2]+bombX1[2]+1] != 4'h0)
					right_change_to1[2] <= treasure_array[16*bombY1[2]+bombX1[2]+1];
				else if(map_array[16*bombY1[2]+bombX1[2]+1] == 4'h4 && treasure_array[16*bombY1[2]+bombX1[2]+1] == 4'h0)
					right_change_to1[2] <= 4'h0;					
				else
					right_change_to1[2] <= map_array[16*bombY1[2]+bombX1[2]+1];
					
				if(map_array[16*bombY1[2]+bombX1[2]-1] == 4'h4 && treasure_array[16*bombY1[2]+bombX1[2]-1] != 4'h0)
					left_change_to1[2] <= treasure_array[16*bombY1[2]+bombX1[2]-1];
				else if(map_array[16*bombY1[2]+bombX1[2]-1] == 4'h4 && treasure_array[16*bombY1[2]+bombX1[2]-1] == 4'h0)
					left_change_to1[2] <= 4'h0;
				else
					left_change_to1[2] <= map_array[16*bombY1[2]+bombX1[2]-1];
				changeX1[2] <= bombX1[2];
				changeY1[2] <= bombY1[2];
				bomb_count1 <= bomb_count1 - 1;
		  end
		

//bomb 3
		  if(state_index1[3] == 2'b00)begin
				change_enable1[3] <= 1'b0;
				explode_change_enable1[3] <= 1'b0;
		  end
		  
		  else if(state_index1[3] == 2'b01)begin //placed
				change_enable1[3] <= 1'b1;
				explode_change_enable1[3] <= 1'b0;
				change_to1[3] <= 4'h3;
				changeX1[3] <= bombX1[3];
				changeY1[3] <= bombY1[3];
		  end
		  
		  else if(state_index1[3] == 2'b10)begin //explode
				change_enable1[3] <= 1'b1;
				explode_change_enable1[3] <= 1'b1;
				change_to1[3] <= 4'h4;
				//UPPER
				if(map_array[16*(bombY1[3]-1)+bombX1[3]] == 4'h0 || map_array[16*(bombY1[3]-1)+bombX1[3]] == 4'h1)
					upper_change_to1[3] <= 4'h4;
				else
					upper_change_to1[3] <= map_array[16*(bombY1[3]-1)+bombX1[3]];
				//LOWER	
				if(map_array[16*(bombY1[3]+1)+bombX1[3]] == 4'h0 || map_array[16*(bombY1[3]+1)+bombX1[3]] == 4'h1)
					lower_change_to1[3] <= 4'h4;
				else
					lower_change_to1[3] <= map_array[16*(bombY1[3]+1)+bombX1[3]];
				//RIGHT	
				if(bombX1[3] != 15 && (map_array[16*bombY1[3]+bombX1[3]+1] == 4'h0 || map_array[16*bombY1[3]+bombX1[3]+1] == 4'h1))
					right_change_to1[3] <= 4'h4;
				else
					right_change_to1[3] <= map_array[16*bombY1[3]+bombX1[3]+1];
				//LEFT
				if(bombX1[3] != 0 && (map_array[16*bombY1[3]+bombX1[3]-1] == 4'h0 || map_array[16*bombY1[3]+bombX1[3]-1] == 4'h1))
					left_change_to1[3] <= 4'h4;
				else
					left_change_to1[3] <= map_array[16*bombY1[3]+bombX1[3]-1];
				if((LX >= bombX1[3]+1 && UY >= bombY1[3]+1) || (LX >= bombX1[3]+1 && DY <= bombY1[3]-1) || LX >= bombX1[3]+2|| 
					(RX <= bombX1[3]-1 && UY >= bombY1[3]+1) || (RX <= bombX1[3]-1 && DY <= bombY1[3]-1) || RX <= bombX1[3]-2||
					 DY <= bombY1[3]-2 || UY >= bombY1[3]+2)
					player1_health <= player1_health;
				else begin
					explode_change_enable1 <= 4'b0;
					change_enable1 <= 4'b0;
					player1_health <= player1_health-1;
				end
				if((LX1 >= bombX1[3]+1 && UY1 >= bombY1[3]+1) || (LX1 >= bombX1[3]+1 && DY1 <= bombY1[3]-1) || LX1 >= bombX1[3]+2|| 
					(RX1 <= bombX1[3]-1 && UY1 >= bombY1[3]+1) || (RX1 <= bombX1[3]-1 && DY1 <= bombY1[3]-1) || RX1 <= bombX1[3]-2||
					 DY1 <= bombY1[3]-2 || UY1 >= bombY1[3]+2)
					player2_health <= player2_health;
				else begin
					explode_change_enable1 <= 4'b0;
					change_enable1 <= 4'b0;
					player2_health <= player2_health-1;
				end
				changeX1[3] <= bombX1[3];
				changeY1[3] <= bombY1[3];
		  end
		  
		  else if(state_index1[3] == 2'b11)begin //gone
				change_enable1[3] <= 1'b1;
				explode_change_enable1[3] <= 1'b1;
				change_to1[3] <= 4'h0;
				if(map_array[16*(bombY1[3]-1)+bombX1[3]] == 4'h4 && treasure_array[16*(bombY1[3]-1)+bombX1[3]]!=4'h0)
					upper_change_to1[3] <= treasure_array[16*(bombY1[3]-1)+bombX1[3]];
				else if(map_array[16*(bombY1[3]-1)+bombX1[3]] == 4'h4 && treasure_array[16*(bombY1[3]-1)+bombX1[3]]==4'h0)
					upper_change_to1[3] <= 4'h0;
				else
					upper_change_to1[3] <= map_array[16*(bombY1[3]-1)+bombX1[3]];
					
				if(map_array[16*(bombY1[3]+1)+bombX1[3]] == 4'h4 && treasure_array[16*(bombY1[3]+1)+bombX1[3]] != 4'h0)
					lower_change_to1[3] <= treasure_array[16*(bombY1[3]+1)+bombX1[3]];
				else if(map_array[16*(bombY1[3]+1)+bombX1[3]] == 4'h4 && treasure_array[16*(bombY1[3]+1)+bombX1[3]] == 4'h0)
					lower_change_to1[3] <= 4'h0;
				else
					lower_change_to1[3] <= map_array[16*(bombY1[3]+1)+bombX1[3]];
					
				if(map_array[16*bombY1[3]+bombX1[3]+1] == 4'h4 && treasure_array[16*bombY1[3]+bombX1[3]+1] != 4'h0)
					right_change_to1[3] <= treasure_array[16*bombY1[3]+bombX1[3]+1];
				else if(map_array[16*bombY1[3]+bombX1[3]+1] == 4'h4 && treasure_array[16*bombY1[3]+bombX1[3]+1] == 4'h0)
					right_change_to1[3] <= 4'h0;					
				else
					right_change_to1[3] <= map_array[16*bombY1[3]+bombX1[3]+1];
					
				if(map_array[16*bombY1[3]+bombX1[3]-1] == 4'h4 && treasure_array[16*bombY1[3]+bombX1[3]-1] != 4'h0)
					left_change_to1[3] <= treasure_array[16*bombY1[3]+bombX1[3]-1];
				else if(map_array[16*bombY1[3]+bombX1[3]-1] == 4'h4 && treasure_array[16*bombY1[3]+bombX1[3]-1] == 4'h0)
					left_change_to1[3] <= 4'h0;
				else
					left_change_to1[3] <= map_array[16*bombY1[3]+bombX1[3]-1];
				changeX1[3] <= bombX1[3];
				changeY1[3] <= bombY1[3];
				bomb_count1 <= bomb_count1 - 1;
		  end
	end	
 	
end	 
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    
    assign BallX1 = Ball_X_Pos1;
   
    assign BallY1 = Ball_Y_Pos1;
   
    assign BallS1 = Ball_Size;
endmodule
