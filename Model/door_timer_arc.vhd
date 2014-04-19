-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

Library IEEE;
use ieee.std_logic_1164.all;

architecture BEHAVE of door_timer is
begin
	process (RESET, CLK, ENABLE)
		variable TIMER : integer range 0 to 4;--60;
	begin
		if (RESET = '1' or ENABLE = '0')then
			TIMER := 3;--9;
			ZERO <= '0';
		elsif (ENABLE = '1')then
			if (CLK'event and CLK = '1')then
				if (TIMER > 0)then
					TIMER := TIMER - 1;
					ZERO <= '0';
				else
					ZERO <= '1';
					TIMER := 3;--9;
				end if;
			end if;
		end if;
	end process;
end BEHAVE;
