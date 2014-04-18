import random::Packet;

interface elevator_if(input bit clk);
	logic rst, u1, u2, d2, d3, f1, f2, f3, dc, door;
	logic [1:0] fs, dir;
	bit dStartTimer;

	clocking cb @(posedge clk);
		output rst, u1, u2, d2, d3, f1, f2, f3, dc, fs;
		input door, dir;
	endclocking
endinterface

module top;
	bit clk;

	always #5 clk = ~clk;

	elevator_if elevatorif(clk);
	elevator E(
				.clk(clk),
				.rst(elevatorif.rst),
				.UP1(elevatorif.u1),
				.UP2(elevatorif.u2),
				.DOWN2(elevatorif.d2),
				.DOWN3(elevatorif.d3),
				.FLOOR1(elevatorif.f1),
				.FLOOR2(elevatorif.f2),
				.FLOOR3(elevatorif.f3),
				.DC(elevatorif.dc),
			 	.FS(elevatorif.fs),
			 	.door(elevatorif.door),
			 	.direction(elevatorif.dir));
	//elevator_test Test1(elevatorif);
	DoorSensor DSense(elevatorif);
	ButtonTest Test0(elevatorif, 0);
	ButtonTest Test1(elevatorif, 1);
	ButtonTest Test2(elevatorif, 2);
	ButtonTest Test3(elevatorif, 3);
	ButtonTest Test4(elevatorif, 4);
	ButtonTest Test5(elevatorif, 5);
	ButtonTest Test6(elevatorif, 6);

endmodule
