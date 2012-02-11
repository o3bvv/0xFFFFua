LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
ENTITY ROM_tb IS
END ROM_tb;
 
ARCHITECTURE behavior OF ROM_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ROM_512x16_DUO
    PORT(
         I_CLK   : IN  std_logic;
         I_ADDR  : IN  std_logic_vector(8 downto 0);
         O_DATA0 : OUT  std_logic_vector(15 downto 0);
         O_DATA1 : OUT  std_logic_vector(15 downto 0));
    END COMPONENT;
    
   signal I_RST : std_logic := '0';
	
   --Inputs
   signal I_CLK : std_logic := '0';   
   signal I_ADDR : std_logic_vector(8 downto 0) := (others => '0');

 	--Outputs
   signal O_DATA0 : std_logic_vector(15 downto 0);
   signal O_DATA1 : std_logic_vector(15 downto 0);
   
   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ROM_512x16_DUO PORT MAP (
          I_CLK => I_CLK,
          I_ADDR => I_ADDR,
          O_DATA0 => O_DATA0,
          O_DATA1 => O_DATA1
        );

	I_CLK <= NOT I_CLK after I_CLK_period;
   
	process
	begin      
		I_RST <= '1';	  
		wait for I_CLK_period*3;
		
		I_RST <= '0';

		wait;
	end process;

	process(I_CLK, I_RST)
		variable ROM_addr : integer := 0;
	begin
		if (I_RST='1') then
			ROM_addr := 0;
		elsif (I_CLK='1' and I_CLK'event) then
			ROM_addr := ROM_addr+1;
		end if;
		
		I_ADDR <= conv_std_logic_vector(ROM_addr, I_ADDR'length);
	end process;

END;
