--------------------------------------------------------------------------------
-- Outputs '1' if all of the incoming bits are '0'
--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity ZeroDetector16 is
	port (
		I : in  STD_LOGIC_VECTOR (15 downto 0);
		O : out  STD_LOGIC);
end ZeroDetector16;

architecture struct of ZeroDetector16 is
	
	component LUT4 is
		generic(
			INIT: BIT_VECTOR(15 downto 0) := X"FFFF");
		port(
			I0	: in 	STD_LOGIC;
			I1	: in 	STD_LOGIC;
			I2	: in 	STD_LOGIC;
			I3	: in 	STD_LOGIC;
			O 	: out	STD_LOGIC);
	end component;
	
	signal
		L_zero_buf : std_logic_vector(3 downto 0);
begin

	z0_3: LUT4
		generic map(
			INIT => X"0001")
		port map(
			I0 	=> I(0),
			I1 	=> I(1),
			I2 	=> I(2),
			I3 	=> I(3),
			O 	=> L_zero_buf(0));
	z4_7: LUT4
		generic map(
			INIT => X"0001")
		port map(
			I0 	=> I(4),
			I1 	=> I(5),
			I2 	=> I(6),
			I3 	=> I(7),
			O 	=> L_zero_buf(1));
	z8_11: LUT4
		generic map(
			INIT => X"0001")
		port map(
			I0 	=> I(8),
			I1 	=> I(9),
			I2 	=> I(10),
			I3 	=> I(11),
			O 	=> L_zero_buf(2));
	z12_15: LUT4
		generic map(
			INIT => X"0001")
		port map(
			I0 	=> I(12),
			I1 	=> I(13),
			I2 	=> I(14),
			I3 	=> I(15),
			O 	=> L_zero_buf(3));
	zFINAL: LUT4
		generic map(
			INIT => X"8000")
		port map(
			I0 	=> L_zero_buf(0),
			I1 	=> L_zero_buf(1),
			I2 	=> L_zero_buf(2),
			I3 	=> L_zero_buf(3),
			O 	=> O);
end struct;