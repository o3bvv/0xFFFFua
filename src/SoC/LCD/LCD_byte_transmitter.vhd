library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity LCD_byte_transmitter is
	port (
		I_CLK		: in	STD_LOGIC;
		I_RST		: in	STD_LOGIC;
		I_START		: in	STD_LOGIC;
		I_FLG_DATA	: in	STD_LOGIC;
		I_BYTE		: in	STD_LOGIC_VECTOR (7 downto 0);
		O_RDY		: out	STD_LOGIC;
		O_LCD_RS	: out	STD_LOGIC;
		O_LCD_RW	: out	STD_LOGIC;
		O_LCD_E		: out	STD_LOGIC;
		O_SF_D		: out	STD_LOGIC_VECTOR (3 downto 0));
end LCD_byte_transmitter;

architecture arch of LCD_byte_transmitter is
		
	constant ticks_40ns		: integer := 2 - 1;
	constant ticks_240ns	: integer := 12 - 1;
	constant ticks_0_94us	: integer := 47 - 1;
	constant ticks_20ns		: integer := 1 - 1;
	constant ticks_40us		: integer := 2000 - 1;
	constant ticks_164us	: integer := 82000 - 1;
		
	signal state : integer range 0 to 9 := 0;
	signal ticksToWait : integer := 0;
	
	signal L_byte 	: STD_LOGIC_VECTOR (7 downto 0);
	signal L_LCD_RS	: STD_LOGIC := '0';
	
	signal L_LCD_RW : STD_LOGIC := '0';
	signal L_LCD_E	: STD_LOGIC := '0';
	signal L_SF_D	: STD_LOGIC_VECTOR (3 downto 0) := X"0";
begin

	process (I_CLK, I_RST, I_START)
	begin
		
		if (I_RST = '1')  then
			state <= 0;
			ticksToWait <= 0;
		elsif(I_CLK = '1' and I_CLK'event) then
			
			case state is
				when 0 =>
					L_LCD_E	 <= '0';
					L_LCD_RW <= '0';
					
				when 1 =>
					L_LCD_RS	<= I_FLG_DATA;
					L_SF_D		<= L_byte(7 downto 4);
					ticksToWait <= ticks_40ns;
					state <= 2;
					
				when 2 | 6 =>
					if (ticksToWait = 0) then
						L_LCD_E		<= '1';
						ticksToWait <=  ticks_240ns;
					end if;
					
				when 3 | 7 =>
					if (ticksToWait = 0) then
						L_LCD_E		<= '0';
						ticksToWait <=  ticks_20ns;
					end if;
				
				when 4 =>
					if (ticksToWait = 0) then
						ticksToWait <= ticks_0_94us;
					end if;
				
				when 5 =>
					if (ticksToWait = 0) then
						L_LCD_RW	<= '0';
						L_SF_D		<= L_byte(3 downto 0);
						ticksToWait <= ticks_40ns;
					end if;
					
				when 8 =>
					if (ticksToWait = 0) then
						if (L_byte=X"01" and I_FLG_DATA='0') then
							ticksToWait <= ticks_164us; --+ticks_40us;
						else
							ticksToWait <= ticks_40us;
						end if;
					end if;	

				when 9 =>
					if (ticksToWait = 0) then
						state <= 0;
					end if;	

			end case;
			
			if (ticksToWait > 0) then
				ticksToWait <= ticksToWait -1;
			elsif ((ticksToWait = 0) and (state > 1) and (state < 9)) then
				state <= state + 1;
			end if;
		end if;
		
		if (state=0 and I_START = '1') then
			L_byte	<= I_BYTE;
			state	<= 1;
		end if;
	end process;
	
	O_RDY <= '1' when state=0 else '0';
	
	O_LCD_RS	<= L_LCD_RS;
	O_LCD_RW	<= L_LCD_RW;
	O_LCD_E		<= L_LCD_E;
	O_SF_D 		<= L_SF_D;
end arch;

