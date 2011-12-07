library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity DC3 is
	port (
		I0	 : in	STD_LOGIC;
		I1	 : in	STD_LOGIC;
		I2	 : in	STD_LOGIC;
		O	 : out	STD_LOGIC_VECTOR (7 downto 0));
end DC3;

architecture struct of DC3 is
	
	component LUT3 is
		generic(
			INIT: bit_vector(7 downto 0) := X"FF");
		port(
			I0	: in	STD_LOGIC;
			I1	: in	STD_LOGIC;
			I2	: in	STD_LOGIC;
			O	: out	STD_LOGIC);
	end component;

begin

	OUT_0 : LUT3 
		generic map(
			INIT => X"01")
		port map(
			I0	=> I0,
			I1	=> I1,
			I2	=> I2,
			O	=> O(0));
	OUT_1 : LUT3 
		generic map(
			INIT => X"02")
		port map(
			I0	=> I0,
			I1	=> I1,
			I2	=> I2,
			O	=> O(1));
	OUT_2 : LUT3 
		generic map(
			INIT => X"04")
		port map(
			I0	=> I0,
			I1	=> I1,
			I2	=> I2,
			O	=> O(2));
	OUT_3 : LUT3 
		generic map(
			INIT => X"08")
		port map(
			I0	=> I0,
			I1	=> I1,
			I2	=> I2,
			O	=> O(3));
	OUT_4 : LUT3 
		generic map(
			INIT => X"10")
		port map(
			I0	=> I0,
			I1	=> I1,
			I2	=> I2,
			O	=> O(4));
	OUT_5 : LUT3 
		generic map(
			INIT => X"20")
		port map(
			I0	=> I0,
			I1	=> I1,
			I2	=> I2,
			O	=> O(5));
	OUT_6 : LUT3 
		generic map(
			INIT => X"40")
		port map(
			I0	=> I0,
			I1	=> I1,
			I2	=> I2,
			O	=> O(6));
	OUT_7 : LUT3 
		generic map(
			INIT => X"80")
		port map(
			I0	=> I0,
			I1	=> I1,
			I2	=> I2,
			O	=> O(7));
end struct;

