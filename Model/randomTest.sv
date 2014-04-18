// randomTest.sv
// CPE 526
// Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

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

module DoorSensor(input bit startTimer, output logic DC);
	int count;
	always @(posedge startTimer) begin
		$display("hello");
	end

endmodule

program ButtonTest(elevator_if elevatorif, input int butIdx);
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
	typedef enum {U1, U2, D2, D3, F1, F2, F3} buttons;
	typedef enum {FIRST, SECOND, THIRD, IN_ELEV} location;
	location loc;
	Packet p;
	initial begin

		//p.randomize();
		//$cast(loc, num); //
		//Initialize inputs

		p = new();

		repeat(1 + butIdx)
			p.randomize();

		@(elevatorif.cb)
		elevatorif.rst <= 1'b1;
		@(elevatorif.cb)
		elevatorif.rst <= 1'b0;

		if( 0 == butIdx ) begin				//On floor 1, press up
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.u1 <= 1'b1;
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.u1 <= 1'b0;
		end else if( 1 == butIdx ) begin //On floor 2, press up
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.u2 <= 1'b1;
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.u2 <= 1'b0;
		end else if( 2 == butIdx ) begin //On floor 2, press down
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.d2 <= 1'b1;
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.d2 <= 1'b0;
		end else if( 3 == butIdx ) begin //On floor 3, press down
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.d3 <= 1'b1;
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.d3 <= 1'b0;
		end else if( 4 == butIdx ) begin //In elevator, press 1
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.f1 <= 1'b1;
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.f1 <= 1'b0;
		end else if( 5 == butIdx ) begin //In elevator, press 2
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.f2 <= 1'b1;
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.f2 <= 1'b0;
		end else if( 6 == butIdx ) begin //In elevator, press 3
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.f3 <= 1'b1;
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.f3 <= 1'b0;
		end	// if 1 == butIdx

	end //End initial begin
endprogram  //end program ButtonTest

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
	DoorSensor DSense(elevatorif.dStartTimer, elevatorif.dc);
	ButtonTest Test0(elevatorif, 0);
	ButtonTest Test1(elevatorif, 1);
	ButtonTest Test2(elevatorif, 2);
	ButtonTest Test3(elevatorif, 3);
	ButtonTest Test4(elevatorif, 4);
	ButtonTest Test5(elevatorif, 5);
	ButtonTest Test6(elevatorif, 6);

endmodule
