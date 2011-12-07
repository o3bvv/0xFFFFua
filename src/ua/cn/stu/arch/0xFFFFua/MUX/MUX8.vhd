library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity MUX8 is
	port ( 
		I0 		: in  STD_LOGIC;
		I1 		: in  STD_LOGIC;
		I2 		: in  STD_LOGIC;
		I3 		: in  STD_LOGIC;
		I4 		: in  STD_LOGIC;
		I5 		: in  STD_LOGIC;
		I6 		: in  STD_LOGIC;
		I7 		: in  STD_LOGIC;
		I_ADDR 	: in  STD_LOGIC_VECTOR (2 downto 0);
		O		: out STD_LOGIC);
end MUX8;

architecture struct_LUT_3 of MUX8 is
	
	component LUT3 is
		generic(
			INIT : BIT_VECTOR := X"00");
		port(
			O : out STD_ULOGIC;
			I0 : in STD_ULOGIC;
			I1 : in STD_ULOGIC;
			I2 : in STD_ULOGIC);
	end component;
	
	signal primary_out	: STD_LOGIC_VECTOR (3 downto 0);
	signal secondary_out: STD_LOGIC_VECTOR (1 downto 0);

begin
	
	PRIMARY_OUT_0 : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR(0),
			I1	=> I0,
			I2	=> I1,
			O	=> primary_out(0));
	PRIMARY_OUT_1 : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR(0),
			I1	=> I2,
			I2	=> I3,
			O	=> primary_out(1));
	PRIMARY_OUT_2 : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR(0),
			I1	=> I4,
			I2	=> I5,
			O	=> primary_out(2));
	PRIMARY_OUT_3 : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR(0),
			I1	=> I6,
			I2	=> I7,
			O	=> primary_out(3));
			
	SECONDARY_OUT_0 : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR(1),
			I1	=> primary_out(0),
			I2	=> primary_out(1),
			O	=> secondary_out(0));
	SECONDARY_OUT_1 : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR(1),
			I1	=> primary_out(2),
			I2	=> primary_out(3),
			O	=> secondary_out(1));
	
	FINAL_OUT : LUT3
		generic map(
			INIT => X"E4")
		port map(
			I0	=> I_ADDR(2),
			I1	=> secondary_out(0),
			I2	=> secondary_out(1),
			O	=> O);
end struct_LUT_3;