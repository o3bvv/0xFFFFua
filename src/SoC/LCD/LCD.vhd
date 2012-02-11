----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LCD is
	port (
		I_CLK		: in	STD_LOGIC;
		I_RST		: in	STD_LOGIC;
		I_WR		: in	STD_LOGIC;
		I_E			: in	STD_LOGIC;
		I_FLG_DATA	: in	STD_LOGIC;
		I_BYTE		: in	STD_LOGIC_VECTOR (7 downto 0);
		I_RDY_A		: in	STD_LOGIC;
		O_RDY		: out	STD_LOGIC;
		O_LCD_RW	: out	STD_LOGIC;
		O_LCD_RS	: out	STD_LOGIC;
		O_LCD_E		: out	STD_LOGIC;
		O_SF_CE0	: out	STD_LOGIC;
		O_SF_D		: out	STD_LOGIC_VECTOR (3 downto 0));
end LCD;

architecture arch of LCD is

	component MUX2 is
		port(
			I_ADDR 	: in  	STD_LOGIC;
			I0		: in	STD_LOGIC;
			I1		: in	STD_LOGIC;
			O		: out	STD_LOGIC);
	end component;

	component MUX4x2 is
		port(
			I_ADDR 	: in  	STD_LOGIC;
			I0		: in	STD_LOGIC_VECTOR (3 downto 0);
			I1		: in	STD_LOGIC_VECTOR (3 downto 0);
			O		: out	STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	component LCD_byte_transmitter is
		port (
			I_CLK		: in	STD_LOGIC;
			I_RST		: in	STD_LOGIC;
			I_START		: in	STD_LOGIC;
			I_FLG_DATA	: in	STD_LOGIC;
			I_BYTE		: in	STD_LOGIC_VECTOR (7 downto 0);
			O_RDY		: out	STD_LOGIC;
			O_LCD_RW	: out	STD_LOGIC;
			O_LCD_RS	: out	STD_LOGIC;
			O_LCD_E		: out	STD_LOGIC;
			O_SF_D		: out	STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	signal TX_O_RDY		: STD_LOGIC;
	signal TX_O_LCD_E	: STD_LOGIC;
	signal TX_O_SF_D	: STD_LOGIC_VECTOR (3 downto 0);
	signal TX_I_START	: STD_LOGIC;
	
	component LCD_initializer is
		port (
			I_CLK	: in	STD_LOGIC;
			I_RST	: in	STD_LOGIC;
			O_RDY	: out	STD_LOGIC;
			O_SF_D	: out	STD_LOGIC_VECTOR (3 downto 0);
			O_LCD_E	: out	STD_LOGIC);
	end component;
	
	signal INIT_O_RDY	: STD_LOGIC;
	signal INIT_O_LCD_E	: STD_LOGIC;
	signal INIT_O_SF_D	: STD_LOGIC_VECTOR (3 downto 0);
	
	constant C_VCC 	: STD_LOGIC := '1';
begin

	INITIALIZER: LCD_initializer
		port map(
			I_CLK	=> I_CLK,
			I_RST	=> I_RST,
			O_RDY	=> INIT_O_RDY,
			O_LCD_E => INIT_O_LCD_E,
			O_SF_D	=> INIT_O_SF_D);

	TRANSMITTER: LCD_byte_transmitter
		port map(
			I_CLK		=> I_CLK,
			I_RST		=> I_RST,
			I_FLG_DATA 	=> I_FLG_DATA,
			I_START		=> TX_I_START,
			I_BYTE		=> I_BYTE,
			O_LCD_E		=> TX_O_LCD_E,
			O_LCD_RW	=> O_LCD_RW,
			O_LCD_RS	=> O_LCD_RS,
			O_SF_D		=> TX_O_SF_D,
			O_RDY		=> TX_O_RDY);

	TX_I_START <= I_E and I_WR and INIT_O_RDY and I_RDY_A;

	O_LCD_E <= INIT_O_LCD_E when INIT_O_RDY='0' else TX_O_LCD_E;
	O_SF_D  <= INIT_O_SF_D  when INIT_O_RDY='0' else TX_O_SF_D;
		
	O_RDY	 <= INIT_O_RDY and TX_O_RDY;
	O_SF_CE0 <= C_VCC;
end arch;

