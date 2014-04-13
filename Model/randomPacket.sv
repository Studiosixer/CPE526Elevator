// randomPacket.sv
// CPE 526
// Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

package random;
	class Packet;
		rand int bttnPressTime, dcTime, travelTime;
		constraint c {bttnPressTime >= 1; bttnPressTime <= 8;
									dcTime >= 5; dcTime <= 20;
									travelTime >= 10; travelTime <= 30;}
	endclass : Packet
endpackage : random
