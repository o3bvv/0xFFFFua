----------------------------------------------------------------------------------
-- RAM
-- 2Kx16bit
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity RAM2Kx16 is
	port (
		I_CLK	: in	STD_LOGIC;
		I_RST	: in	STD_LOGIC;
		I_WR	: in	STD_LOGIC;
		I_ADDR	: in	STD_LOGIC_VECTOR (10 downto 0);
		I_DATA	: in	STD_LOGIC_VECTOR (15 downto 0);
		O_DATA	: out	STD_LOGIC_VECTOR (15 downto 0));
end RAM2Kx16;

architecture struct of RAM2Kx16 is
	
	component MUX8 is
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
	end component;
	
	component DC3 is
		port (
			I0	 : in	STD_LOGIC;
			I1	 : in	STD_LOGIC;
			I2	 : in	STD_LOGIC;
			O	 : out	STD_LOGIC_VECTOR (7 downto 0));
	end component;

	component RAMB4_S16 is
	
		generic (
			INIT_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_08 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_09 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
			INIT_0F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000");
			
		port (
			DI: in STD_LOGIC_VECTOR (15 downto 0);
			EN : in STD_ULOGIC;
			WE : in STD_ULOGIC;
			RST : in STD_ULOGIC;
			CLK : in STD_ULOGIC;
			ADDR: in STD_LOGIC_VECTOR (7 downto 0);
			DO : out STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	type SLV8x16 is 
		array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
	
	signal RAM_out	: SLV8x16;
	
	signal RAM_cs	: STD_LOGIC_VECTOR(7 downto 0);
	signal RAM_we	: STD_LOGIC_VECTOR(7 downto 0);

	constant L_GND	: STD_LOGIC := '0';
	constant L_VCC	: STD_LOGIC := '1';
	
	type SLV128x256 is 
		array(0 to 128) of bit_vector(255 downto 0);
	
	constant RAM_init : SLV128x256 := (
		others => X"0000000000000000000000000000000000000000000000000000000000000000");
begin

	ADDR_DECODER: DC3
		port map (
			I0	 => I_ADDR(8),
			I1	 => I_ADDR(9),
			I2	 => I_ADDR(10),
			O	 => RAM_cs);

	MAIN : for i in 0 to 7
	generate
		RAM_we(i) <= RAM_cs(i) and I_WR;
		
		RAM_UNIT: RAMB4_S16 
			generic map(
				INIT_00 => RAM_init(16*i+0),
				INIT_01 => RAM_init(16*i+1),
				INIT_02 => RAM_init(16*i+2),
				INIT_03 => RAM_init(16*i+3),
				INIT_04 => RAM_init(16*i+4),
				INIT_05 => RAM_init(16*i+5),
				INIT_06 => RAM_init(16*i+6),
				INIT_07 => RAM_init(16*i+7),
				INIT_08 => RAM_init(16*i+8),
				INIT_09 => RAM_init(16*i+9),
				INIT_0A => RAM_init(16*i+10),
				INIT_0B => RAM_init(16*i+11),
				INIT_0C => RAM_init(16*i+12),
				INIT_0D => RAM_init(16*i+13),
				INIT_0E => RAM_init(16*i+14),
				INIT_0F => RAM_init(16*i+15))
			port map (
				CLK		=> I_CLK,
				RST 	=> I_RST,
				EN		=> L_VCC,
				WE 		=> RAM_we(i),
				DI		=> I_DATA,
				ADDR 	=> I_ADDR(7 downto 0),
				DO 		=> RAM_out(i));
	end generate;
	
	OUTPUT : for i in 0 to 15 generate
		MUX_UNIT: MUX8
			port map (
				I7		=> RAM_out(7)(i),
				I6		=> RAM_out(6)(i),
				I5		=> RAM_out(5)(i),
				I4		=> RAM_out(4)(i),
				I3		=> RAM_out(3)(i),
				I2		=> RAM_out(2)(i),
				I1		=> RAM_out(1)(i),
				I0		=> RAM_out(0)(i),
				I_ADDR	=> I_ADDR(10 downto 8),
				O 		=> O_DATA(i));
	end generate;
end struct;

