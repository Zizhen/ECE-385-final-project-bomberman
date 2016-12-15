module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

logic Reset, frame_clk, Clk;
logic[15:0] keycode;
logic [9:0] BallX, BallY, BallS;
logic [3:0] LED;
logic [3:0] changeX, changeY;
logic [3:0] change_to;
logic change_enable;
logic [0:12*16-1][3:0] map_array;

bomberman bomberman0(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: test





end


endmodule
