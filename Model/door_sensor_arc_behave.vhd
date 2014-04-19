-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

Library IEEE;
use ieee.std_logic_1164.all;

architecture BEHAVE of DOOR_SENSOR is
begin
	process (RESET, CLK, CLOSE)
		variable TIMER : integer range 0 to 4;
	begin
		if (RESET = '1')then
			TIMER := 0;
			DOORSCLOSED <= '1';
		else
			if (ClOSE = '0')then
				TIMER := 3;
				DOORSCLOSED <= '0';
			elsif (CLOSE = '1')then
				if (CLK'event and CLK = '1')then
					if (TIMER > 0)then
						TIMER := TIMER - 1;
						DOORSCLOSED <= '0';
					else
						DOORSCLOSED <= '1';
					--CLOSE <= '0';
	--				TIMER := 3;
					end if;
				end if;
			end if;
		end if;
	end process;
end BEHAVE;
