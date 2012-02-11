----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX3x16 is
	port (
		I0 		: in	STD_LOGIC_VECTOR (15 downto 0);
		I1 		: in	STD_LOGIC_VECTOR (15 downto 0);
		I2 		: in	STD_LOGIC_VECTOR (15 downto 0);
		I_ADDR 	: in	STD_LOGIC_VECTOR (1 downto 0);
		O 		: out	STD_LOGIC_VECTOR (15 downto 0));
end MUX3x16;

architecture struct of MUX3x16 is
	
	component MUX3 is
		port (
			I0		: in	STD_LOGIC;
			I1		: in	STD_LOGIC;
			I2		: in	STD_LOGIC;
			I_ADDR	: in	STD_LOGIC_VECTOR (1 downto 0);
			O		: out	STD_LOGIC);
	end component;
begin

	MAIN : for i in 0 to 15
	generate
		MUX: MUX3
			port map(
				I_ADDR 	=> I_ADDR,
				I0		=> I0(i),
				I1		=> I1(i),
				I2		=> I2(i),
				O	 	=> O(i));
	end generate;

end struct;

