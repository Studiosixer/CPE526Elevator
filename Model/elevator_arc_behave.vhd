-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

architecture behavioral of elevator is
	type stateType is (FloorStop1, FloorStop2, FloorStop3, CloseDoors1, CloseDoors2, CloseDoors3,
										 Up1To2, Up2To3, Down3To2, Down2To1);
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
				when CloseDoors1 =>
					door <= '1';
					direction <= "00";
				when CloseDoors2 =>
					door <= '1';
					direction <= "00";
				when CloseDoors3 =>
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
