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
	signal state : stateType;
begin

	process (clk)
	begin
		if (clk'event and clk = '1') then
			-- TODO: change state based on inputs

			-- update outputs based on state
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
