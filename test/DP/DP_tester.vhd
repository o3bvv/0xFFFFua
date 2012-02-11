library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity DP_tester is
	port (
		I_CLK  : in  STD_LOGIC;
		I_RST  : in  STD_LOGIC;
		I_SW   : in  STD_LOGIC_VECTOR (3 downto 0);
		I_FRXD : in  STD_LOGIC;
		O_FTXD : out STD_LOGIC;
		O_LED  : out STD_LOGIC_VECTOR (7 downto 0));
end DP_tester;

architecture arch of DP_tester is
	
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

	COMPONENT DP
		PORT(
			 I_CLK : IN  std_logic;
			 I_RST : IN  std_logic;
			 I_RDD : IN  std_logic;
			 I_WRD : IN  std_logic;
			 I_START : IN  std_logic;
			 I_OPC : IN  std_logic_vector(4 downto 0);
			 I_AB : IN  std_logic_vector(4 downto 0);
			 I_AC : IN  std_logic_vector(4 downto 0);
			 I_AD : IN  std_logic_vector(4 downto 0);
			 I_DATA : IN  std_logic_vector(15 downto 0);
			 I_CZ : IN  std_logic_vector(1 downto 0);
			 I_RET : IN  std_logic;
			 O_RDY : OUT  std_logic;
			 O_DIVZ : OUT  std_logic;
			 O_CZ : OUT  std_logic_vector(1 downto 0);
			 O_C : OUT  std_logic_vector(15 downto 0);
			 O_D : OUT  std_logic_vector(15 downto 0)
			);
    END COMPONENT;
	
   signal DP_RDD : std_logic := '0';
   signal DP_WRD : std_logic := '0';
   signal DP_START : std_logic := '0';
   signal DP_OPC : std_logic_vector(4 downto 0) := (others => '0');
   signal DP_AB : std_logic_vector(4 downto 0) := (others => '0');
   signal DP_AC : std_logic_vector(4 downto 0) := (others => '0');
   signal DP_AD : std_logic_vector(4 downto 0) := (others => '0');
   signal DPI_DATA : std_logic_vector(15 downto 0) := (others => '0');
   signal DPI_CZ : std_logic_vector(1 downto 0) := (others => '0');
   signal DP_RET : std_logic := '0';

   signal DP_RDY : std_logic;
   signal DP_DIVZ : std_logic;
   signal DPO_CZ : std_logic_vector(1 downto 0);
   signal DP_C : std_logic_vector(15 downto 0);
   signal DP_D : std_logic_vector(15 downto 0);
   
   type STATES is (
		PO1R, -- Prepare Operand 1 Receiving
		O1R,  -- Operand 1 Receiving
		O1W,  -- Write Operand 1 to Register 0
		
		PO2R, -- Prepare Operand 2 Receiving
		O2R,  -- Operand 2 Receiving
		O2W,  -- Write Operand 2 to Register 0
		
		POPER,-- Prepare Operation
		SOPER,-- Start Operation
		OPER, -- Operating
		
		POUT, -- Prepare Outputting
		
		PCDS, -- Prepare Channel D Sending
		CDS,  -- Channel D Sending
		
		PCCS, -- Prepare Channel C Sending
		CCS); -- Channel C Sending
begin

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
			
	DP_inst: DP PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_RDD => DP_RDD,
          I_WRD => DP_WRD,
          I_START => DP_START,
          I_OPC => DP_OPC,
          I_AB => DP_AB,
          I_AC => DP_AC,
          I_AD => DP_AD,
          I_DATA => DPI_DATA,
          I_CZ => DPI_CZ,
          I_RET => DP_RET,
          O_RDY => DP_RDY,
          O_DIVZ => DP_DIVZ,
          O_CZ => DPO_CZ,
          O_C => DP_C,
          O_D => DP_D);

	process(I_CLK, I_RST)
		variable state	  : STATES := PO1R;
	begin
		if (I_RST='1') then
			state := PO1R;
		elsif (I_CLK='1' and I_CLK'event) then
			
			case state is
			
				when PO1R =>
				
					O_LED <= X"01";
					
					DP_RDD <= '0';
					FUART_RD <= '1';
					if (FUART_RX_RDY='0') then
						state := O1R;
					end if;
				
				when O1R =>
					O_LED <= X"02";
					FUART_RX_RDY_A <= '0';
					FUART_RD <= '0';
					
					if (FUART_RX_RDY='1') then						
						FUART_RX_RDY_A <= '1';
						
						DP_AB <= "00000";
						
						DPI_DATA <= X"00" & conv_std_logic_vector(
							UNSIGNED(FUART_O_DATA) - 48, FUART_O_DATA'length);
						
						state := O1W;
					end if;
					
				when O1W =>
					O_LED <= X"03";
					
					DP_WRD <= '1';
					state := PO2R;
					
				when PO2R =>
				
					O_LED <= X"04";
					
					DP_WRD <= '0';
					FUART_RD <= '1';
					
					if (FUART_RX_RDY='0') then
						state := O2R;
					end if;
				
				when O2R =>
					O_LED <= X"05";
					FUART_RX_RDY_A <= '0';
					FUART_RD <= '0';
					
					if (FUART_RX_RDY='1') then						
						FUART_RX_RDY_A <= '1';
						
						DP_AB <= "00001";
						
						DPI_DATA <= X"00" & conv_std_logic_vector(
							UNSIGNED(FUART_O_DATA) - 48, FUART_O_DATA'length);
						
						state := O2W;
					end if;
					
				when O2W =>
					O_LED <= X"06";
					
					DP_WRD <= '1';
					state := POPER;
				
				when POPER =>
					O_LED <= X"07";
					
					DP_WRD <= '0';
					
					DP_AD <= "00000";
					DP_AC <= "00001";
					DP_AB <= "00011";
					
					if (I_SW=X"1") then
						DP_OPC <= "00000";
					elsif (I_SW=X"2") then
						DP_OPC <= "01000";
					elsif (I_SW=X"4") then
						DP_OPC <= "01010";
					elsif (I_SW=X"8") then
						DP_OPC <= "01011";
					end if;
					
					DP_START <= '1';
					
					state := OPER;
					
				--when SOPER =>
				--	O_LED <= X"08";
				--	state := OPER;

				when OPER =>
					O_LED <= X"09";
					
					DP_START <= '0';
					
					if (DP_RDY='1') then
						state := POUT;
						DP_AD <= "00011";
						DP_AC <= "00100";
					
						DP_RDD <= '1';
					end if;
				
				when POUT =>
					O_LED <= X"0A";					
					state := PCDS;
				
				when PCDS =>
					O_LED <= X"0B";
					
					FUART_I_DATA <= conv_std_logic_vector(
							UNSIGNED(DP_D(7 downto 0)) + 48, FUART_I_DATA'length);
					FUART_WR <= '1';
					
					if (FUART_TX_RDY='0') then
						state := CDS;
					end if;
				
				when CDS =>
					O_LED <= X"0C";
				
					FUART_TX_RDY_A <= '0';
					FUART_WR <= '0';
					
					if (FUART_TX_RDY='1') then
						FUART_TX_RDY_A <= '1';
						state := PCCS;
					end if;
				
				when PCCS =>
					O_LED <= X"0D";
					
					FUART_I_DATA <= conv_std_logic_vector(
							UNSIGNED(DP_C(7 downto 0)) + 48, FUART_I_DATA'length);
					FUART_WR <= '1';
					
					if (FUART_TX_RDY='0') then
						state := CCS;
					end if;
				
				when CCS =>
					O_LED <= X"0E";
				
					FUART_TX_RDY_A <= '0';
					FUART_WR <= '0';
					
					if (FUART_TX_RDY='1') then
						FUART_TX_RDY_A <= '1';
						state := PO1R;
					end if;
				
				when others => null;
			end case;
		end if;
	end process;

end arch;

