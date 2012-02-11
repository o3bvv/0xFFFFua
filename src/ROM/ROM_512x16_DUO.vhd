library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library UNISIM;
use UNISIM.VComponents.ALL;

entity ROM_512x16_DUO is
	port (		
		I_CLK	: in	STD_LOGIC; 						-- CLOCK
		
		I_ADDR	: in	STD_LOGIC_VECTOR (8 downto 0);  -- ADDRESS
				
		O_DATA0	: out	STD_LOGIC_VECTOR (15 downto 0);	-- CURRENT ADDRESS DATA
		O_DATA1	: out	STD_LOGIC_VECTOR (15 downto 0));-- NEXT    ADDRESS DATA
end ROM_512x16_DUO;

architecture arch of ROM_512x16_DUO is

	component ROM is
		PORT (
			clka  : IN  STD_LOGIC;
			addra : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			clkb  : IN  STD_LOGIC;
			addrb : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
			doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	end component;
	
	constant L_GND    : STD_LOGIC := '0';
	constant L_VCC	  : STD_LOGIC := '1';
	constant L_GND_16 : STD_LOGIC_VECTOR(15 downto 0) := (others => L_GND);	
	
	type SLV2x16 is 
		array(0 to 1) of STD_LOGIC_VECTOR(15 downto 0);
	type SLV2x9 is 
		array(0 to 1) of STD_LOGIC_VECTOR(8 downto 0);
	
	signal ROM_out	: SLV2x16 := (others => (others => L_GND));
	signal ROM_addr	: SLV2x9  := (others => (others => L_GND));	
begin

	process(I_ADDR, I_CLK)
	begin
		
		ROM_addr(0) <= I_ADDR;
		ROM_addr(1) <= conv_std_logic_vector(
				UNSIGNED(I_ADDR)+1, ROM_addr(1)'length);
	end process;
	
	ROM_UNIT: ROM
		port map (
			clka  => I_CLK,
			addra => ROM_addr(0),
			douta => ROM_out(0),
			clkb  => I_CLK,
			addrb => ROM_addr(1),
			doutb => ROM_out(1));
	
	O_DATA0 <= ROM_out(0);
	O_DATA1 <= ROM_out(1);
end arch;

