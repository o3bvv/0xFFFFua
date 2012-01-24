LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY RAM_tb IS
END RAM_tb;
 
ARCHITECTURE behavior OF RAM_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RAM_1024x16
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         I_WR : IN  std_logic;
         I_ADDR : IN  std_logic_vector(9 downto 0);
         I_DATA : IN  std_logic_vector(15 downto 0);
         O_DATA : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_WR : std_logic := '0';
   signal I_ADDR : std_logic_vector(9 downto 0) := (others => '0');
   signal I_DATA : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal O_DATA : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN

	I_CLK <= NOT I_CLK after I_CLK_period;
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RAM_1024x16 PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_WR => I_WR,
          I_ADDR => I_ADDR,
          I_DATA => I_DATA,
          O_DATA => O_DATA
        );

   -- Stimulus process
   stim_proc: process
   begin		
      
	  I_DATA <= X"0001";
	  
	  wait for I_CLK_period*3;
	  
	  I_WR <= '1';	  
	  wait for I_CLK_period*2;
	  
	  I_WR <= '0';
	  I_ADDR <= "0000000001";
	  wait for I_CLK_period*2;	  
	  
	  I_ADDR <= "0000000000";
      wait;
   end process;

END;
