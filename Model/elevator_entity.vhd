Library IEEE;
use ieee.std_logic_1164.all;

entity elevator is
	port(U1, U2, D2, D3, F1, F2, F3, DC, FS : in std_logic;
			 door : out std_logic;
			 direction : out std_logic_vector(1 downto 0));
end elevator;