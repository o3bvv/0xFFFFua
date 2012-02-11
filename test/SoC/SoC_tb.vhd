LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY SoC_tb IS
END SoC_tb;
 
ARCHITECTURE behavior OF SoC_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SoC
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         I_SW : IN  std_logic_vector(3 downto 0);
         I_FRXD : IN  std_logic;
         O_FTXD : OUT  std_logic;
         O_WR : OUT  std_logic;
         O_RDY : OUT  std_logic;
         O_RDYA : OUT  std_logic;
         O_DATA : OUT  std_logic_vector(15 downto 0);
         O_LED : OUT  std_logic_vector(7 downto 0);
		 O_LCD_RW	: out	STD_LOGIC;
		 O_LCD_RS	: out	STD_LOGIC;
		 O_LCD_E		: out	STD_LOGIC;
		 O_SF_CE0	: out	STD_LOGIC;
		 IO_SF_D_11_8: inout	STD_LOGIC_VECTOR (11 downto 8));
    END COMPONENT;
    

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_SW : std_logic_vector(3 downto 0) := "0000";
   signal I_FRXD : std_logic := '1';

 	--Outputs
   signal O_FTXD : std_logic;
   signal O_WR : std_logic;
   signal O_RDY : std_logic;
   signal O_RDYA : std_logic;
   signal O_DATA : std_logic_vector(15 downto 0);
   signal O_LED : std_logic_vector(7 downto 0);

   signal IO_SF_D_11_8 : std_logic_vector(11 downto 8);
   signal O_LCD_RW : std_logic;
   signal O_LCD_RS : std_logic;
   signal O_LCD_E : std_logic;
   signal O_SF_CE0 : std_logic;

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SoC PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_SW => I_SW,
          I_FRXD => I_FRXD,
          O_FTXD => O_FTXD,
          O_WR => O_WR,
          O_RDY => O_RDY,
          O_RDYA => O_RDYA,
          O_DATA => O_DATA,
          O_LED => O_LED,
		  IO_SF_D_11_8 => IO_SF_D_11_8,
		  O_LCD_RW  => O_LCD_RW,
		  O_LCD_RS  => O_LCD_RS,
		  O_LCD_E   => O_LCD_E,
		  O_SF_CE0  => O_SF_CE0);

   -- Clock process definitions
   I_CLK_process :process
   begin
		I_CLK <= '0';
		wait for I_CLK_period/2;
		I_CLK <= '1';
		wait for I_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      
	  I_RST<='1';
      wait for I_CLK_period*3;
	  I_RST<='0';
	  
	  wait for I_CLK_period*1900000;
	  
	  I_FRXD <= '0';
	  
      wait;
   end process;

END;
