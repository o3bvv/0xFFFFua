----------------------------------------------------------------------------------
-- Instruction pointer with 32-depth stack
-- F values:
-- 000 : do nothing [NOP]
-- 001 : increment current address by 1
-- 010 : push current address+1 and CZ to stack. Set current address = I_ADDR [CALL]
-- 011 : pop value from stack to current address and CZ [RET]
-- 100 : set current address = I_ADDR [JMPL]
-- 101 : add to current address I_OFFSET value. I_OFFSET is signed [JMP]
-- 110 : increment current address by 2
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity IP is
	port (
		-- CLOCK
		I_CLK	: 	in	STD_LOGIC;
		
		-- RESET
		I_RST	: 	in	STD_LOGIC;
		
		-- FUNCTION
		F 		: 	in	STD_LOGIC_VECTOR (2 downto 0);
		
		-- ADDRESS/OFFSET
		I_DATA	: 	in	STD_LOGIC_VECTOR (9 downto 0);
		
		-- CARRY/ZERO flags
		I_CZ 	: 	in	STD_LOGIC_VECTOR (1 downto 0);
		O_CZ 	: 	out	STD_LOGIC_VECTOR (1 downto 0);
		
		-- ADDRESS
		O_ADDR 	: 	out	STD_LOGIC_VECTOR (9 downto 0));
end IP;

architecture Behavioral of IP is
	type MATRIX32x12 is array(31 downto 0) of STD_LOGIC_VECTOR (11 downto 0);
	
	signal ST_body		: MATRIX32x12 := (others=> (others=>'0'));
	signal ST_ptr 		: integer range 0 to 32 := 0;
	
	signal L_cz 		: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
	signal L_addr 		: STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	signal L_addr_next_1: STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
	signal L_addr_next_2: STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
begin

	L_addr_proc: process(L_addr)
	begin
		L_addr_next_1 <= conv_std_logic_vector(UNSIGNED(L_addr) + 1, L_addr_next_1'length);
		L_addr_next_2 <= conv_std_logic_vector(UNSIGNED(L_addr) + 2, L_addr_next_2'length);
	end process;
	
	main: process(I_CLK, I_RST)
	begin
		if (I_RST='1') then
			ST_ptr <= 0;
			L_addr <= (others => '0');
		elsif(I_CLK='1' and I_CLK'event) then
			case f is
				when "001" => L_addr <= L_addr_next_1;
				when "110" => L_addr <= L_addr_next_2;
				when "010" => 
					ST_body(ST_ptr) <= I_CZ & L_addr_next_1;
					L_addr	<= I_DATA;
					ST_ptr	<= ST_ptr + 1;
				when "011" => 
					L_addr	<= ST_body(ST_ptr - 1)(9 downto 0);
					L_cz	<= ST_body(ST_ptr - 1)(11 downto 10);
					ST_ptr	<= ST_ptr - 1;
				when "100" => L_addr <= I_DATA;
					report "JJJJJJJJJJJJJJJJJJj";
				when "101" => L_addr <= 
					conv_std_logic_vector(
						SIGNED(L_addr) + SIGNED(I_DATA(8 downto 0)), L_addr'length);
				when others => NULL;
			end case;		
		end if;
	end process;
	
	O_addr 	<= L_addr;
	O_CZ	<= L_cz;

end Behavioral;

