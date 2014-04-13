-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

Library IEEE;
use ieee.std_logic_1164.all;

architecture BLAH of door_timer is
begin
	process (RESET, CLK, START, STOP)
		variable TIMER : integer range 0 to 6;--60;
	begin
		if (RESET = '1' or STOP = '1')then
			TIMER := 5;--9;
			ZERO <= '0';
		elsif (START = '1')then
			if (CLK'event and CLK = '1')then
				if (TIMER > 0)then
					TIMER := TIMER - 1;
					ZERO <= '0';
				else
					ZERO <= '1';
					TIMER := 5;--9;
				end if;
			end if;
		end if;
	end process;
end BLAH;
