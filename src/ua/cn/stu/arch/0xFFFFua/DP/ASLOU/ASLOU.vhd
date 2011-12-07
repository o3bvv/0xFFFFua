--------------------------------------------------------------------------------
-- Addition, Substraction and Logical Operations Unit
--
-- [operation] : [function's code]
--  A  +  B : 000
--  A  -  B : 001
--  A and B : 010
--  A or  B : 011
--  A xor B : 100
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity ASLOU is
	port (
		I_F :	in  	STD_LOGIC_VECTOR (2 downto 0);	-- function
		I_A :	in  	STD_LOGIC_VECTOR (15 downto 0);	-- 1-st operand
		I_B :	in  	STD_LOGIC_VECTOR (15 downto 0);	-- 2-nd operand
		I_C : 	in  	STD_LOGIC;						-- carry in
		O_Y : 	out  	STD_LOGIC_VECTOR (15 downto 0);	-- result
		O_C : 	out  	STD_LOGIC;						-- carry out
		O_Z : 	out  	STD_LOGIC);						-- zero result flag
end ASLOU;

architecture struct of ASLOU is
	
	component LUT2 is
		generic(
			INIT: BIT_VECTOR(3 downto 0) := X"F");
		port(
			I0	: in 	STD_LOGIC;
			I1	: in 	STD_LOGIC;
			O 	: out	STD_LOGIC);
	end component;

	component LUT3 is
		generic(
			INIT: BIT_VECTOR(7 downto 0) := X"FF");
		port(
			I0	: in 	STD_LOGIC;
			I1	: in 	STD_LOGIC;
			I2	: in 	STD_LOGIC;
			O 	: out	STD_LOGIC);
	end component;

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

	component ZeroDetector16 is
		port (
			I : in  STD_LOGIC_VECTOR (15 downto 0);
			O : out  STD_LOGIC);
	end component;
	
	signal 
		L_res_primary,
		L_res_final	: std_logic_vector(15 downto 0);
	signal 
		L_carry_buf	: std_logic_vector(16 downto 0);
begin

	MAIN: for i in 0 to 15
	generate
		PRIMARY_RESULT_UNIT: LUT4
			generic map(
				INIT => X"E866")
			port map(
				I0 	=> I_A(i),
				I1 	=> I_B(i),
				I2 	=> I_F(0),
				I3 	=> I_F(1),
				O 	=> L_res_primary(i));
		CARRY_FORMER_UNIT: LUT4
			generic map(
				INIT => X"D4E8")
			port map(
				I0 	=> I_A(i),
				I1 	=> I_B(i),
				I2 	=> L_carry_buf(i),
				I3 	=> I_F(0),
				O 	=> L_carry_buf(i+1));
		FINAL_RESULT_UNIT: LUT4
			generic map(
				INIT => X"0AA6")
			port map(
				I0 	=> L_res_primary(i),
				I1 	=> L_carry_buf(i),
				I2 	=> I_F(1),
				I3 	=> I_F(2),
				O 	=> L_res_final(i));
	end generate;
	
	ZeroDetector: ZeroDetector16
		port map(
			I => L_res_final,
			O => O_Z);
	
	O_Y <= L_res_final;
	L_carry_buf(0) <= I_C;
	O_C <= L_carry_buf(16);
	
end struct;