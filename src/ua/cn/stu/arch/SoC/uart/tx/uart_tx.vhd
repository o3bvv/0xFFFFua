----------------------------------------------------------------------------------
-- UART transmition module
-- Baud is configured by clock
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
	generic(
		G_DATA_WIDTH : natural := 8);
	port (
		I_CLK	: in	STD_LOGIC;
		I_RST	: in	STD_LOGIC;
		I_DATA	: in	STD_LOGIC_VECTOR (G_DATA_WIDTH-1 downto 0);
		I_WR	: in	STD_LOGIC;
		I_E		: in	STD_LOGIC;
		I_RDY_A	: in	STD_LOGIC;
		O_RDY	: out	STD_LOGIC;
		O_TXD	: out	STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is
	type states is (IDLE, START, TX, STOP);
	
	signal L_state 	: states := IDLE;
	
	signal L_txd 	: STD_LOGIC := '1';
	
	constant L_VCC 	: STD_LOGIC := '1';
	constant L_GND 	: STD_LOGIC := '0';
	
begin
	
	O_TXD <= L_txd;
	
	process(I_CLK, I_RST, I_E)
		variable v_DATA			: STD_LOGIC_VECTOR (G_DATA_WIDTH-1 downto 0);
		variable v_txd_number	: natural range 0 to G_DATA_WIDTH;
	begin
		if(I_RST='1' or I_E='0') then
			L_state <= IDLE;
		elsif(I_CLK='1' and I_CLK'event) then
			case L_state is
				
				when IDLE =>
					L_txd 	<= L_VCC;
					if (I_WR='1' and I_RDY_A='1') then
						L_state <= START;
					end if;
				
				when START =>
					L_txd 	<= L_GND;
					v_DATA	:= I_DATA;
					v_txd_number := 0;
					L_state <= TX;
				
				when TX =>
					L_txd 	<= v_DATA(0);
					if (v_txd_number<G_DATA_WIDTH-1) then
						v_DATA := '0' & v_DATA(G_DATA_WIDTH-1 downto 1);
						v_txd_number := v_txd_number+1;
					else
						L_state <= STOP;
					end if;
					
				when STOP =>
					L_txd 	<= L_VCC;
					L_state <= IDLE;
			end case;
		end if;
	end process;

	O_RDY <= '1' when L_state=IDLE else '0';
end Behavioral;

