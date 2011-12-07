----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Negativator is
	port (
		I_NUM : in	STD_LOGIC_VECTOR (15 downto 0);
		O_NUM : out	STD_LOGIC_VECTOR (15 downto 0));
end Negativator;

architecture Behavioral of Negativator is
begin
	O_NUM <= STD_LOGIC_VECTOR(UNSIGNED(not I_NUM) + 1);
end Behavioral;

