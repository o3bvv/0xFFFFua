---------------------------------------------------------------------------------- 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity uart_main is
	generic(
		G_DATA_WIDTH : natural := 8);
	port (
		I_CLK 		: in	STD_LOGIC;
		I_RST 		: in	STD_LOGIC;
		I_WR		: in	STD_LOGIC;
		I_RD		: in	STD_LOGIC;
		I_RXE		: in	STD_LOGIC;
		I_TXE		: in	STD_LOGIC;
		I_BRS		: in	STD_LOGIC;
		I_TX_RDY_A	: in	STD_LOGIC;
		I_RX_RDY_A	: in	STD_LOGIC;
		I_DATA		: in	STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
		I_RXD		: in	STD_LOGIC;
		O_DATA		: out	STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
		O_TXD		: out	STD_LOGIC;
		O_TX_RDY	: out	STD_LOGIC;
		O_RX_RDY	: out	STD_LOGIC);
end uart_main;

architecture arch of uart_main is
	
	component uart_tx is
		generic(
			G_DATA_WIDTH : natural := G_DATA_WIDTH);
		port (
			I_CLK	: in	STD_LOGIC;
			I_RST	: in	STD_LOGIC;
			I_DATA	: in	STD_LOGIC_VECTOR (G_DATA_WIDTH-1 downto 0);
			I_WR	: in	STD_LOGIC;
			I_E		: in	STD_LOGIC;
			I_RDY_A	: in	STD_LOGIC;
			O_RDY	: out	STD_LOGIC;
			O_TXD	: out	STD_LOGIC);
	end component;
	
	signal TX_RDY	: STD_LOGIC;
	signal TX_WR	: STD_LOGIC;
	
	component uart_rx is
		generic(
			G_DATA_WIDTH : natural := G_DATA_WIDTH);
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
	
	signal RX_RDY 	: STD_LOGIC;
	
	type t_baud_divs is
		array(0 to 4) of natural;	
	constant L_baud_divs: t_baud_divs := (
		20832-1,	--  1200 (0)
		10416-1,	--  2400 (1)
		5208-1,		--  4800 (2)
		2604-1,		--  9600 (3)
		1302-1);	-- 19200 (4)
	
	signal L_baud_div : natural := 2604-1;
	
	signal L_clk : STD_LOGIC := '0';
begin

	transmitter: uart_tx
		port map(
			I_CLK	=> L_clk,
			I_RST	=> I_RST,
			I_DATA	=> I_DATA,
			I_WR	=> TX_WR,
			I_E		=> I_TXE,
			I_RDY_A	=> I_TX_RDY_A,
			O_TXD	=> O_TXD,
			O_RDY	=> O_TX_RDY);

	TX_WR <= I_WR and (not I_BRS);

	reciever: uart_rx
		port map(
			I_CLK	=> L_clk,
			I_RST	=> I_RST,
			I_RD	=> I_RD,
			I_E		=> I_RXE,
			I_RDY_A	=> I_RX_RDY_A,
			I_RXD	=> I_RXD,
			O_DATA	=> O_DATA,
			O_RDY	=> O_RX_RDY);

	process(I_CLK, I_RST)
		variable v_div: natural := 0;
		variable v_new_baud_div: natural;
	begin
		if (I_RST='1') then
			v_div := 0;
		elsif (I_CLK='1' and I_CLK'event) then
			if (v_div=L_baud_div) then				
				
				if (I_WR='1' and I_BRS='1') then
					v_new_baud_div := conv_integer(UNSIGNED(I_DATA(2 downto 0)));
					if (v_new_baud_div>L_baud_divs'length) then
						v_new_baud_div := 0;
					end if;
					L_baud_div <= L_baud_divs(v_new_baud_div);
				end if;
				
				L_clk <= not L_clk;
				v_div := 0;
			else 
				v_div := v_div+1;
			end if;
		end if;		
	end process;
end arch;