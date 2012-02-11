library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DC5 is
	port (
		I0	: in	STD_LOGIC;
		I1	: in	STD_LOGIC;
		I2	: in	STD_LOGIC;
		I3	: in	STD_LOGIC;
		I4	: in	STD_LOGIC;
		O	: out	STD_LOGIC_VECTOR (31 downto 0));
end DC5;

architecture behavioral of DC5 is
begin

	O(0)	<= (not I4 and not	I3 and not	I2 and not  I1 and not	I0); -- 00000
	O(1)	<= (not I4 and not	I3 and not	I2 and not  I1 and 		I0); -- 00001
	O(2)	<= (not I4 and not	I3 and not	I2 and 		I1 and not  I0); -- 00010
	O(3)	<= (not I4 and not	I3 and not	I2 and 		I1 and 	 	I0); -- 00011
	O(4)	<= (not I4 and not	I3 and 		I2 and not  I1 and not 	I0); -- 00100
	O(5)	<= (not I4 and not	I3 and 		I2 and not  I1 and 	 	I0); -- 00101
	O(6)	<= (not I4 and not	I3 and 		I2 and		I1 and not	I0); -- 00110
	O(7)	<= (not I4 and not	I3 and 		I2 and		I1 and 		I0); -- 00111
	
	O(8)	<= (not I4 and		I3 and not	I2 and not	I1 and not	I0); -- 01000
	O(9)	<= (not I4 and		I3 and not	I2 and not	I1 and 		I0); -- 01001
	O(10)	<= (not I4 and		I3 and not	I2 and 		I1 and not	I0); -- 01010
	O(11)	<= (not I4 and		I3 and not	I2 and 		I1 and 		I0); -- 01011
	O(12)	<= (not I4 and		I3 and 		I2 and not	I1 and not	I0); -- 01100
	O(13)	<= (not I4 and		I3 and 		I2 and not	I1 and 		I0); -- 01101
	O(14)	<= (not I4 and		I3 and 		I2 and 		I1 and not	I0); -- 01110
	O(15)	<= (not I4 and		I3 and 		I2 and 		I1 and 		I0); -- 01111
	
	O(16)	<= (	I4 and not	I3 and not	I2 and not  I1 and not	I0); -- 10000
	O(17)	<= (	I4 and not	I3 and not	I2 and not  I1 and 		I0); -- 10001
	O(18)	<= (	I4 and not	I3 and not	I2 and 		I1 and not  I0); -- 10010
	O(19)	<= (	I4 and not	I3 and not	I2 and 		I1 and 	 	I0); -- 10011
	O(20)	<= (	I4 and not	I3 and 		I2 and not  I1 and not 	I0); -- 10100
	O(21)	<= (	I4 and not	I3 and 		I2 and not  I1 and 	 	I0); -- 10101
	O(22)	<= (	I4 and not	I3 and 		I2 and		I1 and not	I0); -- 10110
	O(23)	<= (	I4 and not	I3 and 		I2 and		I1 and 		I0); -- 10111
	
	O(24)	<= (	I4 and		I3 and not	I2 and not	I1 and not	I0); -- 11000
	O(25)	<= (	I4 and		I3 and not	I2 and not	I1 and 		I0); -- 11001
	O(26)	<= (	I4 and		I3 and not	I2 and 		I1 and not	I0); -- 11010
	O(27)	<= (	I4 and		I3 and not	I2 and 		I1 and 		I0); -- 11011
	O(28)	<= (	I4 and		I3 and 		I2 and not	I1 and not	I0); -- 11100
	O(29)	<= (	I4 and		I3 and 		I2 and not	I1 and 		I0); -- 11101
	O(30)	<= (	I4 and		I3 and 		I2 and 		I1 and not	I0); -- 11110
	O(31)	<= (	I4 and		I3 and 		I2 and 		I1 and 		I0); -- 11111	

end behavioral;

