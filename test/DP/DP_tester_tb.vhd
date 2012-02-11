LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY DP_tester_tb IS
END DP_tester_tb;
 
ARCHITECTURE behavior OF DP_tester_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DP_tester
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         I_SW : IN  std_logic_vector(3 downto 0);
         I_FRXD : IN  std_logic;
         O_FTXD : OUT  std_logic;
         O_LED : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_SW : std_logic_vector(3 downto 0) := "0001";
   signal I_FRXD : std_logic := '1';

 	--Outputs
   signal O_FTXD : std_logic;
   signal O_LED : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DP_tester PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_SW => I_SW,
          I_FRXD => I_FRXD,
          O_FTXD => O_FTXD,
          O_LED => O_LED
        );

   I_CLK <= NOT I_CLK after I_CLK_period;
 

   -- Stimulus process
   stim_proc: process
   begin		
      
	  I_RST <= '1';
	  
      wait for I_CLK_period*3;

      I_RST <= '0';
	  
	  wait for I_CLK_period*20;
	  
	  I_FRXD <= '0';
	  
	  wait for I_CLK_period*250000;

	  I_FRXD <= '1';
	  
	  wait for I_CLK_period*20;
	  
	  I_FRXD <= '0';

      wait;
   end process;

END;
