--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:14:23 02/05/2012
-- Design Name:   
-- Module Name:   /home/alex/proj/vhdl/OxFFFFua/test/CPU_tb.vhd
-- Project Name:  OxFFFFua
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: OxFFFFua
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CPU_tb IS
END CPU_tb;
 
ARCHITECTURE behavior OF CPU_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT OxFFFFua
    PORT(
         I_CLK : IN  std_logic;
         I_RST : IN  std_logic;
         I_RDY_PRL : IN  std_logic;
         I_DATA : IN  std_logic_vector(15 downto 0);
         O_DATA : OUT  std_logic_vector(15 downto 0);
         O_ADDR_PRL : OUT  std_logic_vector(4 downto 0);
         O_WR_PRL : OUT  std_logic;
         O_RD_PRL : OUT  std_logic;
         O_RDY_PRL_A : OUT  std_logic
        );
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

   -- Clock period definitions
   constant I_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: OxFFFFua PORT MAP (
          I_CLK => I_CLK,
          I_RST => I_RST,
          I_RDY_PRL => I_RDY_PRL,
          I_DATA => I_DATA,
          O_DATA => O_DATA,
          O_ADDR_PRL => O_ADDR_PRL,
          O_WR_PRL => O_WR_PRL,
          O_RD_PRL => O_RD_PRL,
          O_RDY_PRL_A => O_RDY_PRL_A
        );

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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for I_CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
