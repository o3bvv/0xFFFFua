LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY MPU_tb IS
END MPU_tb;
 
ARCHITECTURE behavior OF MPU_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MPU
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         I_START : IN  std_logic;
         I_HHR : IN  std_logic;
         I_A : IN  std_logic_vector(15 downto 0);
         I_B : IN  std_logic_vector(15 downto 0);
         O_RDY : OUT  std_logic;
         O_Z : OUT  std_logic;
         O_HR : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_START : std_logic := '0';
   signal I_HHR : std_logic := '0';
   signal I_A : std_logic_vector(15 downto 0) := (others => '0');
   signal I_B : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal O_RDY : std_logic;
   signal O_Z : std_logic;
   signal O_HR : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	I_CLK <= NOT I_CLK after I_CLK_period;
	
	-- Instantiate the Unit Under Test (UUT)
   uut: MPU PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_START => I_START,
          I_HHR => I_HHR,
          I_A => I_A,
          I_B => I_B,
          O_RDY => O_RDY,
          O_Z => O_Z,
          O_HR => O_HR
        );

	-- Stimulus process
	stim_proc: process
	begin		
      
		wait for I_CLK_period*3;

		I_A <= X"0003";
		I_B <= X"0002";
	  
		I_START <= '1';
	  
		wait for I_CLK_period*2;

		I_START <= '0';

		wait for I_CLK_period*36;
		
		I_HHR <= '1';

		wait for I_CLK_period*2;
		
		I_HHR <= '0';
		
		I_A <= X"1FFF";
		I_B <= X"000A";
	  
		I_START <= '1';
	  
		wait for I_CLK_period*2;

		I_START <= '0';
		
		wait for I_CLK_period*36;
		
		I_HHR <= '1';
		
		I_HHR <= '0';
		
		I_A <= X"1FFF";
		I_B <= X"FFFB";
	  
		I_START <= '1';
	  
		wait for I_CLK_period*2;

		I_START <= '0';
		
		wait for I_CLK_period*36;
		
		I_HHR <= '1';

		wait;
	end process;

END;
