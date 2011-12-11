----------------------------------------------------------------------------------
-- UART receiving module
-- Baud is configured by clock
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
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
end uart_rx;

architecture Behavioral of uart_rx is
	type states is (IDLE, START, RX, STOP);
	
	signal L_state 	: states := IDLE;
	
	signal L_rxd 	: STD_LOGIC := '1';
	
	constant L_VCC 	: STD_LOGIC := '1';
	constant L_GND 	: STD_LOGIC := '0';
	
begin
	
	process(I_CLK, I_RST, I_E)
		variable v_DATA			: STD_LOGIC_VECTOR (G_DATA_WIDTH-1 downto 0);
		variable v_rxd_number	: natural range 0 to G_DATA_WIDTH;
	begin
		if(I_RST='1' or I_E='0') then
			L_state <= IDLE;
		elsif(I_CLK='1' and I_CLK'event) then
			case L_state is
				
				when IDLE =>
					if (I_RD='1' and I_RDY_A='1') then
						L_state <= START;
					end if;
				
				when START =>
					v_rxd_number := 0;
					if (L_rxd='0') then
						L_state <= RX;
					end if;
				
				when RX =>
					if (v_rxd_number<G_DATA_WIDTH) then
						v_DATA := L_rxd & v_DATA(G_DATA_WIDTH-1 downto 1);
						v_rxd_number := v_rxd_number+1;
					else
						L_state <= STOP;
					end if;
					
				when STOP =>
					O_DATA  <= v_DATA;
					L_state <= IDLE;
			end case;
		end if;
	end process;

	L_rxd  <= I_RXD;
	O_RDY  <= '1' when L_state=IDLE else '0';
end Behavioral;
