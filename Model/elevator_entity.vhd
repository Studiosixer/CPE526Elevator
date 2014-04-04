-- Elevator Controller
-- CPE 526
-- Taixing Bi (Hunter), Wesley Eledui, Justin Gay, John Wilkes

Library IEEE;
use ieee.std_logic_1164.all;

entity elevator is
	----- inputs -----
	-- clk - clock
	-- U1  - floor 1 up external button
	-- U2  - floor 2 up external button
	-- D2  - floor 2 down external button
	-- D3  - floor 3 down external button
	-- F1  - floor 1 internal button
	-- F2	 - floor 2 internal button
	-- F3  - floor 3 internal button
	-- DC  - doors closed sensor
	-- FS  - floor sensor (2 bits)
	--   00 - invalid
	--   01 - floor 1
	--   10 - floor 2
	--   11 - floor 3

	----- outputs -----
	-- door - open/close doors (2 bits)
	-- 	 0 - open
	--   1 - close
	-- direction - elevator direction (2 bits)
	--   00 - stationary
	--   01 - up
	--   10 - down
	--   11 - invalid

	port(clk, U1, U2, D2, D3, F1, F2, F3, DC : in std_logic;
			 FS : in std_logic_vector(1 downto 0);
			 door : out std_logic;
			 direction : out std_logic_vector(1 downto 0));
end elevator;
