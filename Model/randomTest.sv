// randomTest.sv
// CPE 526
// Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes
import random::Packet;

//-------------------------------------------------
//						Verification Manager Module
//-------------------------------------------------
module VerificationManager(elevator_if elevatorif);
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
	bit floor1Requested = 1'b0;
	bit floor2Requested = 1'b0;
	bit floor3Requested = 1'b0;
	
//	initial begin
//		$display("Elevator @  |  Floor Requested  |  Current State");
//		$display("------------------------------------------------");
//	end

	always @elevatorif.cb begin
		//If the elevator needs to go to floor 1
		if(elevatorif.u1 == 1'b1 || elevatorif.f1 == 1'b1) begin
			floor1Requested <= 1'b1;
		end
		//If the elevator needs to go to floor 2
		if(elevatorif.u2 == 1'b1 || elevatorif.f2 == 1'b1 || elevatorif.d2 == 1'b1) begin
			floor2Requested <= 1'b1;
		end
		//If the elevator needs to go to floor 3
		if(elevatorif.d3 == 1'b1 || elevatorif.f3 == 1'b1) begin
			floor3Requested <= 1'b1;
		end
	end //always @elevatorif.cb

	always @(posedge elevatorif.u1) begin
		case (elevatorif.fs)
			2'b01 : $display("Floor 1 requested. Accepted!");
			2'b10 : $display("Floor 1 requested. Request Pending...");
			2'b11 : $display("Floor 1 requested. Request Pending...");
		endcase

//		if (elevatorif.fs == 2'b01) begin
//			$display("Floor 1 requested. Accepted!");
//		end
//		if (elevatorif.fs == 2'b10) begin
//			$display("Floor 1 requested. Request pending...");
//		end
	end //always @(posedge floor1Requested)

endmodule //VerificationManager


//---------------------------------------
//			Door Sensor Module
//---------------------------------------
//The door sensor module is triggered on every edge of the door output from the elevator.
//If the statsis and Opened Doors state, DC goes low. Otherwise, we wait a few clockcycles
//and set DC high. This is a psuedo "sensor" for the dooe.
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
	always @(edge E.door) begin //Triggered at every edge
		if( (E.state == OpenedDoors1) || (E.state == OpenedDoors2) || (E.state == OpenedDoors3) ) begin
			elevatorif.dc <= 1'b0;
		end

		repeat(2) @elevatorif.cb;
		if ((E.state == ClosingDoors1) || (E.state == ClosingDoors2) || (E.state == ClosingDoors3)) begin
			elevatorif.dc <= 1'b1;
		end
	end

endmodule //Door sensor

//-----------------------------------------
//				Floor Sensor Module
//-----------------------------------------
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

endmodule //Floor sensor

//-----------------------------------------------------------
//									Button Test Program
//-----------------------------------------------------------
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
	elevatorif.u1 <= 1'b0;
	elevatorif.u2 <= 1'b0;
	elevatorif.d2 <= 1'b0;
	elevatorif.d3 <= 1'b0;
	elevatorif.f1 <= 1'b0;
	elevatorif.f2 <= 1'b0;
	elevatorif.f3 <= 1'b0;

		p = new();

		repeat(1 + butIdx)
			p.randomize();

		@(elevatorif.cb)
		elevatorif.rst <= 1'b1;
		@(elevatorif.cb)
		elevatorif.rst <= 1'b0;
		elevatorif.dc <= 1'b0;

		if( 0 == butIdx ) begin				//On floor 1, press up
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.u1 <= 1'b1;
			repeat (p.bttnPressTime) @ elevatorif.cb;
			elevatorif.u1 <= 1'b0;
 		end else if( 1 == butIdx ) begin //On floor 2, press up
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.u2 <= 1'b1;
			repeat (p.bttnPressTime) @ elevatorif.cb;
			elevatorif.u2 <= 1'b0;
		end else if( 2 == butIdx ) begin //On floor 2, press down
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.d2 <= 1'b1;
			repeat (p.bttnPressTime) @ elevatorif.cb;
			elevatorif.d2 <= 1'b0;
		end else if( 3 == butIdx ) begin //On floor 3, press down
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.d3 <= 1'b1;
			repeat (p.bttnPressTime) @ elevatorif.cb;
			elevatorif.d3 <= 1'b0;
		end else if( 4 == butIdx ) begin //In elevator, press 1
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.f1 <= 1'b1;
			repeat (p.bttnPressTime) @ elevatorif.cb;
			elevatorif.f1 <= 1'b0;
		end else if( 5 == butIdx ) begin //In elevator, press 2
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.f2 <= 1'b1;
			repeat (p.bttnPressTime) @ elevatorif.cb;
			elevatorif.f2 <= 1'b0;
		end else if( 6 == butIdx ) begin //In elevator, press 3
			repeat (p.timeBeforePress) @ elevatorif.cb;
			elevatorif.f3 <= 1'b1;
			repeat (p.bttnPressTime) @ elevatorif.cb;
			elevatorif.f3 <= 1'b0;
		end	// if 1 == butIdx

	end //End initial begin
endprogram  //end program ButtonTest
