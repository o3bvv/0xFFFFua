--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:46:48 01/24/2012
-- Design Name:   
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY ASLOU_tb IS
END ASLOU_tb;
 
ARCHITECTURE behavior OF ASLOU_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ASLOU
    PORT(
         I_F : IN  std_logic_vector(2 downto 0);
         I_A : IN  std_logic_vector(15 downto 0);
         I_B : IN  std_logic_vector(15 downto 0);
         I_C : IN  std_logic;
         O_Y : OUT  std_logic_vector(15 downto 0);
         O_C : OUT  std_logic;
         O_Z : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal I_F : std_logic_vector(2 downto 0) := (others => '0');
   signal I_A : std_logic_vector(15 downto 0) := (others => '0');
   signal I_B : std_logic_vector(15 downto 0) := (others => '0');
   signal I_C : std_logic := '0';

 	--Outputs
   signal O_Y : std_logic_vector(15 downto 0);
   signal O_C : std_logic;
   signal O_Z : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

	-- Clock period definitions
   constant I_CLK_period : time := 10 ns;
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ASLOU PORT MAP (
          I_F => I_F,
          I_A => I_A,
          I_B => I_B,
          I_C => I_C,
          O_Y => O_Y,
          O_C => O_C,
          O_Z => O_Z
        );

   stim_proc: process
   begin		

      wait for I_CLK_period*3;

      I_A <= X"0003";
	  I_B <= X"0006";
	  
	  wait for I_CLK_period*2;
	  
	  I_A <= X"0003";
	  I_B <= X"FFFF";
	  
	  wait for I_CLK_period*2;
	  
	  I_A <= X"0000";
	  I_B <= X"0000";
	  
	  wait for I_CLK_period*2;
	  
	  I_C <= '1';
	  
	  wait for I_CLK_period*2;
	  
	  I_C <= '0';
	  
	  I_F <= "001";
	  
	  I_A <= X"0008";
	  I_B <= X"0002";
	  
	  wait for I_CLK_period*2;
	  
	  I_A <= X"0008";
	  I_B <= X"0008";
	  
	  wait for I_CLK_period*2;
	  
	  I_A <= X"0008";
	  I_B <= X"000A";	  	 
	  
	  wait for I_CLK_period*2;
	  
	  I_C <= '1';
	  
	  wait for I_CLK_period*2;
	  
      I_C <= '0';
	  
	  I_F <= "010";
	  
	  I_A <= X"0008";
	  I_B <= X"0002";
	  
	  wait for I_CLK_period*2;
	  
	  I_A <= X"0008";
	  I_B <= X"0009";
	  
	  wait for I_CLK_period*2;
	  
	  I_F <= "011";
	  
	  I_A <= X"0008";
	  I_B <= X"0002";
	  
	  wait for I_CLK_period*2;
	  
	  I_A <= X"0008";
	  I_B <= X"0009";
	  
	  wait for I_CLK_period*2;
	  
	  I_F <= "100";
	  
	  I_A <= X"0008";
	  I_B <= X"0002";
	  
	  wait for I_CLK_period*2;
	  
	  I_A <= X"0008";
	  I_B <= X"0009";
	  
	  wait for I_CLK_period*2;
	  
      wait;
   end process;

END;
