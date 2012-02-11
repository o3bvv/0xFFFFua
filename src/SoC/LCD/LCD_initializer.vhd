library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LCD_initializer is
	port (
		I_CLK	: in	STD_LOGIC;
		I_RST	: in	STD_LOGIC;
		O_RDY	: out	STD_LOGIC;
        O_SF_D	: out	STD_LOGIC_VECTOR (3 downto 0);
        O_LCD_E	: out	STD_LOGIC);
end LCD_initializer;

architecture arch of LCD_initializer is

	constant ticks_15ms		: integer := 750000 - 1;
	constant ticks_4_1ms	: integer := 205000 - 2;
	constant ticks_100us	: integer := 5000 - 2;
	constant ticks_40us 	: integer := 2000 - 2;
	constant ticks_240ns	: integer := 12 - 1;
	
	constant code_3		: STD_LOGIC_VECTOR (3 downto 0) := "0011";
	constant code_2		: STD_LOGIC_VECTOR (3 downto 0) := "0010";
	constant code_foo	: STD_LOGIC_VECTOR (3 downto 0) := "0000";

	signal ticksToWait	: integer range 0 to ticks_15ms := 0;
	signal state 		: integer range 0 to 13 := 0;
	
	signal L_LCD_E	: STD_LOGIC := '0';
	signal L_SF_D	: STD_LOGIC_VECTOR (3 downto 0) := X"0";
begin

	O_LCD_E		<= L_LCD_E;
	O_SF_D 		<= L_SF_D;

	process (I_CLK, I_RST)
	
	begin
		if (I_RST = '1')  then
			state <= 0;
		elsif (I_CLK = '1' and I_CLK'event) then
			case state is
				
				when 0 =>
					state <= 1;
					ticksToWait <= ticks_15ms;
					L_LCD_E <= '1';
					L_SF_D <= code_foo;
					O_RDY <= '0';
				
				when 2 | 5 | 8 =>
					L_SF_D <= code_3;
					L_LCD_E <= '1';
					ticksToWait <= ticks_240ns;
					
				when 11 =>
					L_SF_D <= code_2;
					L_LCD_E <= '1';
					ticksToWait <= ticks_240ns;
					
				when 3 =>
					if (ticksToWait = 0) then
						L_LCD_E <= '0';
						ticksToWait <= ticks_4_1ms;
					end if;
					
				when 6 =>
					if (ticksToWait = 0) then
						L_LCD_E <= '0';
						ticksToWait <= ticks_100us;
					end if;
					
				when 9 =>
					if (ticksToWait = 0) then
						L_LCD_E <= '0';
						ticksToWait <= ticks_40us;
					end if;
					
				when 12 =>
					if (ticksToWait = 0) then
						L_LCD_E <= '0';
						ticksToWait <= ticks_40us+1;
					end if;
				
				when 13 =>
					if (ticksToWait = 0) then
						O_RDY <= '1';
					end if;
					
				when others =>
			end case;
			
			if (ticksToWait > 0) then
				ticksToWait <= ticksToWait -1;
			elsif ((ticksToWait = 0) and (state < 13)) then
				state <= state + 1;
			end if;
		end if;
	end process;
end arch;

