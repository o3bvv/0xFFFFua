----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity MUX2 is
	port (
		I0 		: in	STD_LOGIC;
		I1 		: in	STD_LOGIC;
		I_ADDR 	: in	STD_LOGIC;
		O 		: out	STD_LOGIC);
end MUX2;

architecture struct of MUX2 is
	
	component LUT3 is
		generic(
			INIT : BIT_VECTOR := X"00");
		port(
			O : out STD_ULOGIC;
			I0 : in STD_ULOGIC;
			I1 : in STD_ULOGIC;
			I2 : in STD_ULOGIC);
	end component;
begin

	OUTPUT : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR,
			I1	=> I0,
			I2	=> I1,
			O	=> O);
end struct;

