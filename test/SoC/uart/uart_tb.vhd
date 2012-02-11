LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY uart_tb IS
END uart_tb;
 
ARCHITECTURE behavior OF uart_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         I_WR : IN  std_logic;
         I_RD : IN  std_logic;
         I_RXE : IN  std_logic;
         I_TXE : IN  std_logic;
         I_BRS : IN  std_logic;
         I_TX_RDY_A : IN  std_logic;
         I_RX_RDY_A : IN  std_logic;
         I_DATA : IN  std_logic_vector(7 downto 0);
         I_RXD : IN  std_logic;
         O_DATA : OUT  std_logic_vector(7 downto 0);
         O_TXD : OUT  std_logic;
         O_TX_RDY : OUT  std_logic;
         O_RX_RDY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_WR : std_logic := '1';
   signal I_RD : std_logic := '0';
   signal I_RXE : std_logic := '1';
   signal I_TXE : std_logic := '1';
   signal I_BRS : std_logic := '0';
   signal I_TX_RDY_A : std_logic := '0';
   signal I_RX_RDY_A : std_logic := '0';
   signal I_DATA : std_logic_vector(7 downto 0) := X"31";
   signal I_RXD : std_logic := '1';

 	--Outputs
   signal O_DATA : std_logic_vector(7 downto 0);
   signal O_TXD : std_logic;
   signal O_TX_RDY : std_logic;
   signal O_RX_RDY : std_logic;

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_WR => I_WR,
          I_RD => I_RD,
          I_RXE => I_RXE,
          I_TXE => I_TXE,
          I_BRS => I_BRS,
          I_TX_RDY_A => I_TX_RDY_A,
          I_RX_RDY_A => I_RX_RDY_A,
          I_DATA => I_DATA,
          I_RXD => I_RXD,
          O_DATA => O_DATA,
          O_TXD => O_TXD,
          O_TX_RDY => O_TX_RDY,
          O_RX_RDY => O_RX_RDY
        );

   I_CLK <= NOT I_CLK after I_CLK_period;
 

   stim_proc: process
   begin		
      
	  I_RST <= '1';
	  
      wait for I_CLK_period*3;

      I_RST <= '0'; 
	  I_TX_RDY_A <= '1';
	  
	  wait for I_CLK_period*2;

	  I_TX_RDY_A <= '0';

      wait;
   end process;

END;
