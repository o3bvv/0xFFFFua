----------------------------------------------------------------------------------
-- Register File
-- 32x16-bit registers 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RF is
	port (
		I_CLK 		: in	STD_LOGIC;						-- clock
		I_WR 		: in	STD_LOGIC;						-- write to reg. B
		I_AB_INC	: in	STD_LOGIC;						-- inc. reg. B addr.
		I_AC_INC	: in	STD_LOGIC;						-- inc. reg. C addr.
		I_AB 		: in	STD_LOGIC_VECTOR (4 downto 0);	-- reg. B addr.
		I_AC 		: in	STD_LOGIC_VECTOR (4 downto 0);	-- reg. C addr.
		I_AD 		: in	STD_LOGIC_VECTOR (4 downto 0);	-- reg. D addr.
		I_B			: in	STD_LOGIC_VECTOR (15 downto 0);	-- reg. B data
		O_C			: out	STD_LOGIC_VECTOR (15 downto 0);	-- reg. C data
		O_D			: out	STD_LOGIC_VECTOR (15 downto 0));-- reg. D data
end RF;

architecture Behavioral of RF is

	type MATRIX32x16 is array(31 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
	
	signal RF_body	: MATRIX32x16 	:= (others=> (others=>'0'));
	signal L_clk	: STD_LOGIC		:= 'Z';
begin
	
	process(I_CLK)
	begin
		L_clk <= I_CLK after 1 ns;
	end process;
	
	process(L_clk, I_AC, I_AD, I_AB_INC, I_AC_INC, RF_body)
		variable
			v_addr_b,
			v_addr_c,
			v_addr_d : natural range 0 to 31;
	begin		
	
		v_addr_d	:= TO_INTEGER(UNSIGNED(I_AD));
	
		if (I_AB_INC = '1') then
			v_addr_b := TO_INTEGER(UNSIGNED(I_AB)+1);
		else
			v_addr_b := TO_INTEGER(UNSIGNED(I_AB));
		end if;
		
		if (I_AC_INC = '1') then
			v_addr_c := TO_INTEGER(UNSIGNED(I_AC)+1);
		else
			v_addr_c := TO_INTEGER(UNSIGNED(I_AC));
		end if;
		
		if (L_clk='1' and L_clk'event and I_WR='1') then
			RF_body(v_addr_b) <= I_B;
		end if;
		
		O_C <= RF_body(v_addr_c);
		O_D <= RF_body(v_addr_d);
	end process;
	
end Behavioral;

