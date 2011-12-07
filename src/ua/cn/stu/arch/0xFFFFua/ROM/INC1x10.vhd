----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INC1x10 is
	port (
		I : in  STD_LOGIC_VECTOR (9 downto 0);
		O : out  STD_LOGIC_VECTOR (9 downto 0));
end INC1x10;

architecture Behavioral of INC1x10 is

begin
	O <= STD_LOGIC_VECTOR(UNSIGNED(I)+1);
end Behavioral;

