LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY CPU_tb IS
END CPU_tb;
 
ARCHITECTURE behavior OF CPU_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU
    port (
		I_CLK 		: in	STD_LOGIC;
		I_RST 		: in	STD_LOGIC;
		I_RDY_PRL 	: in	STD_LOGIC;
		I_DATA 		: in	STD_LOGIC_VECTOR (15 downto 0);
		O_DATA 		: out	STD_LOGIC_VECTOR (15 downto 0);
		O_ADDR_PRL	: out	STD_LOGIC_VECTOR (4 downto 0);
		O_WR_PRL 	: out	STD_LOGIC;
		O_RD_PRL 	: out	STD_LOGIC;
		O_WR_DP 	: out	STD_LOGIC;
		O_RD_DP 	: out	STD_LOGIC;
		O_ROM_ADDR	: out	STD_LOGIC_VECTOR (9 downto 0);
		O_ROM0 		: out	STD_LOGIC_VECTOR (15 downto 0);
		O_ROM1 		: out	STD_LOGIC_VECTOR (15 downto 0);
		O_RDY_PRL_A	: out	STD_LOGIC);
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_RDY_PRL : std_logic := '0';
   signal I_DATA : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal O_DATA : std_logic_vector(15 downto 0);
   signal O_ADDR_PRL : std_logic_vector(4 downto 0);
   signal O_WR_PRL : std_logic;
   signal O_RD_PRL : std_logic;
   signal O_RDY_PRL_A : std_logic;

	signal O_WR_DP 	: STD_LOGIC;
	signal O_RD_DP 	: STD_LOGIC;
	signal O_ROM_ADDR	: STD_LOGIC_VECTOR (9 downto 0);
	signal O_ROM0 		: STD_LOGIC_VECTOR (15 downto 0);
	signal O_ROM1 		: STD_LOGIC_VECTOR (15 downto 0);

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	I_CLK <= NOT I_CLK after I_CLK_period;
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_RDY_PRL => I_RDY_PRL,
          I_DATA => I_DATA,
          O_DATA => O_DATA,
          O_ADDR_PRL => O_ADDR_PRL,
          O_WR_PRL => O_WR_PRL,
          O_RD_PRL => O_RD_PRL,
          O_RDY_PRL_A => O_RDY_PRL_A,
		  O_WR_DP => O_WR_DP,
		  O_RD_DP => O_RD_DP,
		  O_ROM_ADDR => O_ROM_ADDR,
		  O_ROM0 => O_ROM0,
		  O_ROM1 => O_ROM1
        );

	-- Stimulus process
	stim_proc: process
	begin		
      
		I_RST <= '1';
	  
		wait for I_CLK_period*3;

		I_RDY_PRL 	<= '1';
		I_RST 		<= '0';

		wait;
	end process;

END;
