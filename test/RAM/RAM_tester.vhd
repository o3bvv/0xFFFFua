library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity RAM_tester is
	port (
		I_CLK  : in  STD_LOGIC;
		I_RST  : in  STD_LOGIC;
		I_SW   : in  STD_LOGIC_VECTOR (3 downto 0);
		I_FRXD : in  STD_LOGIC;
		O_FTXD : out STD_LOGIC;
		O_LED  : out STD_LOGIC_VECTOR (7 downto 0));
end RAM_tester;

architecture arch of RAM_tester is
	
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
	
	signal FUART_WR		  : std_logic := '0';
	signal FUART_RD		  : std_logic := '0';
	
	signal FUART_RX_RDY   : std_logic;
	signal FUART_RX_RDY_A : std_logic := '1';
	
	signal FUART_TX_RDY   : std_logic;
	signal FUART_TX_RDY_A : std_logic := '1';
	
	signal FUART_O_DATA : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	signal FUART_I_DATA : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	
	component RAM_512x16
		port (
			I_CLK  : in  STD_LOGIC;
			I_RST  : in  STD_LOGIC;
			I_WR   : in  STD_LOGIC;
			I_ADDR : in  STD_LOGIC_VECTOR (8 downto 0);
			I_DATA : in  STD_LOGIC_VECTOR (15 downto 0);
			O_DATA : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
	
	signal RAM_WR	  : STD_LOGIC := '0';
	signal RAM_ADDR   : STD_LOGIC_VECTOR (8 downto 0)  := (others => '0');
	signal RAM_O_DATA : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal RAM_I_DATA : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	
	type STATES is (
		PAR, -- Prepare Address Receiving
		AR,  -- Address Receiving
		SA,  -- Set Address
		WDU, -- Wait Data Update
		PDS, -- Prepare Data Sending
		DS,  -- Data Sending
		PDR, -- Prepare Data Receiving
		DR,  -- Data Receiving
		WD); -- Write Data
	
begin
	
	ram_unit : RAM_512x16
		port map (
			I_CLK  => I_CLK,
			I_RST  => I_RST,
			I_WR   => RAM_WR,
			I_ADDR => RAM_ADDR,
			I_DATA => RAM_I_DATA,
			O_DATA => RAM_O_DATA);
			
	fuart: uart
		port map (
			I_CLK 		=> I_CLK,
			I_RST 		=> I_RST,
			I_WR 		=> FUART_WR,
			I_RD 		=> FUART_RD,
			I_RXE 		=> '1',
			I_TXE 		=> '1',
			I_BRS 		=> '0',
			I_TX_RDY_A	=> FUART_TX_RDY_A,
			I_RX_RDY_A	=> FUART_RX_RDY_A,
			I_DATA 		=> FUART_I_DATA,
			O_DATA 		=> FUART_O_DATA,
			I_RXD 		=> I_FRXD,
			O_TXD 		=> O_FTXD,
			O_RX_RDY 	=> FUART_RX_RDY,
			O_TX_RDY 	=> FUART_TX_RDY);
			
	process(I_CLK, I_RST)
		variable state	  : STATES := PAR;
	begin
		if (I_RST='1') then
			state := PAR;
		elsif (I_CLK='1' and I_CLK'event) then
			
			case state is
			
				when PAR =>
					O_LED <= X"01";
					FUART_RD <= '1';
					if (FUART_RX_RDY='0') then
						state := AR;
					end if;
				
				when AR =>
					O_LED <= X"02";
					FUART_RX_RDY_A <= '0';
					FUART_RD <= '0';
					
					if (FUART_RX_RDY='1') then						
						FUART_RX_RDY_A <= '1';
						state := SA;
					end if;
					
				when SA =>
					O_LED <= X"03";
					RAM_ADDR <= "0" & conv_std_logic_vector(
						UNSIGNED(FUART_O_DATA) - 48, FUART_O_DATA'length);
					
					if (I_SW(0)='0') then
						state := WDU;
					else
						state := PDR;
					end if;
				
				when WDU =>
					state := PDS;
					
				when PDS =>
					O_LED <= X"04";
					FUART_I_DATA <= RAM_O_DATA(7 downto 0);
					FUART_WR <= '1';
					
					if (FUART_TX_RDY='0') then
						state := DS;
					end if;
				
				when DS =>
					O_LED <= X"05";
					FUART_TX_RDY_A <= '0';
					FUART_WR <= '0';
					
					if (FUART_TX_RDY='1') then
						FUART_TX_RDY_A <= '1';
						state := PAR;
					end if;
					
				when PDR =>
					O_LED <= X"06";
					FUART_RD <= '1';
					if (FUART_RX_RDY='0') then
						state := DR;
					end if;
				
				when DR =>
					O_LED <= X"07";
					FUART_RX_RDY_A <= '0';
					FUART_RD <= '0';
					
					if (FUART_RX_RDY='1') then
						FUART_RX_RDY_A <= '1';
						
						RAM_I_DATA <= X"00" & FUART_O_DATA;
						RAM_WR <= '1';
						
						state := WD;
					end if;
				
				when WD =>
					O_LED <= X"08";
					RAM_WR <= '0';
				
					state := PAR;
					
				when others => null;
			end case;
		end if;
	end process;

end arch;

