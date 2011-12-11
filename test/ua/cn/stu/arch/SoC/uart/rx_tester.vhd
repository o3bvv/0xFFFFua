
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rx_tester is
    Port ( I_CLK : in  STD_LOGIC;
           I_RXD : in  STD_LOGIC;
           O_LED : out  STD_LOGIC_VECTOR (7 downto 0));
end rx_tester;

architecture Behavioral of rx_tester is

	component uart_rx is
		generic(
			G_DATA_WIDTH : natural := 8);
		port (
			I_CLK	: in	STD_LOGIC;
			I_RST	: in	STD_LOGIC;		
			I_RD	: in	STD_LOGIC;
			I_E		: in	STD_LOGIC;
			I_RDY_A	: in	STD_LOGIC;
			I_RXD	: in	STD_LOGIC;
			O_DATA	: out	STD_LOGIC_VECTOR (G_DATA_WIDTH-1 downto 0);
			O_RDY	: out	STD_LOGIC);
	end component;
	
	signal L_clk 	: STD_LOGIC := '0';
	signal L_rd 	: STD_LOGIC := '0';
begin
	
	reciever: uart_rx
		port map(
			I_CLK	=> L_clk,
			I_RST	=> '0',
			O_DATA	=> O_LED,
			I_RD	=> L_rd,
			I_E		=> '1',
			I_RDY_A	=> '1',
			I_RXD	=> I_RXD);

	process(I_CLK)
		variable div: natural := 0;
	begin
		if (I_CLK='1' and I_CLK'event) then
			if (div=2604-1) then -- BAUD 9600
				L_clk <= not L_clk;
				div := 0;
			else 
				div := div+1;
			end if;
		end if;
	end process;
	
	L_rd <= '1';

end Behavioral;

