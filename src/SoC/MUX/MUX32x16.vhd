---------------------------------------------------------------------------------- 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX32x16 is
	port (
		I_ADDR 	: in  	STD_LOGIC_VECTOR (4 downto 0);
		I0		: in	STD_LOGIC_VECTOR (15 downto 0);
		I1		: in	STD_LOGIC_VECTOR (15 downto 0);
		I2		: in	STD_LOGIC_VECTOR (15 downto 0);
		I3		: in	STD_LOGIC_VECTOR (15 downto 0);
		I4		: in	STD_LOGIC_VECTOR (15 downto 0);
		I5		: in	STD_LOGIC_VECTOR (15 downto 0);
		I6		: in	STD_LOGIC_VECTOR (15 downto 0);
		I7		: in	STD_LOGIC_VECTOR (15 downto 0);
		I8		: in	STD_LOGIC_VECTOR (15 downto 0);
		I9		: in	STD_LOGIC_VECTOR (15 downto 0);
		I10		: in	STD_LOGIC_VECTOR (15 downto 0);
		I11		: in	STD_LOGIC_VECTOR (15 downto 0);
		I12		: in	STD_LOGIC_VECTOR (15 downto 0);
		I13		: in	STD_LOGIC_VECTOR (15 downto 0);
		I14		: in	STD_LOGIC_VECTOR (15 downto 0);
		I15		: in	STD_LOGIC_VECTOR (15 downto 0);
		I16		: in	STD_LOGIC_VECTOR (15 downto 0);
		I17		: in	STD_LOGIC_VECTOR (15 downto 0);
		I18		: in	STD_LOGIC_VECTOR (15 downto 0);
		I19		: in	STD_LOGIC_VECTOR (15 downto 0);
		I20		: in	STD_LOGIC_VECTOR (15 downto 0);
		I21		: in	STD_LOGIC_VECTOR (15 downto 0);
		I22		: in	STD_LOGIC_VECTOR (15 downto 0);
		I23		: in	STD_LOGIC_VECTOR (15 downto 0);
		I24		: in	STD_LOGIC_VECTOR (15 downto 0);
		I25		: in	STD_LOGIC_VECTOR (15 downto 0);
		I26		: in	STD_LOGIC_VECTOR (15 downto 0);
		I27		: in	STD_LOGIC_VECTOR (15 downto 0);
		I28		: in	STD_LOGIC_VECTOR (15 downto 0);
		I29		: in	STD_LOGIC_VECTOR (15 downto 0);
		I30		: in	STD_LOGIC_VECTOR (15 downto 0);
		I31		: in	STD_LOGIC_VECTOR (15 downto 0);
		O		: out	STD_LOGIC_VECTOR (15 downto 0));
end MUX32x16;

architecture struct of MUX32x16 is
	
	component MUX32 is
		port (
			I_ADDR 	: in  	STD_LOGIC_VECTOR (4 downto 0);
			I0		: in	STD_LOGIC;
			I1		: in	STD_LOGIC;
			I2		: in	STD_LOGIC;
			I3		: in	STD_LOGIC;
			I4		: in	STD_LOGIC;
			I5		: in	STD_LOGIC;
			I6		: in	STD_LOGIC;
			I7		: in	STD_LOGIC;
			I8		: in	STD_LOGIC;
			I9		: in	STD_LOGIC;
			I10		: in	STD_LOGIC;
			I11		: in	STD_LOGIC;
			I12		: in	STD_LOGIC;
			I13		: in	STD_LOGIC;
			I14		: in	STD_LOGIC;
			I15		: in	STD_LOGIC;
			I16		: in	STD_LOGIC;
			I17		: in	STD_LOGIC;
			I18		: in	STD_LOGIC;
			I19		: in	STD_LOGIC;
			I20		: in	STD_LOGIC;
			I21		: in	STD_LOGIC;
			I22		: in	STD_LOGIC;
			I23		: in	STD_LOGIC;
			I24		: in	STD_LOGIC;
			I25		: in	STD_LOGIC;
			I26		: in	STD_LOGIC;
			I27		: in	STD_LOGIC;
			I28		: in	STD_LOGIC;
			I29		: in	STD_LOGIC;
			I30		: in	STD_LOGIC;
			I31		: in	STD_LOGIC;
			O		: out	STD_LOGIC);
	end component;
begin
	
	OUTPUT: for i in 0 to 15 generate
		MUX: MUX32
			port map (
				I_ADDR	=> I_ADDR,
				I0 		=> I0(i),
				I1 		=> I1(i),
				I2 		=> I2(i),
				I3 		=> I3(i),
				I4		=> I4(i),
				I5 		=> I5(i),
				I6 		=> I6(i),
				I7 		=> I7(i),
				I8 		=> I8(i),
				I9 		=> I9(i),
				I10 	=> I10(i),
				I11 	=> I11(i),
				I12 	=> I12(i),
				I13 	=> I13(i),
				I14 	=> I14(i),
				I15 	=> I15(i),
				I16 	=> I16(i),
				I17 	=> I17(i),
				I18 	=> I18(i),
				I19 	=> I19(i),
				I20 	=> I20(i),
				I21 	=> I21(i),
				I22 	=> I22(i),
				I23 	=> I23(i),
				I24 	=> I24(i),
				I25 	=> I25(i),
				I26 	=> I26(i),
				I27 	=> I27(i),
				I28 	=> I28(i),
				I29 	=> I29(i),
				I30 	=> I30(i),
				I31 	=> I31(i),
				O 		=> O(i));
	end generate;

end struct;

