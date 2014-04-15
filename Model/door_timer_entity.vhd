-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

Library IEEE;
use ieee.std_logic_1164.all;

entity door_timer is
	port(RESET, CLK , ENABLE: in std_logic;
			 ZERO : out std_logic);
end door_timer;
