----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity MUX3 is
	port (
		I0		: in	STD_LOGIC;
		I1		: in	STD_LOGIC;
		I2		: in	STD_LOGIC;
		I_ADDR	: in	STD_LOGIC_VECTOR (1 downto 0);
		O		: out	STD_LOGIC);
end MUX3;

architecture struct of MUX3 is
	
	component LUT3 is
		generic(
			INIT : BIT_VECTOR := X"00");
		port(
			O : out STD_ULOGIC;
			I0 : in STD_ULOGIC;
			I1 : in STD_ULOGIC;
			I2 : in STD_ULOGIC);
	end component;
	
	signal L_primary_result : STD_LOGIC;
begin

	PRIMARY : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR(0),
			I1	=> I0,
			I2	=> I1,
			O	=> L_primary_result);
			
	OUTPUT : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR(1),
			I1	=> L_primary_result,
			I2	=> I2,
			O	=> O);
end struct;

