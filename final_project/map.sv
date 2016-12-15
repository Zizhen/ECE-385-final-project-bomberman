module map1(
		 input Clk, load_map,
		 input [3:0] X, Y,
		 input [3:0] change_enable, explode_change_enable,
		 input [3:0][3:0] change_to, upper_change_to, lower_change_to, left_change_to, right_change_to, 
		 input [3:0][3:0] changeX, changeY,
		 input [3:0] X1, Y1,
		 input [3:0] change_enable1, explode_change_enable1,
		 input [3:0][3:0] change_to1, upper_change_to1, lower_change_to1, left_change_to1, right_change_to1, 
		 input [3:0][3:0] changeX1, changeY1,

		 output logic [3:0] sprite_index, left_sprite_index, right_sprite_index, upper_sprite_index,lower_sprite_index,
								  upper_right_sprite_index,upper_left_sprite_index,lower_right_sprite_index,lower_left_sprite_index,

		 output logic [3:0] sprite_index1, left_sprite_index1, right_sprite_index1, upper_sprite_index1, lower_sprite_index1,
								  upper_right_sprite_index1, upper_left_sprite_index1, lower_right_sprite_index1, lower_left_sprite_index1,
	    output logic [0:12*16-1][3:0] map_array,
		 output logic [0:12*16-1][3:0] treasure_array,
		 input [3:0] treasure_change_X, treasure_change_Y,
		 input [3:0] treasure_change_to,
		 input treasure_change_enable,
		 input [3:0] treasure_change_X1, treasure_change_Y1,
		 input [3:0] treasure_change_to1,
		 input treasure_change_enable1
);
//0: grass
//1: box
//2: brick
//3: bomb
//4: explosion
//5: shoe
//6: potion
//7: bubble



always_comb
begin 
	sprite_index = map_array[16*Y+X];
	left_sprite_index = map_array[16*Y+X-1];
	right_sprite_index = map_array[16*Y+X+1];
	upper_sprite_index = map_array[16*(Y-1)+X];
	lower_sprite_index = map_array[16*(Y+1)+X];
	upper_left_sprite_index = map_array[16*(Y-1)+X-1];
	upper_right_sprite_index = map_array[16*(Y-1)+X+1];
	lower_left_sprite_index = map_array[16*(Y+1)+X-1];
	lower_right_sprite_index = map_array[16*(Y+1)+X+1];

	sprite_index1 = map_array[16*Y1+X1];
	left_sprite_index1 = map_array[16*Y1+X1-1];
	right_sprite_index1 = map_array[16*Y1+X1+1];
	upper_sprite_index1 = map_array[16*(Y1-1)+X1];
	lower_sprite_index1 = map_array[16*(Y1+1)+X1];
	upper_left_sprite_index1 = map_array[16*(Y1-1)+X1-1];
	upper_right_sprite_index1 = map_array[16*(Y1-1)+X1+1];
	lower_left_sprite_index1 = map_array[16*(Y1+1)+X1-1];
	lower_right_sprite_index1 = map_array[16*(Y1+1)+X1+1];
	
end


always_ff@(posedge Clk)
begin
if(load_map)
begin
map_array <= {
4'h0, 4'h0, 4'h0, 4'h1, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h1, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 
4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 
4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 
4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h1, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h1, 4'h1, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h2, 4'h0, 4'h0, 4'h2, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h1, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h2, 4'h2, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0
};
treasure_array <= {
4'h0, 4'h0, 4'h0, 4'h6, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h6, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h6, 4'h0, 4'h0, 4'h0, 4'h0, 4'h6, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h5, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h5, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h7, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h7, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h7, 4'h7, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h5, 4'h0, 4'h0, 4'h0, 4'h0, 4'h5, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h6, 4'h6, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 
4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0
};
end
if(change_enable[0]==1'b1)
		map_array[16*changeY[0]+changeX[0]] <= change_to[0];

if(explode_change_enable[0] == 1'b1) begin
		map_array[16*changeY[0]+changeX[0]-1] <= left_change_to[0];
		map_array[16*changeY[0]+changeX[0]+1] <= right_change_to[0];
		map_array[16*(changeY[0]-1)+changeX[0]] <= upper_change_to[0];
		map_array[16*(changeY[0]+1)+changeX[0]] <= lower_change_to[0];
end
if(change_enable[1]==1'b1)
		map_array[16*changeY[1]+changeX[1]] <= change_to[1];

if(explode_change_enable[1] == 1'b1) begin
		map_array[16*changeY[1]+changeX[1]-1] <= left_change_to[1];
		map_array[16*changeY[1]+changeX[1]+1] <= right_change_to[1];
		map_array[16*(changeY[1]-1)+changeX[1]] <= upper_change_to[1];
		map_array[16*(changeY[1]+1)+changeX[1]] <= lower_change_to[1];
end
if(change_enable[2]==1'b1)
		map_array[16*changeY[2]+changeX[2]] <= change_to[2];

if(explode_change_enable[2] == 1'b1) begin
		map_array[16*changeY[2]+changeX[2]-1] <= left_change_to[2];
		map_array[16*changeY[2]+changeX[2]+1] <= right_change_to[2];
		map_array[16*(changeY[2]-1)+changeX[2]] <= upper_change_to[2];
		map_array[16*(changeY[2]+1)+changeX[2]] <= lower_change_to[2];
end
if(change_enable[3]==1'b1)
		map_array[16*changeY[3]+changeX[3]] <= change_to[3];

if(explode_change_enable[3] == 1'b1) begin
		map_array[16*changeY[3]+changeX[3]-1] <= left_change_to[3];
		map_array[16*changeY[3]+changeX[3]+1] <= right_change_to[3];
		map_array[16*(changeY[3]-1)+changeX[3]] <= upper_change_to[3];
		map_array[16*(changeY[3]+1)+changeX[3]] <= lower_change_to[3];
end


//second player

if(change_enable1[0]==1'b1)
		map_array[16*changeY1[0]+changeX1[0]] <= change_to1[0];

if(explode_change_enable1[0] == 1'b1) begin
		map_array[16*changeY1[0]+changeX1[0]-1] <= left_change_to1[0];
		map_array[16*changeY1[0]+changeX1[0]+1] <= right_change_to1[0];
		map_array[16*(changeY1[0]-1)+changeX1[0]] <= upper_change_to1[0];
		map_array[16*(changeY1[0]+1)+changeX1[0]] <= lower_change_to1[0];
end
if(change_enable1[1]==1'b1)
		map_array[16*changeY1[1]+changeX1[1]] <= change_to1[1];

if(explode_change_enable1[1] == 1'b1) begin
		map_array[16*changeY1[1]+changeX1[1]-1] <= left_change_to1[1];
		map_array[16*changeY1[1]+changeX1[1]+1] <= right_change_to1[1];
		map_array[16*(changeY1[1]-1)+changeX1[1]] <= upper_change_to1[1];
		map_array[16*(changeY1[1]+1)+changeX1[1]] <= lower_change_to1[1];
end
if(change_enable1[2]==1'b1)
		map_array[16*changeY1[2]+changeX1[2]] <= change_to1[2];

if(explode_change_enable1[2] == 1'b1) begin
		map_array[16*changeY1[2]+changeX1[2]-1] <= left_change_to1[2];
		map_array[16*changeY1[2]+changeX1[2]+1] <= right_change_to1[2];
		map_array[16*(changeY1[2]-1)+changeX1[2]] <= upper_change_to1[2];
		map_array[16*(changeY1[2]+1)+changeX1[2]] <= lower_change_to1[2];
end
if(change_enable1[3]==1'b1)
		map_array[16*changeY1[3]+changeX1[3]] <= change_to1[3];

if(explode_change_enable1[3] == 1'b1) begin
		map_array[16*changeY1[3]+changeX1[3]-1] <= left_change_to1[3];
		map_array[16*changeY1[3]+changeX1[3]+1] <= right_change_to1[3];
		map_array[16*(changeY1[3]-1)+changeX1[3]] <= upper_change_to1[3];
		map_array[16*(changeY1[3]+1)+changeX1[3]] <= lower_change_to1[3];
end

if(treasure_change_enable == 1'b1)begin
		treasure_array[16*treasure_change_Y+treasure_change_X] <= treasure_change_to;
end
if(treasure_change_enable1 == 1'b1)begin
		treasure_array[16*treasure_change_Y1+treasure_change_X1] <= treasure_change_to1;
end
end
endmodule
