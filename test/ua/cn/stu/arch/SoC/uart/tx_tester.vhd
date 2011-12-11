---------------------------------------------------------------------------------- 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tx_tester is
	port (
		I_CLK : in	STD_LOGIC;
		O_TXD : out	STD_LOGIC);
end tx_tester;

architecture Behavioral of tx_tester is

	component uart_tx is
		generic(
			dataWidth : natural := 8);
		port (
			I_CLK	: in	STD_LOGIC;
			I_RST	: in	STD_LOGIC;
			I_DATA	: in	STD_LOGIC_VECTOR (dataWidth-1 downto 0);
			I_WR	: in	STD_LOGIC;
			I_E		: in	STD_LOGIC;
			I_RDY_A	: in	STD_LOGIC;
			O_RDY	: out	STD_LOGIC;
			O_TXD	: out	STD_LOGIC);
	end component;
	
	signal L_clk 	: STD_LOGIC := '0';
	signal L_wr 	: STD_LOGIC := '0';
	
begin

	transmitter: uart_tx
		port map(
			I_CLK	=> L_clk,
			I_RST	=> '0',
			I_DATA	=> "00110000",
			I_WR	=> L_wr,
			I_E		=> '1',
			I_RDY_A	=> '1',
			O_TXD	=> O_TXD);

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
	
	L_wr <= '1';
end Behavioral;

