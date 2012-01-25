LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY DP_tb IS
END DP_tb;
 
ARCHITECTURE behavior OF DP_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_RDD : std_logic := '0';
   signal I_WRD : std_logic := '0';
   signal I_START : std_logic := '0';
   signal I_OPC : std_logic_vector(4 downto 0) := (others => '0');
   signal I_AB : std_logic_vector(4 downto 0) := (others => '0');
   signal I_AC : std_logic_vector(4 downto 0) := (others => '0');
   signal I_AD : std_logic_vector(4 downto 0) := (others => '0');
   signal I_DATA : std_logic_vector(15 downto 0) := (others => '0');
   signal I_CZ : std_logic_vector(1 downto 0) := (others => '0');
   signal I_RET : std_logic := '0';

 	--Outputs
   signal O_RDY : std_logic;
   signal O_DIVZ : std_logic;
   signal O_CZ : std_logic_vector(1 downto 0);
   signal O_C : std_logic_vector(15 downto 0);
   signal O_D : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	I_CLK <= NOT I_CLK after I_CLK_period;
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DP PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_RDD => I_RDD,
          I_WRD => I_WRD,
          I_START => I_START,
          I_OPC => I_OPC,
          I_AB => I_AB,
          I_AC => I_AC,
          I_AD => I_AD,
          I_DATA => I_DATA,
          I_CZ => I_CZ,
          I_RET => I_RET,
          O_RDY => O_RDY,
          O_DIVZ => O_DIVZ,
          O_CZ => O_CZ,
          O_C => O_C,
          O_D => O_D
        );

	-- Stimulus process
	stim_proc: process
	begin		
		
		I_RST <= '1';
		
		wait for I_CLK_period*3;
	  
		I_RST <= '0';
		
		I_DATA <= X"0003";
		
		wait for I_CLK_period*2;
		
		I_WRD <= '1';
	  
		wait for I_CLK_period*2;
		
		I_WRD 	<= '0';
		I_DATA 	<= X"0002";
		I_AB	<= "00001";
		
		wait for I_CLK_period*2;
		
		I_WRD <= '1';
	  
		wait for I_CLK_period*2;
		
		I_WRD 	<= '0';
		I_AB	<= "00010";
		I_OPC	<= "01010";
	
		wait for I_CLK_period*2;
		
		I_START <= '1';
		
		wait for I_CLK_period*2;

		I_START <= '0';

		wait for I_CLK_period*38;

		I_AC	<= "00010";
		I_AD	<= "00011";

		I_RDD	<= '1';

		wait;
	end process;

END;
