
module TrafficLightTop (masterclk , reset_button, sensor_button, mainStreetleds, sideStreetleds); // for interfacing with the FPGA

input masterclk, reset_button, sensor_button;
output [2:0]mainStreetleds, sideStreetleds;

wire dividedclk;

	Clock_divider CLK (.clock_in(masterclk) , .reset(reset_button), .clock_out(dividedclk));
	trafficLightController TLC (.clk(dividedclk), .reset(reset_button), .sensor(sensor_button), .mainStreetLights(mainStreetleds), .sideStreetLights(sideStreetleds));


endmodule
