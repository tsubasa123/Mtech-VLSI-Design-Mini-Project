
module trafficLightController (clk , reset, sensor, mainStreetLights, sideStreetLights);

parameter S0 = 3'b000,
		  S1 = 3'b001,
		  S2 = 3'b010,
		  S3 = 3'b011,
		  S4 = 3'b100,
		  S5 = 3'b101,
	      S6 = 3'b110;

parameter mainStreetGREENtimer = 4'd10, //10 Seconds
	      mainStreetYELLOWtimer = 4'd3, //3 Seconds
	      mainStreetREDtimer = 4'd1, //1 Seconds
	      sideStreetGREENtimer = 4'd10, // 10 Seconds
	      sideStreetYELLOWtimer = 4'd3, // 3 Seconds
	      sideStreetREDtimer = 4'd2; // 1 Seconds

input clk,reset,sensor;
output reg [2:0] mainStreetLights, sideStreetLights;

reg [2:0] State;
reg [3:0] counter;


always @(*)
	begin
		case(State)
			S0: 
			begin
				mainStreetLights = 3'b100;
				sideStreetLights = 3'b100; // mainStreet_RED ON, sideStreet_RED ON  Reset State.
			end
			S1:
			begin
				mainStreetLights = 3'b001;
				sideStreetLights = 3'b100; // mainStreet_GREEN ON, sideStreet_RED ON Default State or if sensor = 1 Keep ON for 10 seconds
			end
			S2:
			begin
				mainStreetLights = 3'b010;
				sideStreetLights = 3'b100; // mainStreet_YELLOW ON, sideStreet_RED ON , Keep ON for 3 seconds
			end
			S3:
			begin
				mainStreetLights = 3'b100;
				sideStreetLights = 3'b100; // mainStreet_RED ON, sideStreet_RED ON , Keep ON for 2 sec
			end
  			S4:
			begin
				mainStreetLights = 3'b100;
				sideStreetLights = 3'b001; // mainStreet_RED ON, sideStreet_GREEN ON , Keep ON for 10 sec
			end
			S5:
			begin
				mainStreetLights = 3'b100;
				sideStreetLights = 3'b010; //  mainStreet_RED ON, sideStreet_YELLOW ON, Keep On for 3 sec;
			end
			S6:
			begin
				mainStreetLights = 3'b100;
				sideStreetLights = 3'b100; //  mainStreet_RED ON, sideStreet_RED ON, Keep On for 1 sec;
			end
			default:
			begin
				mainStreetLights = 3'b001;
				sideStreetLights = 3'b100; // mainStreet_GREEN ON, sideStreet_RED ON Default State or if sensor = 1 Keep ON for 10 seconds
			end

		endcase
	end

always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			State <= S0;
			counter <= 0;
		end
		else if (reset == 0 && sensor == 0) //default State
		begin
			State <= S1;
			counter <= 0;    
		end
		else if (reset == 0 && sensor == 1)
		begin
			case (State)
				S1:
					if (counter < mainStreetGREENtimer)
					begin
						State <= S1;
						counter <= counter + 1;
					end
					else
					begin	
						State <= S2;
						counter <= 0;
					end
				S2:
					if (counter < mainStreetYELLOWtimer)
					begin
						State <= S2;
						counter <= counter + 1;
					end
					else
					begin
						State <= S3;
						counter <= 0;
					end
				S3:
					if (counter < mainStreetREDtimer)
					begin
						State <= S3;
						counter <= counter + 1;
					end
					else
					begin
						State <= S4;
						counter <= 0;
					end
				S4:
					if (counter < sideStreetGREENtimer)
					begin
						State <= S4;
						counter <= counter + 1;
					end
					else
					begin
						State <= S5;
						counter <= 0;
					end
				S5:
					if (counter < sideStreetYELLOWtimer)
					begin
						State <= S5;
						counter <=counter+1;
					end
					else 
					begin
						State <= S6;
						counter <= 0;
					end
				S6:
					if (counter < sideStreetREDtimer)
					begin
						State <= S6;
						counter <= counter + 1;
					end
					else
					begin
						State <= S1;
						counter <= 0;
					end
				default: State <= S1;
			endcase
		end
	end
endmodule

 
	


