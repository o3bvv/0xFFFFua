library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LCD_tester is
	port (
		I_CLK		: in	STD_LOGIC;
		I_RST		: in	STD_LOGIC;
		O_LED		: out	STD_LOGIC_VECTOR (7 downto 0);
		O_LCD_RW	: out	STD_LOGIC;
		O_LCD_RS	: out	STD_LOGIC;
		O_LCD_E		: out	STD_LOGIC;
		O_SF_CE0	: out	STD_LOGIC;
		IO_SF_D_11_8: inout	STD_LOGIC_VECTOR (11 downto 8));
end LCD_tester;

architecture arch of LCD_tester is
	component LCD is
		port (
			I_CLK		: in	STD_LOGIC;
			I_RST		: in	STD_LOGIC;
			I_WR		: in	STD_LOGIC;
			I_E			: in	STD_LOGIC;
			I_FLG_DATA	: in	STD_LOGIC;
			I_BYTE		: in	STD_LOGIC_VECTOR (7 downto 0);
			I_RDY_A		: in	STD_LOGIC;
			O_RDY		: out	STD_LOGIC;
			O_LCD_RW	: out	STD_LOGIC;
			O_LCD_RS	: out	STD_LOGIC;
			O_LCD_E		: out	STD_LOGIC;
			O_SF_CE0	: out	STD_LOGIC;
			O_SF_D		: out	STD_LOGIC_VECTOR (3 downto 0));
	end component;

	signal LCD_O_RDY	: STD_LOGIC := '0';
	signal LCD_O_RS		: STD_LOGIC := '0';
	signal LCD_SF_D 	: STD_LOGIC_VECTOR (11 downto 8) := "ZZZZ";
	
	constant C_VCC : STD_LOGIC	:= '1';
	constant C_GND : STD_LOGIC	:= '0';
	
	signal L_DATA : STD_LOGIC_VECTOR (7 downto 0);
	signal L_FLG_DATA : STD_LOGIC := '0';
	signal L_RDY_A : STD_LOGIC := '0';
	
	signal LCD_WR   : STD_LOGIC := '0';
	signal LCD_RDY  : STD_LOGIC := '0';
	
	type STATES is (
		A0, A1, A2, A3, A4, A5, A6, A7, A8, A9);
begin
	
	PRL_LCD: LCD
		port map(
			I_CLK 		=> I_CLK,
			I_RST 		=> I_RST,
			I_E 		=> C_VCC,
			I_WR 		=> LCD_WR,
			I_FLG_DATA	=> L_FLG_DATA,
			I_BYTE		=> L_DATA,
			I_RDY_A		=> L_RDY_A,
			O_RDY		=> LCD_RDY,
			O_LCD_RW	=> O_LCD_RW,
			O_LCD_RS	=> LCD_O_RS,
			O_LCD_E		=> O_LCD_E,
			O_SF_CE0	=> O_SF_CE0,
			O_SF_D		=> LCD_SF_D);

	O_LCD_RS     <= LCD_O_RS;
	IO_SF_D_11_8 <= LCD_SF_D when (LCD_RDY='0') else "ZZZZ";

	process(I_RST, I_CLK)
		variable state : STATES := A0;
	begin
		if (I_RST='1') then
			state := A0;
		elsif (I_CLK='1' and I_CLK'event) then
		
			case state is
			
				when A0 =>
					O_LED <= X"01";
					if (LCD_RDY='1') then					
						LCD_WR <= '1';
						L_DATA <= "00101000";
						state := A1;
					end if;
					
				when A1 =>
					O_LED <= X"02";
					LCD_WR <= '0';
					if (LCD_RDY='1') then
						LCD_WR <= '1';
						L_DATA <= "00000110";
						state := A2;
					end if;

				when A2 =>
					O_LED <= X"03";
					LCD_WR <= '0';
					if (LCD_RDY='1') then
						LCD_WR <= '1';
						L_DATA <= "00001100";
						state := A3;
					end if;
					
				when A3 =>
					O_LED <= X"04";
					LCD_WR <= '0';
					if (LCD_RDY='1') then
						LCD_WR <= '1';
						L_DATA <= "00000001";
						state := A4;
					end if;
								
				when A4 =>
					O_LED <= X"05";
					LCD_WR <= '0';
					if (LCD_RDY='1') then
						LCD_WR <= '1';
						L_DATA <= "10000000";
						state := A5;
					end if;
				
				when A5 =>
					O_LED <= X"06";
					LCD_WR <= '0';
					if (LCD_RDY='1') then
						LCD_WR <= '1';
						L_FLG_DATA <= '1';
						L_DATA <= "00111111";
						state  := A6;
					end if;
				
				when others => 
					O_LED <= X"09";
					LCD_WR <= '0';
					L_FLG_DATA <= '0';
			end case;
			
			L_RDY_A <= LCD_RDY;
		end if;
	end process;

end arch;

