-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes
use WORK.all;

architecture behavioral of elevator is
	type stateType is (ClosingDoors1,  -- Closing doors while on floor 1
										 ClosingDoors2,  -- Closing doors while on floor 2
										 ClosingDoors3,  -- Closing doors while on floor 3
										 OpenedDoors1,   -- Elevator is on floor 1 with doors open
										 OpenedDoors2,   -- Elevator is on floor 2 with doors open
										 OpenedDoors3,   -- Elevator is on floor 3 with doors open
										 Up1To2,         -- Elevator is moving up from floor 1 to floor 2
										 Up2To3,         -- Elevator is moving up from floor 2 to floor 3
										 Down3To2,       -- Elevator is moving down from floor 3 to floor 2
										 Down2To1);      -- Elevator is moving down from floor 2 to floor 1
	signal state : stateType; -- the current state we're in
	signal TIMER_EXPIRE, ENABLE : std_logic; 		-- goes high when timer has reached zero
begin
	DOORSOPENEDTIMER: entity door_timer(BEHAVE) port map(rst, clk, ENABLE, TIMER_EXPIRE);
process (clk, rst)
		variable U1, U2, D2, D3, F1, F2, F3 : std_logic := '0';
		variable lastFloorVisited : stateType;
	begin
		if (rst = '1') then
			state <= ClosingDoors1;
			door <= '1';
			direction <= "00";
			U1 := '0';
			U2 := '0';
			D2 := '0';
			D3 := '0';
			F1 := '0';
			F2 := '0';
			F3 := '0';
			ENABLE <= '0';
		elsif (clk'event and clk = '1') then
			-- latch button inputs when pressed
			if (UP1 = '1') then
				U1 := '1';
			end if;
			if (UP2 = '1') then
				U2 := '1';
			end if;
			if (DOWN2 = '1') then
				D2 := '1';
			end if;
			if (DOWN3 = '1') then
				D3 := '1';
			end if;
			if (FLOOR1 = '1') then
				F1 := '1';
			end if;
			if (FLOOR2 = '1') then
				F2 := '1';
			end if;
			if (FLOOR3 = '1') then
				F3 := '1';
			end if;

			-- change state based on inputs
			case state is
				when OpenedDoors1 =>
					U1 := '0';
					F1 := '0';
					if (TIMER_EXPIRE = '1') then
						state <= ClosingDoors1;
						lastFloorVisited := ClosingDoors1;
						ENABLE <= '0';
--						CLOSE <= '1';
						door <= '1';
						direction <= "00";
					end if;
				when OpenedDoors2 =>
					U2 := '0';
					D2 := '0';
					F2 := '0';
					if (TIMER_EXPIRE = '1') then
						state <= ClosingDoors2;
						--lastFloorVisited := ClosingDoors2;
						ENABLE <= '0';
						door <= '1';
						direction <= "00";
					end if;
				when OpenedDoors3 =>
					D3 := '0';
					F3 := '0';
					if (TIMER_EXPIRE = '1') then
						state <= ClosingDoors3;
						lastFloorVisited := ClosingDoors3;
						ENABLE <= '0';
						door <= '1';
						direction <= "00";
					end if;
				when ClosingDoors1 =>
					if (U1 = '1') then
						state <= OpenedDoors1;
						ENABLE <= '1';
						door <= '0';
						direction <= "00";
					elsif (DC = '1' and 
                 (U2 = '1' or D2 = '1' or D3 = '1' or F2 = '1' or F3 = '1')) then
						state <= Up1To2;
						--ENABLE <= '0';
						door <= '1';
						direction <= "01";
					end if;
				when ClosingDoors2 =>
					if (U2 = '1' or D2 = '1') then
						state <= OpenedDoors2;
						ENABLE <= '1';
						door <= '0';
						direction <= "00";
					elsif (DC = '1') then
            ENABLE <= '0';
						if ((U1 = '1' and D3 = '1') or 
						    (U1 = '1' and F1 = '1') or 
                (F1 = '1' and F3 = '1') or
                (F1 = '1' and D3 = '1')) then
							if (lastFloorVisited = ClosingDoors3) then
								state <= Down2To1;
								door <= '1';
								direction <= "10";
							else
								state <= Up2To3;
								door <= '1';
								direction <= "01";						
              end if;
						elsif (D3 = '1' or F3 = '1') then
							state <= Up2To3;
							door <= '1';
							direction <= "01";
						elsif (U1 = '1' or F1 = '1') then
							state <= Down2To1;
							door <= '1';
							direction <= "10";
						end if;
					end if;
				when ClosingDoors3 =>
					if (D3 = '1') then
						state <= OpenedDoors3;
						ENABLE <= '1';
						door <= '0';
						direction <= "00";
					elsif (DC = '1' and (U1 = '1' or U2 = '1' or D2 = '1' or F1 = '1' or F2 = '1')) then
						state <= Down3To2;
						--ENABLE <= '0';
						door <= '1';
						direction <= "10";
					end if;
				when Up1To2 =>
					if (FS = "10") then
						if (F2 = '1' or U2 = '1' or (D2 = '1' and D3 = '0')) then
							state <= OpenedDoors2;
							ENABLE <= '1';
							door <= '0';
							direction <= "00";
						else
							state <= Up2To3;
							door <= '1';
							direction <= "01";
						end if;
					end if;
				when Up2To3 =>
					if (FS = "11") then
						state <= OpenedDoors3;
						ENABLE <= '1';
						door <= '0';
						direction <= "00";
					end if;
				when Down3To2 =>
					if (FS = "10") then
						if (F2 = '1' or D2 = '1' or (U2 = '1' and U1 = '0')) then
							state <= OpenedDoors2;
							ENABLE <= '1';
							door <= '0';
							direction <= "00";
						else
							state <= Down2To1;
							door <= '1';
							direction <= "10";
						end if;
					end if;
				when Down2To1 =>
					if (FS = "01") then
						state <= OpenedDoors1;
						ENABLE <= '1';
						door <= '0';
						direction <= "00";
					end if;
			end case;
		end if;
	end process;

end architecture;
