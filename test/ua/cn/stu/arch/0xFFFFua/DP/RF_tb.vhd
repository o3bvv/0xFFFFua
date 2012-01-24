LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY RF_tb IS
END RF_tb;
 
ARCHITECTURE behavior OF RF_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RF
    PORT(
         I_CLK : IN  std_logic;
         I_WR : IN  std_logic;
         I_AB_INC : IN  std_logic;
         I_AC_INC : IN  std_logic;
         I_AB : IN  std_logic_vector(4 downto 0);
         I_AC : IN  std_logic_vector(4 downto 0);
         I_AD : IN  std_logic_vector(4 downto 0);
         I_B : IN  std_logic_vector(15 downto 0);
         O_C : OUT  std_logic_vector(15 downto 0);
         O_D : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_WR : std_logic := '0';
   signal I_AB_INC : std_logic := '0';
   signal I_AC_INC : std_logic := '0';
   signal I_AB : std_logic_vector(4 downto 0) := (others => '0');
   signal I_AC : std_logic_vector(4 downto 0) := (others => '0');
   signal I_AD : std_logic_vector(4 downto 0) := (others => '0');
   signal I_B : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal O_C : std_logic_vector(15 downto 0);
   signal O_D : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN

	I_CLK <= NOT I_CLK after I_CLK_period;
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RF PORT MAP (
          I_CLK => I_CLK,
          I_WR => I_WR,
          I_AB_INC => I_AB_INC,
          I_AC_INC => I_AC_INC,
          I_AB => I_AB,
          I_AC => I_AC,
          I_AD => I_AD,
          I_B => I_B,
          O_C => O_C,
          O_D => O_D
        );
 

	-- Stimulus process
	stim_proc: process
	begin		      

		wait for I_CLK_period*3;

		I_WR 	<= '1';
		I_B	<= X"00FA";
	
		wait for I_CLK_period*2;
		
		I_AB <= "00001";
		I_B	 <= X"00AF";

		wait for I_CLK_period*2;
		
		I_AB <= "00010";
		I_B	 <= X"00AA";

		wait for I_CLK_period*2;
		
		I_WR 	<= '0';

		wait for I_CLK_period*2;
		
		I_AD <= "00001";
		
		wait for I_CLK_period*2;

		I_AC <= "00010";

		wait;
	end process;

END;
