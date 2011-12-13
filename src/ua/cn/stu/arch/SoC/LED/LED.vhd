----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LED is
	port (
		I_RST 	: in	STD_LOGIC;
		I_E 	: in	STD_LOGIC;
		I_WR 	: in	STD_LOGIC;
		I_DATA	: in	STD_LOGIC_VECTOR(7 downto 0);
		O_LED	: out	STD_LOGIC_VECTOR(7 downto 0));
end LED;

architecture Behavioral of LED is
	constant C_GND8	: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
	signal L_led	: STD_LOGIC_VECTOR(7 downto 0) := C_GND8;
begin
	process(I_RST)
	begin
		if (I_RST='1') then
			L_led <= C_GND8;
		elsif (I_E='1' and I_WR='1') then
			L_led <= I_DATA;
		end if;
	end process;

	O_LED <= L_led;
end Behavioral;

