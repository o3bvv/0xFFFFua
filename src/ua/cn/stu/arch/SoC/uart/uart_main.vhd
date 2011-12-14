---------------------------------------------------------------------------------- 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity uart_main is
	generic(
		G_DATA_WIDTH : natural := 8;
		G_RD_SAMPLES : natural := 14);
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
	
	signal TX_CLK	: STD_LOGIC := '0';
	signal TX_RDY	: STD_LOGIC := '1';
	signal TX_WR	: STD_LOGIC;
	
	component uart_rx is
		generic(
			G_DATA_WIDTH : natural := G_DATA_WIDTH;
			G_RD_SAMPLES : natural := G_RD_SAMPLES);
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
	
	signal RX_CLK 	: STD_LOGIC := '0';
	signal RX_RDY	: STD_LOGIC := '1';
	
	type t_baud_divs is
		array(0 to 4) of natural;	
	constant C_baud_divs: t_baud_divs := (
		(20832/G_RD_SAMPLES)-1,	--  1200 (0)
		(10416/G_RD_SAMPLES)-1,	--  2400 (1)
		(5208/G_RD_SAMPLES)-1,	--  4800 (2)
		(2604/G_RD_SAMPLES)-1,	--  9600 (3)
		(1302/G_RD_SAMPLES)-1);	-- 19200 (4)
	
	signal L_baud_div : natural := C_baud_divs(3);
	
	signal L_clk : STD_LOGIC := '0';
begin

	transmitter: uart_tx
		port map(
			I_CLK	=> TX_CLK,
			I_RST	=> I_RST,
			I_DATA	=> I_DATA,
			I_WR	=> TX_WR,
			I_E		=> I_TXE,
			I_RDY_A	=> I_TX_RDY_A,
			O_TXD	=> O_TXD,
			O_RDY	=> TX_RDY);
	
	O_TX_RDY <= TX_RDY;
	TX_WR	 <= I_WR and (not I_BRS);

	reciever: uart_rx
		port map(
			I_CLK	=> RX_CLK,
			I_RST	=> I_RST,
			I_RD	=> I_RD,
			I_E		=> I_RXE,
			I_RDY_A	=> I_RX_RDY_A,
			I_RXD	=> I_RXD,
			O_DATA	=> O_DATA,
			O_RDY	=> RX_RDY);
	
	O_RX_RDY <= RX_RDY;

	TX_CLK_GEN:process(I_CLK, I_RST)
		variable v_div_tx		: natural := 0;
		variable v_div_samples	: natural range 0 to G_RD_SAMPLES := 0;
		variable v_new_baud_div	: natural;
	begin
		if (I_RST='1') then
			v_div_tx := 0;
			v_div_samples := 0;
		elsif (I_CLK='1' and I_CLK'event) then						
			if (TX_WR='0' and I_TXE='0' and TX_RDY='1') then
				TX_CLK	<= '0';
				v_div_tx:= L_baud_div;
				v_div_samples := G_RD_SAMPLES;				
			elsif (TX_WR='1' and I_TXE='1' and TX_RDY='1') then
				
				if (I_BRS='1') then
					v_new_baud_div := conv_integer(UNSIGNED(I_DATA(2 downto 0)));
					if (v_new_baud_div>C_baud_divs'length) then
						v_new_baud_div := 0;
					end if;
					L_baud_div <= C_baud_divs(v_new_baud_div);
				else
					TX_CLK <= '1';
				end if;				
			elsif (TX_RDY='0') then
				if (v_div_tx=L_baud_div) then					
					if (v_div_samples<(G_RD_SAMPLES-1)) then
						v_div_samples := v_div_samples+1;
					else
						TX_CLK <= not TX_CLK;
						v_div_samples := 0;
					end if;
					v_div_tx := 0;
				else 
					v_div_tx := v_div_tx+1;
				end if;
			end if;
		end if;
	end process;

	RX_CLK_GEN:process(I_CLK, I_RST)		
		variable v_div_rx		: natural := 0;
	begin
		if (I_RST='1') then
			v_div_rx := 0;
		elsif (I_CLK='1' and I_CLK'event) then						
			if (I_RD='0' and I_RXE='0' and RX_RDY='1') then
				RX_CLK	<= '0';
				v_div_rx:= L_baud_div;				
			elsif (I_RD='1' and I_RXE='1' and RX_RDY='1') then
				RX_CLK <= '1';				
			elsif (RX_RDY='0') then
				if (v_div_rx=L_baud_div) then
					RX_CLK <= not RX_CLK;
					v_div_rx := 0;
				else 
					v_div_rx := v_div_rx+1;
				end if;
			end if;			
		end if;		
	end process;
end arch;