// randomPacket.sv
// CPE 526
// Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

package random;
	class Packet;
		rand int bttnPressTime,		//The amount of time a button is pressed
						 dcTime,					//...?
						 travelTime,			//...?
						 timeBeforePress;	//Amount of time in clock cycles before the button is pressed again
		constraint c {bttnPressTime >= 1; bttnPressTime <= 8;
									dcTime >= 5; dcTime <= 20;
									travelTime >= 10; travelTime <= 30;
									timeBeforePress > 0; timeBeforePress <= 100;}

		typedef enum {U1, U2, D2, D3, F1, F2, F3} buttons;
		randc buttons b;
		rand int buttonSelector;

	endclass : Packet
endpackage : random
