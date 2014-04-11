-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

Library IEEE;
use ieee.std_logic_1164.all;

architecture BLAH of door_timer is
begin
	process (RESET, CLK)
		variable TIMER : integer range 0 to 60;
	begin
		if (RESET = '1')then
			TIMER := 59;
			ZERO <= '0';
		elsif (CLK'event and CLK = '1')then
			if (TIMER > 0)then
				TIMER := TIMER - 1;
				ZERO <= '0';
			else
				ZERO <= '1';
				TIMER := 59;
			end if;
		end if;
	end process;
end BLAH;
