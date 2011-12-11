library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_tester is
    Port ( I_CLK : in  STD_LOGIC;
           I_RXD : in  STD_LOGIC;
           O_TXD : out  STD_LOGIC);
end main_tester;

architecture arch of main_tester is
	
	component uart_main is
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
	end component;
	
   signal L_WR 		 : std_logic := '0';
   signal L_RD 		 : std_logic := '1';
   
   signal L_RXE 	 : std_logic := '1';
   signal L_TXE 	 : std_logic := '1';
   
   signal L_BRS 	 : std_logic := '0';
   
   signal L_TX_RDY_A : std_logic := '0';
   signal L_RX_RDY_A : std_logic := '0';
   
   signal LI_DATA : std_logic_vector(7 downto 0);
   signal LO_DATA : std_logic_vector(7 downto 0);
   
   signal L_TX_RDY : std_logic;
   signal L_RX_RDY : std_logic; 
begin

	uut: uart_main PORT MAP (
		I_CLK 		=> I_CLK,
		I_RST 		=> '0',
		I_WR 		=> L_WR,
		I_RD 		=> L_RD,
		I_RXE 		=> L_RXE,
		I_TXE 		=> L_TXE,
		I_BRS 		=> L_BRS,
		I_TX_RDY_A	=> L_TX_RDY_A,
		I_RX_RDY_A	=> L_RX_RDY_A,
		I_DATA 		=> LI_DATA,
		I_RXD 		=> I_RXD,
		O_DATA 		=> LO_DATA,
		O_TXD 		=> O_TXD,
		O_TX_RDY 	=> L_TX_RDY,
		O_RX_RDY 	=> L_RX_RDY);	

	process(L_TX_RDY,L_RX_RDY)
	begin
		if (L_RD='0') then
			if (L_TX_RDY='1') then
				L_WR <= '0';
				L_RD <= '1';
				L_TX_RDY_A <= '1';
				L_RX_RDY_A <= '1';
			else
				L_TX_RDY_A <= '0';
			end if;
		else
			if (L_RX_RDY='1') then
				LI_DATA <= LO_DATA;
				L_WR <= '1';
				L_RD <= '0';
				L_TX_RDY_A <= '1';
				L_RX_RDY_A <= '1';
			else
				L_RX_RDY_A <= '0';
			end if;
		end if;
	end process;
end arch;

