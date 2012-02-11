LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY LCD_tester_tb IS
END LCD_tester_tb;
 
ARCHITECTURE behavior OF LCD_tester_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LCD_tester
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         O_LCD_RW : OUT  std_logic;
         O_LCD_RS : OUT  std_logic;
         O_LCD_E : OUT  std_logic;
         O_SF_CE0 : OUT  std_logic;
         IO_SF_D_11_8 : INOUT  std_logic_vector(11 downto 8)
        );
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';

	--BiDirs
   signal IO_SF_D_11_8 : std_logic_vector(11 downto 8);

 	--Outputs
   signal O_LCD_RW : std_logic;
   signal O_LCD_RS : std_logic;
   signal O_LCD_E : std_logic;
   signal O_SF_CE0 : std_logic;

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: LCD_tester PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          O_LCD_RW => O_LCD_RW,
          O_LCD_RS => O_LCD_RS,
          O_LCD_E => O_LCD_E,
          O_SF_CE0 => O_SF_CE0,
          IO_SF_D_11_8 => IO_SF_D_11_8
        );

   I_CLK <= NOT I_CLK after I_CLK_period;

   -- Stimulus process
   stim_proc: process
   begin

	  I_RST <= '1';

      wait for I_CLK_period*3;

	  I_RST <= '0';

      wait;
   end process;

END;
