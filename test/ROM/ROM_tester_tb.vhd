LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY ROM_tester_tb IS
END ROM_tester_tb;
 
ARCHITECTURE behavior OF ROM_tester_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ROM_tester
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         I_SW : IN  std_logic_vector(3 downto 0);
         O_FTXD : out STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_SW : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal O_FTXD : STD_LOGIC;

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ROM_tester PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_SW => I_SW,
          O_FTXD => O_FTXD
        );

   I_CLK <= NOT I_CLK after I_CLK_period;
 

   -- Stimulus process
   stim_proc: process
   begin		
      
	  I_RST <= '1';
	  
      wait for I_CLK_period*3;

      I_RST <= '0';
	  
	  wait for I_CLK_period*4;
	  
	  I_SW  <= X"2";

	  wait for I_CLK_period*150000;

      I_SW  <= X"0";

      wait;
   end process;

END;
