// Elevator Controller
// CPE 526
// Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

import random::Packet;

const int DOOR_OPEN_TIME = 5;  // number of clock cycles the door stays open

// run through all states
program statesTest(elevator_if elevatorif);
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

		// init inputs
		elevatorif.u1 <= 1'b0;
		elevatorif.u2 <= 1'b0;
		elevatorif.d2 <= 1'b0;
		elevatorif.d3 <= 1'b0;
		elevatorif.f1 <= 1'b0;
		elevatorif.f2 <= 1'b0;
		elevatorif.f3 <= 1'b0;
		elevatorif.fs <= 2'b01;
		elevatorif.dc <= 1'b1;
		// reset device
		elevatorif.rst <= 1'b1;
		repeat (2)
			@(elevatorif.cb);
		elevatorif.rst <= 1'b0;
		@(elevatorif.cb);

		// Go up from floor 1 to floor 2 
		p.randomize();

		// assert we're in initial state
		assert(E.state == ClosingDoors1);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b00);

		// Up pressed on floor 1
		elevatorif.u1 <= 1'b1;
		elevatorif.dc <= 1'b0;
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

		// ensure timer has expired to put us in the closing doors state
		repeat (DOOR_OPEN_TIME)
			@(elevatorif.cb);

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
		elevatorif.dc <= 1'b0;
		@(elevatorif.cb);

		assert(E.state == OpenedDoors2);
		assert(elevatorif.door == 1'b0);
		assert(elevatorif.dir == 2'b00);

		// Go up from floor 2 to floor 3
		p.randomize();

		// floor 3 button pressed
		elevatorif.f3 <= 1'b1;
		repeat (p.bttnPressTime)
			@(elevatorif.cb);
		elevatorif.f3 <= 1'b0;

		// ensure timer has expired to put us in the closing doors state
		repeat (DOOR_OPEN_TIME)
			@(elevatorif.cb);

		assert(E.state == ClosingDoors2);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b00);

		// send doors closed (DC) signal
		repeat (p.dcTime)
			@(elevatorif.cb);
		elevatorif.dc <= 1'b1;
		@(elevatorif.cb);

		assert(E.state == Up2To3);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b01);

		// set floor sensor to level 3
		repeat (p.travelTime)
			@(elevatorif.cb);
		elevatorif.fs <= 2'b11;
		elevatorif.dc <= 1'b0;
		@(elevatorif.cb);

		assert(E.state == OpenedDoors3);
		assert(elevatorif.door == 1'b0);
		assert(elevatorif.dir == 2'b00);

		// Go down from floor 3 to floor 2
		p.randomize();

		// floor 2 down button pressed
		elevatorif.d2 <= 1'b1;
		repeat (p.bttnPressTime)
			@(elevatorif.cb);
		elevatorif.d2 <= 1'b0;

		// ensure timer has expired to put us in the closing doors state
		repeat (DOOR_OPEN_TIME)
			@(elevatorif.cb);

		assert(E.state == ClosingDoors3);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b00);

		// send doors closed (DC) signal
		repeat (p.dcTime)
			@(elevatorif.cb);
		elevatorif.dc <= 1'b1;
		@(elevatorif.cb);

		assert(E.state == Down3To2);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b10);

		// set floor sensor to level 2
		repeat (p.travelTime)
			@(elevatorif.cb);
		elevatorif.fs <= 2'b10;
		elevatorif.dc <= 1'b0;
		@(elevatorif.cb);

		assert(E.state == OpenedDoors2);
		assert(elevatorif.door == 1'b0);
		assert(elevatorif.dir == 2'b00);

		// Go down from floor 2 to floor 1
		p.randomize();

		// floor 1 button pressed
		elevatorif.f1 <= 1'b1;
		repeat (p.bttnPressTime)
			@(elevatorif.cb);
		elevatorif.f1 <= 1'b0;

		// ensure timer has expired to put us in the closing doors state
		repeat (DOOR_OPEN_TIME)
			@(elevatorif.cb);

		assert(E.state == ClosingDoors2);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b00);

		// send doors closed (DC) signal
		repeat (p.dcTime)
			@(elevatorif.cb);
		elevatorif.dc <= 1'b1;
		@(elevatorif.cb);

		assert(E.state == Down2To1);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b10);

		// set floor sensor to level 2
		repeat (p.travelTime)
			@(elevatorif.cb);
		elevatorif.fs <= 2'b01;
		elevatorif.dc <= 1'b0;
		@(elevatorif.cb);

		assert(E.state == OpenedDoors1);
		assert(elevatorif.door == 1'b0);
		assert(elevatorif.dir == 2'b00);

		// Ensure we go back to the doors closed state and stay there
		repeat (DOOR_OPEN_TIME)
			@(elevatorif.cb);

		assert(E.state == ClosingDoors1);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b00);

		repeat (10)
			@(elevatorif.cb);

		assert(E.state == ClosingDoors1);
		assert(elevatorif.door == 1'b1);
		assert(elevatorif.dir == 2'b00);

	end // initial

endprogram : statesTest
