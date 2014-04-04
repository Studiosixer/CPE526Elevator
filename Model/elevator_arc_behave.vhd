-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

architecture behavioral of elevator is
	type stateType is (FloorStop1,           -- Elevator has stopped on floor 1
										 FloorStop2,           -- Elevator has stopped on floor 2
										 FloorStop3,           -- Elevator has stopped on floor 3
										 WaitForClosedDoors1,  -- Waiting for doors to close on floor 1
										 WaitForClosedDoors2,  -- Waiting for doors to close on floor 2
										 WaitForClosedDoors3,  -- Waiting for doors to close on floor 3
										 Up1To2,               -- Elevator is moving up from floor 1 to floor 2
										 Up2To3,               -- Elevator is moving up from floor 2 to floor 3
										 Down3To2,             -- Elevator is moving down from floor 3 to floor 2
										 Down2To1);            -- Elevator is moving down from floor 2 to floor 1
begin

	process (clk)
		variable state : stateType;
	begin
		if (clk'event and clk = '1') then
			-- change state based on inputs
			case state is
				when FloorStop1 =>
					if (U2 = '1' or D2 = '1' or D3 = '1' or F2 = '1' or F3 = '1') then
						state := WaitForClosedDoors1;
					end if;
				when FloorStop2 =>
					if (U1 = '1' or D3 = '1' or F1 = '1' or F3 = '1') then
						state := WaitForClosedDoors2;
					end if;
				when FloorStop3 =>
					if (U1 = '1' or U2 = '1' or D2 = '1' or F1 = '1' or F2 = '1') then
						state := WaitForClosedDoors3;
					end if;
				when WaitForClosedDoors1 =>
					if (DC = '1') then
						state := Up1To2;
					end if;
				when WaitForClosedDoors2 =>
					if (DC = '1') then
						if (D3 = '1' or F3 = '1') then
							state := Up2To3;
						elsif (U1 = '1' or F1 = '1') then
							state := Down2To1;
						end if;
					end if;
				when WaitForClosedDoors3 =>
					if (DC = '1') then
						state := Down3To2;
					end if;
				when Up1To2 =>
					if (FS = "10") then
						if (F2 = '1' or U2 = '1') then
							state := FloorStop2;
						else
							state := Up2To3;
						end if;
					end if;
				when Up2To3 =>
					if (FS = "11") then
						state := FloorStop3;
					end if;
				when Down3To2 =>
					if (FS = "10") then
						if (F2 = '1' or D2 = '1') then
							state := FloorStop2;
						else
							state := Down2To1;
						end if;
					end if;
				when Down2To1 =>
					if (FS = "01") then
						state := FloorStop1;
					end if;
			end case;

			-- update outputs based on new state
			case state is
				when FloorStop1 =>
					door <= '0';
					direction <= "00";
				when FloorStop2 =>
					door <= '0';
					direction <= "00";
				when FloorStop3 =>
					door <= '0';
					direction <= "00";
				when WaitForClosedDoors1 =>
					door <= '1';
					direction <= "00";
				when WaitForClosedDoors2 =>
					door <= '1';
					direction <= "00";
				when WaitForClosedDoors3 =>
					door <= '1';
					direction <= "00";
				when Up1To2 =>
					door <= '1';
					direction <= "01";
				when Up2To3 =>
					door <= '1';
					direction <= "01";
				when Down3To2 =>
					door <= '1';
					direction <= "10";
				when Down2To1 =>
					door <= '1';
					direction <= "10";
			end case;
		end if;
	end process;

end architecture;
