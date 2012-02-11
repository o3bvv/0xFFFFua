LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY DVU_tb IS
END DVU_tb;
 
ARCHITECTURE behavior OF DVU_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DVU
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         I_START : IN  std_logic;
         I_QO : IN  std_logic;
         I_A : IN  std_logic_vector(15 downto 0);
         I_B : IN  std_logic_vector(15 downto 0);
         O_Y : OUT  std_logic_vector(15 downto 0);
         O_Z : OUT  std_logic;
         O_HAI : OUT  std_logic;
         O_RDY : OUT  std_logic;
         O_DIVZ : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_START : std_logic := '0';
   signal I_QO : std_logic := '0';
   signal I_A : std_logic_vector(15 downto 0) := (others => '0');
   signal I_B : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal O_Y : std_logic_vector(15 downto 0);
   signal O_Z : std_logic;
   signal O_HAI : std_logic;
   signal O_RDY : std_logic;
   signal O_DIVZ : std_logic;

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DVU PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_START => I_START,
          I_QO => I_QO,
          I_A => I_A,
          I_B => I_B,
          O_Y => O_Y,
          O_Z => O_Z,
          O_HAI => O_HAI,
          O_RDY => O_RDY,
          O_DIVZ => O_DIVZ
        );

	I_CLK <= not I_CLK after I_CLK_period;

	I_B <= X"0003";
	
	process(O_HAI)
	begin
		if (O_HAI='1') then
			I_A <= X"0000";
		else
			I_A <= X"000F";
		end if;
	end process;

	-- Stimulus process
	stim_proc: process
	begin		
	
		I_RST <= '1';
		
		wait for I_CLK_period*3;
		
		I_RST <= '0';
		
		wait for I_CLK_period*2;
		
		I_START <= '1';
		
		wait for I_CLK_period*2;
		
		I_START <= '0';
		
		wait for I_CLK_period*42;
		
		I_QO <= '1';
	
		wait;
	end process;

END;
