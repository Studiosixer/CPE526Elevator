// randomTest.sv
// CPE 526
// Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

import random::Packet;

interface elevator_if(input bit clk);
	logic rst, u1, u2, d2, d3, f1, f2, f3, dc, door;
	logic [1:0] fs, dir;

	clocking cb @(posedge clk);
		output rst, u1, u2, d2, d3, f1, f2, f3, dc, fs;
		input door, dir;
	endclocking
endinterface

module elevator_test(elevator_if elevatorif);
	typedef enum {ClosingDoors1,
								ClosingDoors2,
								ClosingDoors3,
								OpenedDoors1,
								OpenedDoors2,
								OpenedDoors3,
								Up1To2,
								Up2To3,
								Down3To2,
								Down2To1} states;
	Packet p;

	initial
	begin
		p = new();
		p.randomize();

		/*** Test going up from floor 1 to floor 2 ***/

		// init inputs
		elevatorif.u1 <= 1'b0;
		elevatorif.u2 <= 1'b0;
		elevatorif.d2 <= 1'b0;
		elevatorif.d3 <= 1'b0;
		elevatorif.f1 <= 1'b0;
		elevatorif.f2 <= 1'b0;
		elevatorif.f3 <= 1'b0;
		elevatorif.dc <= 1'b0;
		elevatorif.fs <= 2'b01;
		// reset device
		elevatorif.rst <= 1'b1;
		repeat (2)
			@(elevatorif.cb);
		elevatorif.rst <= 1'b0;
		@(elevatorif.cb);

		// assert we're in initial state
		assert(E.state == ClosingDoors1);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b00);

		// Up pressed on floor 1
		elevatorif.u1 <= 1'b1;
		repeat (p.bttnPressTime)
			@(elevatorif.cb);
		elevatorif.u1 <= 1'b0;

		assert(E.state == OpenedDoors1);
		assert(elevatorif.door == 1'b0);
		assert(elevatorif.dir == 2'b00);

		// Floor 2 button pressed
		elevatorif.f2 <= 1'b1;
		repeat (p.bttnPressTime)
			@(elevatorif.cb);
		elevatorif.f2 <= 1'b0;

		assert(E.state == ClosingDoors1);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b00);

		// send doors closed (DC) signal
		repeat (p.dcTime)
			@(elevatorif.cb);
		elevatorif.dc <= 1'b1;
		@(elevatorif.cb);

		assert(E.state == Up1To2);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b01);

		// set floor sensor to level 2
		repeat (p.travelTime)
			@(elevatorif.cb);
		elevatorif.fs <= 2'b10;
		@(elevatorif.cb);

		assert(E.state == OpenedDoors2);
		assert(elevatorif.door == 1'b0);
		assert(elevatorif.dir == 2'b00);

	end // initial

endmodule

module top;
	bit clk;
	always #50 clk = ~clk;

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
	elevator_test Test1(elevatorif);
endmodule
