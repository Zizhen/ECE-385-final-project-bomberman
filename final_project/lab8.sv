//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  lab8 		( input         CLOCK_50,
                       input[3:0]    KEY, //bit 0 is set up as Reset
							  output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  //output [8:0]  LEDG,
							  output [17:0] LEDR,
							  // VGA Interface 
                       output [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,					//VGA Blue
							  output        VGA_CLK,				//VGA Clock
							                VGA_SYNC_N,			//VGA Sync signal
												 VGA_BLANK_N,			//VGA Blank signal
												 VGA_VS,					//VGA virtical sync signal	
												 VGA_HS,					//VGA horizontal sync signal
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
							  inout [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
							  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
							  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
							  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
							  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
							  output			 DRAM_CKE,				// SDRAM Clock Enable
							  output			 DRAM_WE_N,				// SDRAM Write Enable
							  output			 DRAM_CS_N,				// SDRAM Chip Select
							  output			 DRAM_CLK				// SDRAM Clock
											);
    
    logic Reset_h, vssig, Clk;
	 
    logic [9:0] drawxsig, drawysig, ballx1sig, bally1sig, ballx2sig, bally2sig, ballsizesig, ballsize2sig;
	 logic [15:0] keycode, keycode1;
//player1
	 logic [3:0] change_enable,explode_change_enable;
	 logic [3:0] Run; 
	 logic [3:0][3:0] change_to, upper_change_to, lower_change_to, left_change_to, right_change_to;
	 logic [3:0][3:0] changeX, changeY;
	 logic [3:0] X, Y;
	 logic [3:0][1:0] state_index;
	 logic [3:0] bomb_count;
	 logic [0:12*16-1][3:0] map_array, treasure_array;
	 logic [3:0] sprite_index,left_sprite_index,right_sprite_index, 
					 upper_sprite_index,lower_sprite_index,
					 upper_right_sprite_index,upper_left_sprite_index,
					 lower_right_sprite_index,lower_left_sprite_index;
	 logic player_GG, player1_GG, load_map, game_end;
//player2
	 logic [3:0] change_enable1,explode_change_enable1;
	 logic [3:0] Run1; 
	 logic [3:0][3:0] change_to1, upper_change_to1, lower_change_to1, left_change_to1, right_change_to1;
	 logic [3:0][3:0] changeX1, changeY1;
	 logic [3:0] X1, Y1;
	 logic [3:0][1:0] state_index1;
	 logic [3:0] bomb_count1;
	 logic [3:0] sprite_index1,left_sprite_index1,right_sprite_index1, 
					 upper_sprite_index1,lower_sprite_index1,
					 upper_right_sprite_index1,upper_left_sprite_index1,
					 lower_right_sprite_index1,lower_left_sprite_index1;
//treasure map

logic [3:0] treasure_change_X, treasure_change_Y;
logic [3:0] treasure_change_to;
logic treasure_change_enable;
logic [3:0] treasure_change_X1, treasure_change_Y1;
logic [3:0] treasure_change_to1;
logic treasure_change_enable1;			
logic [1:0] player1_health, player2_health;				
	 assign vssig = VGA_VS;
	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low
	 assign X = ballx1sig/40;
	 assign Y = bally1sig/40;	 
	 assign X1 = ballx2sig/40;
	 assign Y1 = bally2sig/40;	 


	 wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out;
	 wire hpi_r, hpi_w,hpi_cs;
	 
	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
										 .from_sw_data_in(hpi_data_in),
										 .from_sw_data_out(hpi_data_out),
										 .from_sw_r(hpi_r),
										 .from_sw_w(hpi_w),
										 .from_sw_cs(hpi_cs),
		 								 .OTG_DATA(OTG_DATA),    
										 .OTG_ADDR(OTG_ADDR),    
										 .OTG_RD_N(OTG_RD_N),    
										 .OTG_WR_N(OTG_WR_N),    
										 .OTG_CS_N(OTG_CS_N),    
										 .OTG_RST_N(OTG_RST_N),   
										 .OTG_INT(OTG_INT),
										 .Clk(Clk),
										 .Reset(Reset_h)
	 );
	 
	 //The connections for nios_system might be named different depending on how you set up Qsys
	 nios_system nios_system(
										 .clk_clk(Clk),         
										 .reset_reset_n(KEY[0]),   
										 .sdram_wire_addr(DRAM_ADDR), 
										 .sdram_wire_ba(DRAM_BA),   
										 .sdram_wire_cas_n(DRAM_CAS_N),
										 .sdram_wire_cke(DRAM_CKE),  
										 .sdram_wire_cs_n(DRAM_CS_N), 
										 .sdram_wire_dq(DRAM_DQ),   
										 .sdram_wire_dqm(DRAM_DQM),  
										 .sdram_wire_ras_n(DRAM_RAS_N),
										 .sdram_wire_we_n(DRAM_WE_N), 
										 .sdram_clk_clk(DRAM_CLK),
										 .keycode_export(keycode), 
										 .keycode1_export(keycode1),  
										 .otg_hpi_address_export(hpi_addr),
										 .otg_hpi_data_in_port(hpi_data_in),
										 .otg_hpi_data_out_port(hpi_data_out),
										 .otg_hpi_cs_export(hpi_cs),
										 .otg_hpi_r_export(hpi_r),
										 .otg_hpi_w_export(hpi_w));
	
	//Fill in the connections for the rest of the modules 
    vga_controller vgasync_instance(.Clk,.Reset(Reset_h),.DrawX(drawxsig),.DrawY(drawysig),.hs(VGA_HS),.vs(VGA_VS),
												.pixel_clk(VGA_CLK),.blank(VGA_BLANK_N),.sync(VGA_SYNC_N));
   
    bomberman bomberman0(.Reset(game_end),.Clk,.frame_clk(vssig),.BallX(ballx1sig),.BallY(bally1sig),
							  .BallS(ballsizesig),.keycode,.LED(LEDR[3:0]),.change_to,.changeX,.changeY,
							  .BallX1(ballx2sig),.BallY1(bally2sig),.BallS1(ballsize2sig),.LED1(LEDR[7:4]),.*);
							     
    color_mapper color_instance(.player1_X(ballx1sig),.player1_Y(bally1sig),.player2_X(ballx2sig),.player2_Y(bally2sig),
										  .DrawX(drawxsig),.DrawY(drawysig),.Red(VGA_R),.Green(VGA_G),.Blue(VGA_B),.map_array,.treasure_array);
	 map1 map0(.*);
//	 map2 map0(.*)
	 game_state game_state0(.*);
	 
	 bomb_state_machine bomb_state_machine0(.Reset(game_end),.Run(Run[0]),.state_index(state_index[0]),.*);
	 bomb_state_machine bomb_state_machine1(.Reset(game_end),.Run(Run[1]),.state_index(state_index[1]),.*);
	 bomb_state_machine bomb_state_machine2(.Reset(game_end),.Run(Run[2]),.state_index(state_index[2]),.*);
	 bomb_state_machine bomb_state_machine3(.Reset(game_end),.Run(Run[3]),.state_index(state_index[3]),.*);

	 bomb_state_machine bomb_state_machine4(.Reset(game_end),.Run(Run1[0]),.state_index(state_index1[0]),.*);
	 bomb_state_machine bomb_state_machine5(.Reset(game_end),.Run(Run1[1]),.state_index(state_index1[1]),.*);
	 bomb_state_machine bomb_state_machine6(.Reset(game_end),.Run(Run1[2]),.state_index(state_index1[2]),.*);
	 bomb_state_machine bomb_state_machine7(.Reset(game_end),.Run(Run1[3]),.state_index(state_index1[3]),.*);


	 HexDriver hex_inst_0 (player2_health, HEX0);
//	 HexDriver hex_inst_1 (game_end, HEX1);
// 	 HexDriver hex_inst_2 (change_enable[0], HEX2);
//	 HexDriver hex_inst_3 (change_to[0], HEX3);
	 HexDriver hex_inst_4 (player1_health, HEX4);
//	 HexDriver hex_inst_5 (treasure_change_enable1, HEX5);
//	 HexDriver hex_inst_6 (bomb_count, HEX6);
//	 HexDriver hex_inst_7 (bomb_count1, HEX7);
   

	 /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #1/2:
          What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
			 connect to the keyboard? List any two.  Give an answer in your Post-Lab.
     **************************************************************************************/
endmodule
