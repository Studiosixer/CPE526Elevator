-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

Library IEEE;
use ieee.std_logic_1164.all;

entity DOOR_SENSOR is
	port(RESET, CLK : in std_logic;--, CLOSE: in std_logic;
			 CLOSE : in std_logic;
			 DOORSCLOSED : out std_logic);
end DOOR_SENSOR;
