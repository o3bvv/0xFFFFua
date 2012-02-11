----------------------------------------------------------------------------------
-- UART receiving module
-- Baud is configured by clock
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
	generic(
		G_DATA_WIDTH : natural := 8;
		G_RD_SAMPLES : natural := 14);
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

	signal l_DATA	: STD_LOGIC_VECTOR (G_DATA_WIDTH-1 downto 0) := (others=> '0');
begin
	
	process(I_CLK, I_RST, I_E, I_RD, I_RDY_A)
		variable v_DATA			: STD_LOGIC_VECTOR (G_DATA_WIDTH-1 downto 0);
		variable v_rxd_number	: natural range 0 to G_DATA_WIDTH := 0;
		variable v_sample_number: natural range 0 to G_RD_SAMPLES := 0;
	begin
		if(I_RST='1' or I_E='0') then
			L_state <= IDLE;
		elsif(I_CLK='1' and I_CLK'event) then
		
			if (v_sample_number<G_RD_SAMPLES) then
				v_sample_number := v_sample_number+1;
			else
				v_sample_number := 0;
			end if;
			
			case L_state is

				when START =>					
					v_rxd_number := 0;
					if (I_RXD='0') then
						if (v_sample_number=((G_RD_SAMPLES/2)-1)) then
							v_sample_number := 0;
							L_state <= RX;
						end if;
					else
						v_sample_number := 0;
					end if;
				
				when RX =>
					if (v_sample_number=(G_RD_SAMPLES-1)) then
						if (v_rxd_number<G_DATA_WIDTH) then
							v_DATA := I_RXD & v_DATA(G_DATA_WIDTH-1 downto 1);
							v_rxd_number := v_rxd_number+1;						
						else
							L_state <= STOP;
						end if;
					end if;
					
				when STOP =>
					l_DATA  <= v_DATA;
					L_state <= IDLE;
				
				when others =>
			end case;
		end if;
					
		if (L_state=IDLE and I_RD='1' and I_E='1' and I_RDY_A='1') then
			L_state <= START;
		end if;
	end process;

	O_RDY  <= '1' when L_state=IDLE else '0';
	O_DATA  <= l_DATA;
end Behavioral;
