`timescale 1ns / 1ps

module Traffic_Light_Controller_TestBench ();

reg masterclk, reset_button, sensor_button;
wire [2:0] mainStreetleds, sideStreetleds;

	TrafficLightTop DUT (.masterclk(masterclk), .reset_button(reset_button), .sensor_button(sensor_button), .mainStreetleds(mainStreetleds), .sideStreetleds(sideStreetleds));
	
	initial
	begin
		$monitor($time," MAIN STREET RED = %b, MAIN STREET YELLOW = %b, MAIN STREET GREEN =%b, SIDE STREET RED = %b, SIDE STREET YELLOW = %b, SIDE STREET GREEN = %b ", mainStreetleds[2], mainStreetleds[1], mainStreetleds[0], sideStreetleds[2], sideStreetleds[1], sideStreetleds[0]);
		$dumpfile("TrafficLightwaveform.vcd");
		$dumpvars(0, Traffic_Light_Controller_TestBench);
	end
	
	task initialize;
		begin
			reset_button = 0;
			sensor_button = 0;
			masterclk = 0;

		end
	endtask

	always
	begin
	        #10  masterclk = ~ masterclk;
	end
	
	initial
	begin
		initialize;
		@(negedge masterclk)
			   sensor_button = 1;
		@(negedge masterclk)
	    	#1500 sensor_button = 0;
	    @(negedge masterclk)
	    	#500 reset_button = 1;	sensor_button = 0;
	    #2000 $finish;
	end
	
endmodule
