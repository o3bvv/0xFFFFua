LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
ENTITY ROM_tb IS
END ROM_tb;
 
ARCHITECTURE behavior OF ROM_tb IS 
 
    COMPONENT ROM_1024x16_DUO
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         I_ADDR : IN  std_logic_vector(9 downto 0);
         O_DATA0 : OUT  std_logic_vector(15 downto 0);
         O_DATA1 : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;   

   --Inputs
   signal I_CLK : std_logic := '0';
   signal I_RST : std_logic := '0';
   signal I_ADDR : std_logic_vector(9 downto 0) := (others => '0');

 	--Outputs
   signal O_DATA0 : std_logic_vector(15 downto 0);
   signal O_DATA1 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	I_CLK <= NOT I_CLK after I_CLK_period;
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ROM_1024x16_DUO PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_ADDR => I_ADDR,
          O_DATA0 => O_DATA0,
          O_DATA1 => O_DATA1
        );

	process
	begin
		I_RST <= '1';
		wait for I_CLK_period*2;
		I_RST <= '0';
		wait;
	end process;
   
	process(I_CLK, I_RST)
		variable v_addr : integer := 0;
	begin		
		if (I_RST='1') then
			v_addr := 0;
		elsif (I_CLK='1' and I_CLK'event) then
			if (v_addr<8) then
				v_addr := v_addr + 1;
			end if;
		end if;
		I_ADDR <= conv_std_logic_vector(v_addr, I_ADDR'length);
	end process;

END;
