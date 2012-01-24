LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY IP_tb IS
END IP_tb;
 
ARCHITECTURE behavior OF IP_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IP
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         F : IN  std_logic_vector(2 downto 0);
         I_DATA : IN  std_logic_vector(9 downto 0);
         I_CZ : IN  std_logic_vector(1 downto 0);
         O_CZ : OUT  std_logic_vector(1 downto 0);
         O_ADDR : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal F : std_logic_vector(2 downto 0) := (others => '0');
   signal I_DATA : std_logic_vector(9 downto 0) := (others => '0');
   signal I_CZ : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal O_CZ : std_logic_vector(1 downto 0);
   signal O_ADDR : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	I_CLK <= NOT I_CLK after I_CLK_period;
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IP PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          F => F,
          I_DATA => I_DATA,
          I_CZ => I_CZ,
          O_CZ => O_CZ,
          O_ADDR => O_ADDR
        );

	-- Stimulus process
	stim_proc: process
	begin		
   
		wait for I_CLK_period*3;

		F <= "110";
	
		wait for I_CLK_period*4;
		
		F <= "010";
		I_DATA <= "0000001010";
		
		wait for I_CLK_period*2;
		
		F <= "100";
		I_DATA <= "0000010000";
		
		wait for I_CLK_period*2;
		
		F <= "101";
		I_DATA <= "1111111011";
		
		wait for I_CLK_period*2;
		
		F <= "011";
		
		wait for I_CLK_period*2;
		
		F <= "000";
		
		wait;
	end process;

END;
