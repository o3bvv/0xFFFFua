library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX32 is
	port (
		I_ADDR 	: in  	STD_LOGIC_VECTOR (4 downto 0);
		I0		: in	STD_LOGIC;
		I1		: in	STD_LOGIC;
		I2		: in	STD_LOGIC;
		I3		: in	STD_LOGIC;
		I4		: in	STD_LOGIC;
		I5		: in	STD_LOGIC;
		I6		: in	STD_LOGIC;
		I7		: in	STD_LOGIC;
		I8		: in	STD_LOGIC;
		I9		: in	STD_LOGIC;
		I10		: in	STD_LOGIC;
		I11		: in	STD_LOGIC;
		I12		: in	STD_LOGIC;
		I13		: in	STD_LOGIC;
		I14		: in	STD_LOGIC;
		I15		: in	STD_LOGIC;
		I16		: in	STD_LOGIC;
		I17		: in	STD_LOGIC;
		I18		: in	STD_LOGIC;
		I19		: in	STD_LOGIC;
		I20		: in	STD_LOGIC;
		I21		: in	STD_LOGIC;
		I22		: in	STD_LOGIC;
		I23		: in	STD_LOGIC;
		I24		: in	STD_LOGIC;
		I25		: in	STD_LOGIC;
		I26		: in	STD_LOGIC;
		I27		: in	STD_LOGIC;
		I28		: in	STD_LOGIC;
		I29		: in	STD_LOGIC;
		I30		: in	STD_LOGIC;
		I31		: in	STD_LOGIC;
		O		: out	STD_LOGIC);
end MUX32;

architecture behavioral of MUX32 is

begin

	with I_ADDR select
		O <= 
			I0	when "00000",
			I1	when "00001",
			I2	when "00010",
			I3	when "00011",
			I4	when "00100",
			I5	when "00101",
			I6	when "00110",
			I7	when "00111",
			I8	when "01000",
			I9	when "01001",
			I10	when "01010",
			I11	when "01011",
			I12	when "01100",
			I13	when "01101",
			I14	when "01110",
			I15	when "01111",
			I16	when "10000",
			I17	when "10001",
			I18	when "10010",
			I19	when "10011",
			I20	when "10100",
			I21	when "10101",
			I22	when "10110",
			I23	when "10111",
			I24	when "11000",
			I25	when "11001",
			I26	when "11010",
			I27	when "11011",
			I28	when "11100",
			I29	when "11101",
			I30	when "11110",
			I31	when "11111",
			'0'	when others;

end behavioral;

