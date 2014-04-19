use WORK.all;
library ieee;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_1164.all;
use std.TEXTIO.all;

entity ELEVATOR_TEST_BENCH is
end ELEVATOR_TEST_BENCH;

library ieee;
use IEEE.std_logic_1164.all;


architecture TEST of ELEVATOR_TEST_BENCH is
 	signal rst, U1, U2, D2, D3, F1, F2, F3, DC: std_logic := '0';
	signal FS : std_logic_vector(1 downto 0);
	signal door : std_logic := '0';
	signal direction : std_logic_vector(1 downto 0);
	signal clk : std_logic := '0';
	--signal CLOSE : std_logic;
	--resignal DOORSCLOSED : std_logic;
begin
	DUT: entity elevator(behavioral) port map(clk, rst, U1, U2, D2, D3, F1, F2, F3, DC, FS, door, direction);		
	DOORSCLOSING: entity DOOR_SENSOR(BEHAVE) port map(RESET => rst, CLK => clk, CLOSE => door, DOORSCLOSED => DC);  
  process(clk)
  begin
    clk <= not clk after 5 ns;
  end process;
  process
    variable VLINE: LINE;
		variable VIN_RST, VIN_U1, VIN_U2, VIN_D2, VIN_D3, VIN_F1, VIN_F2, VIN_F3, VIN_DOOR: std_logic;
--variable VIN_RST, VIN_U1, VIN_U2, VIN_D2, VIN_D3, VIN_F1, VIN_F2, VIN_F3, VIN_DC, VIN_DOOR: std_logic;
		variable VIN_FS, VIN_DIRECTION: std_logic_vector(1 downto 0);
    file INVECT : TEXT is "elevatorInput_NEW.txt";
  begin
    READLINE(INVECT, VLINE);
    while not(ENDFILE(INVECT)) loop
      wait until clk = '0';
      READLINE(INVECT, VLINE);
			READ(VLINE, VIN_RST);
			READ(VLINE, VIN_U1);
			READ(VLINE, VIN_U2);	
			READ(VLINE, VIN_D2);
			READ(VLINE, VIN_D3);
			READ(VLINE, VIN_F1);
			READ(VLINE, VIN_F2);
			READ(VLINE, VIN_F3);
			--READ(VLINE, VIN_DC);
			READ(VLINE, VIN_FS);
			READ(VLINE, VIN_DOOR);
			READ(VLINE, VIN_DIRECTION);
			rst <= VIN_RST;
	    U1 <= VIN_U1;
			U2 <= VIN_U2;
			D2 <= VIN_D2;
			D3 <= VIN_D3;
	    F1 <= VIN_F1;
			F2 <= VIN_F2;
			F3 <= VIN_F3;
			--DC <= VIN_DC;
			FS(0) <= VIN_FS(0);
			FS(1) <= VIN_FS(1);
			--DEBUG <= VOUT;
			--INPUT <= VIN2;
      wait until CLK = '1';
      wait for 2 ns;
      assert (door = VIN_DOOR) 
      	report "Door (open/closed) not expected value"
        severity WARNING;
			assert (direction = VIN_DIRECTION)
				report "Direction not expected value"
				severity WARNING;		        
    end loop; 
    wait;
  end process;
end TEST;