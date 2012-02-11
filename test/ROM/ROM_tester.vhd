library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ROM_tester is
	port (
		I_CLK  : in  STD_LOGIC;
		I_RST  : in  STD_LOGIC;
		I_SW   : in  STD_LOGIC_VECTOR (3 downto 0);
		O_FTXD : out STD_LOGIC);
end ROM_tester;

architecture arch of ROM_tester is

	component uart is
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
	end component;
	
	signal FUART_TX_RDY   : std_logic;
	signal FUART_TX_RDY_A : std_logic := '0';

	component ROM_512x16_DUO is
		port (		
			I_CLK	: in	STD_LOGIC;
			
			I_ADDR	: in	STD_LOGIC_VECTOR (8 downto 0);
					
			O_DATA0	: out	STD_LOGIC_VECTOR (15 downto 0);
			O_DATA1	: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal L_ADDR  : STD_LOGIC_VECTOR (8 downto 0)  := (others => '0');
	signal L_DATA0 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal L_DATA1 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	
	signal L_SW : STD_LOGIC_VECTOR (3 downto 0) := X"0";
begin

	rom_unit: ROM_512x16_DUO
		port map (
			I_CLK   => I_CLK,
			I_ADDR  => L_ADDR,
			O_DATA0 => L_DATA0,
			O_DATA1 => L_DATA1);
			
	fuart: uart
		port map (
			I_CLK 		=> I_CLK,
			I_RST 		=> I_RST,
			I_WR 		=> '1',
			I_RD 		=> '0',
			I_RXE 		=> '1',
			I_TXE 		=> '1',
			I_BRS 		=> '0',
			I_TX_RDY_A	=> FUART_TX_RDY_A,
			I_RX_RDY_A	=> '0',
			I_DATA 		=> L_DATA0(7 downto 0),
			I_RXD 		=> '1',
			O_TXD 		=> O_FTXD,
			O_TX_RDY 	=> FUART_TX_RDY);

	process(I_SW, FUART_TX_RDY)		
	begin
		FUART_TX_RDY_A <= '0';
		if (FUART_TX_RDY='1') then
			if (L_SW/=I_SW) then
				L_SW <= I_SW;
				L_ADDR <= "00000" & I_SW;
				FUART_TX_RDY_A <= '1';
			end if;
		end if;
	end process;

end arch;

