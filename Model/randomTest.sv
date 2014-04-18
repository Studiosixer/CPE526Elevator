// randomTest.sv
// CPE 526
// Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes
import random::Packet;

//The door sensor module waits for a change of the state of the elevator.
//If the door is in a closing state, the elevator waits for 5 cycles and sets
//DC high. Otherwise, DC will be low.
module DoorSensor(elevator_if elevatorif);
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
	always @(E.state) begin
		if ((E.state == ClosingDoors1) || (E.state == ClosingDoors2) || (E.state == ClosingDoors3)) begin
			repeat(5) @ elevatorif.cb;
			elevatorif.dc <= 1'b1;
		end else begin
			elevatorif.dc <= 1'b0;
		end
	end

endmodule


module FloorSensor(elevator_if elevatorif);
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
	always @(E.state) begin
		if ( (E.state == Up1To2) || (E.state == Down3To2) ) begin
			repeat(2) @ elevatorif.cb;
			elevatorif.fs <= 2'b10;
		end else if ( E.state == Down2To1 ) begin
			repeat(2) @ elevatorif.cb;
			elevatorif.fs <= 2'b01;
		end else if ( E.state == Up2To3 ) begin
			repeat(2) @ elevatorif.cb;
			elevatorif.fs <= 2'b11;
		end
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
			elevatorif.dcStartTimer <= 1'b1;
			elevatorif.dc <= 1'b1;
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


