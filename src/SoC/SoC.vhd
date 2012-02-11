----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SoC is
	port (
		I_CLK		: in	STD_LOGIC;
		I_RST		: in	STD_LOGIC;
		
		I_SW		: in	STD_LOGIC_VECTOR (3 downto 0);
		
		I_FRXD		: in	STD_LOGIC;
        O_FTXD		: out	STD_LOGIC;
		
		O_WR		: out	STD_LOGIC;
		O_RDY		: out	STD_LOGIC;

		O_RDYA		: out	STD_LOGIC;
		O_DATA		: out	STD_LOGIC_VECTOR (15 downto 0);
		
		O_LED		: out	STD_LOGIC_VECTOR (7 downto 0);
		
		O_LCD_RW	: out	STD_LOGIC;
		O_LCD_RS	: out	STD_LOGIC;
		O_LCD_E		: out	STD_LOGIC;
		O_SF_CE0	: out	STD_LOGIC;
		IO_SF_D_11_8: inout	STD_LOGIC_VECTOR (11 downto 8));
end SoC;

architecture arch of SoC is
	
	component DC5 is
		port (
			I0	: in	STD_LOGIC;
			I1	: in	STD_LOGIC;
			I2	: in	STD_LOGIC;
			I3	: in	STD_LOGIC;
			I4	: in	STD_LOGIC;
			O	: out	STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	component MUX32 is
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
	end component;
	
	component MUX32x16 is
		port (
			I_ADDR 	: in  	STD_LOGIC_VECTOR (4 downto 0);
			I0		: in	STD_LOGIC_VECTOR (15 downto 0);
			I1		: in	STD_LOGIC_VECTOR (15 downto 0);
			I2		: in	STD_LOGIC_VECTOR (15 downto 0);
			I3		: in	STD_LOGIC_VECTOR (15 downto 0);
			I4		: in	STD_LOGIC_VECTOR (15 downto 0);
			I5		: in	STD_LOGIC_VECTOR (15 downto 0);
			I6		: in	STD_LOGIC_VECTOR (15 downto 0);
			I7		: in	STD_LOGIC_VECTOR (15 downto 0);
			I8		: in	STD_LOGIC_VECTOR (15 downto 0);
			I9		: in	STD_LOGIC_VECTOR (15 downto 0);
			I10		: in	STD_LOGIC_VECTOR (15 downto 0);
			I11		: in	STD_LOGIC_VECTOR (15 downto 0);
			I12		: in	STD_LOGIC_VECTOR (15 downto 0);
			I13		: in	STD_LOGIC_VECTOR (15 downto 0);
			I14		: in	STD_LOGIC_VECTOR (15 downto 0);
			I15		: in	STD_LOGIC_VECTOR (15 downto 0);
			I16		: in	STD_LOGIC_VECTOR (15 downto 0);
			I17		: in	STD_LOGIC_VECTOR (15 downto 0);
			I18		: in	STD_LOGIC_VECTOR (15 downto 0);
			I19		: in	STD_LOGIC_VECTOR (15 downto 0);
			I20		: in	STD_LOGIC_VECTOR (15 downto 0);
			I21		: in	STD_LOGIC_VECTOR (15 downto 0);
			I22		: in	STD_LOGIC_VECTOR (15 downto 0);
			I23		: in	STD_LOGIC_VECTOR (15 downto 0);
			I24		: in	STD_LOGIC_VECTOR (15 downto 0);
			I25		: in	STD_LOGIC_VECTOR (15 downto 0);
			I26		: in	STD_LOGIC_VECTOR (15 downto 0);
			I27		: in	STD_LOGIC_VECTOR (15 downto 0);
			I28		: in	STD_LOGIC_VECTOR (15 downto 0);
			I29		: in	STD_LOGIC_VECTOR (15 downto 0);
			I30		: in	STD_LOGIC_VECTOR (15 downto 0);
			I31		: in	STD_LOGIC_VECTOR (15 downto 0);
			O		: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	type SLV32x16 is 
		array(0 to 31) of STD_LOGIC_VECTOR (15 downto 0);
	
	signal MUX_I_DATA_IN : SLV32x16 := (others => (others => '0'));
	
	component LED is
		port (
			I_CLK 	: in	STD_LOGIC;
			I_RST 	: in	STD_LOGIC;
			I_E 	: in	STD_LOGIC;
			I_WR 	: in	STD_LOGIC;
			I_DATA	: in	STD_LOGIC_VECTOR(7 downto 0);
			O_LED	: out	STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component uart is
		generic(
			G_DATA_WIDTH : natural := 8;
			G_RD_SAMPLES : natural := 14);
		port (
			I_CLK 		: in	STD_LOGIC;
			I_RST 		: in	STD_LOGIC;
			I_WR		: in	STD_LOGIC;
			I_RD		: in	STD_LOGIC;
			I_RXE		: in	STD_LOGIC;
			I_TXE		: in	STD_LOGIC;
			I_BRS		: in	STD_LOGIC;
			I_TX_RDY_A	: in	STD_LOGIC;
			I_RX_RDY_A	: in	STD_LOGIC;
			I_DATA		: in	STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
			I_RXD		: in	STD_LOGIC;
			O_DATA		: out	STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
			O_TXD		: out	STD_LOGIC;
			O_TX_RDY	: out	STD_LOGIC;
			O_RX_RDY	: out	STD_LOGIC);
	end component;
	
	signal FUART_O_DATA : std_logic_vector(7 downto 0);
	signal FUART_TX_RDY : std_logic;
	signal FUART_RX_RDY : std_logic;
	
	component LCD is
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
	end component;

	signal LCD_O_RDY	: STD_LOGIC := '0';
	signal LCD_O_RS		: STD_LOGIC := '0';
	signal LCD_SF_D 	: STD_LOGIC_VECTOR (11 downto 8) := "ZZZZ";

	component OxFFFFua is
		port (
			I_CLK 		: in	STD_LOGIC;
			I_RST 		: in	STD_LOGIC;
			I_RDY_PRL 	: in	STD_LOGIC;
			I_DATA 		: in	STD_LOGIC_VECTOR (15 downto 0);
			O_DATA 		: out	STD_LOGIC_VECTOR (15 downto 0);
			O_ADDR_PRL	: out	STD_LOGIC_VECTOR (4 downto 0);
			O_WR_PRL 	: out	STD_LOGIC;
			O_RD_PRL 	: out	STD_LOGIC;
			O_RDY_PRL_A	: out	STD_LOGIC);
	end component;

	signal CPU_I_RDY_PRLs	: STD_LOGIC_VECTOR (31 downto 0);
	signal CPU_I_RDY_PRL	: STD_LOGIC;
	signal CPU_O_RDY_PRL_A	: STD_LOGIC;
	signal CPU_O_WR_PRL 	: STD_LOGIC;
	signal CPU_O_RD_PRL 	: STD_LOGIC;
	signal CPU_I_DATA 		: STD_LOGIC_VECTOR (15 downto 0);
	signal CPU_O_DATA 		: STD_LOGIC_VECTOR (15 downto 0);
	signal CPU_O_ADDR_PRL	: STD_LOGIC_VECTOR (4 downto 0);
	
	signal L_CS	: STD_LOGIC_VECTOR (31 downto 0);
	
	constant ID_PRL_LED 	: natural	:= 0;
	constant ID_PRL_SW		: natural	:= 1;
	constant ID_PRL_FUART_RX: natural	:= 2;
	constant ID_PRL_FUART_TX: natural	:= 3;
	constant ID_PRL_LCD 	: natural	:= 4;
	
	constant C_VCC : STD_LOGIC	:= '1';
begin

	DC_CS: DC5
		port map(
			O	=> L_CS,
			I0	=> CPU_O_ADDR_PRL(0),
			I1	=> CPU_O_ADDR_PRL(1),
			I2	=> CPU_O_ADDR_PRL(2),
			I3	=> CPU_O_ADDR_PRL(3),
			I4	=> CPU_O_ADDR_PRL(4));
	
	MUX_RDY: MUX32
		port map(
			I_ADDR 	=> CPU_O_ADDR_PRL,
			I0		=> CPU_I_RDY_PRLs(0),
			I1		=> CPU_I_RDY_PRLs(1),
			I2		=> CPU_I_RDY_PRLs(2),
			I3		=> CPU_I_RDY_PRLs(3),
			I4		=> CPU_I_RDY_PRLs(4),
			I5		=> CPU_I_RDY_PRLs(5),
			I6		=> CPU_I_RDY_PRLs(6),
			I7		=> CPU_I_RDY_PRLs(7),
			I8		=> CPU_I_RDY_PRLs(8),
			I9		=> CPU_I_RDY_PRLs(9),
			I10		=> CPU_I_RDY_PRLs(10),
			I11		=> CPU_I_RDY_PRLs(11),
			I12		=> CPU_I_RDY_PRLs(12),
			I13		=> CPU_I_RDY_PRLs(13),
			I14		=> CPU_I_RDY_PRLs(14),
			I15		=> CPU_I_RDY_PRLs(15),
			I16		=> CPU_I_RDY_PRLs(16),
			I17		=> CPU_I_RDY_PRLs(17),
			I18		=> CPU_I_RDY_PRLs(18),
			I19		=> CPU_I_RDY_PRLs(19),
			I20		=> CPU_I_RDY_PRLs(20),
			I21		=> CPU_I_RDY_PRLs(21),
			I22		=> CPU_I_RDY_PRLs(22),
			I23		=> CPU_I_RDY_PRLs(23),
			I24		=> CPU_I_RDY_PRLs(24),
			I25		=> CPU_I_RDY_PRLs(25),
			I26		=> CPU_I_RDY_PRLs(26),
			I27		=> CPU_I_RDY_PRLs(27),
			I28		=> CPU_I_RDY_PRLs(28),
			I29		=> CPU_I_RDY_PRLs(29),
			I30		=> CPU_I_RDY_PRLs(30),
			I31		=> CPU_I_RDY_PRLs(31),
			O		=> CPU_I_RDY_PRL);
	
	MUX_I_DATA: MUX32x16
		port map(
			I_ADDR 	=> CPU_O_ADDR_PRL,
			I0		=> MUX_I_DATA_IN(0),
			I1		=> MUX_I_DATA_IN(1),
			I2		=> MUX_I_DATA_IN(2),
			I3		=> MUX_I_DATA_IN(3),
			I4		=> MUX_I_DATA_IN(4),
			I5		=> MUX_I_DATA_IN(5),
			I6		=> MUX_I_DATA_IN(6),
			I7		=> MUX_I_DATA_IN(7),
			I8		=> MUX_I_DATA_IN(8),
			I9		=> MUX_I_DATA_IN(9),
			I10		=> MUX_I_DATA_IN(10),
			I11		=> MUX_I_DATA_IN(11),
			I12		=> MUX_I_DATA_IN(12),
			I13		=> MUX_I_DATA_IN(13),
			I14		=> MUX_I_DATA_IN(14),
			I15		=> MUX_I_DATA_IN(15),
			I16		=> MUX_I_DATA_IN(16),
			I17		=> MUX_I_DATA_IN(17),
			I18		=> MUX_I_DATA_IN(18),
			I19		=> MUX_I_DATA_IN(19),
			I20		=> MUX_I_DATA_IN(20),
			I21		=> MUX_I_DATA_IN(21),
			I22		=> MUX_I_DATA_IN(22),
			I23		=> MUX_I_DATA_IN(23),
			I24		=> MUX_I_DATA_IN(24),
			I25		=> MUX_I_DATA_IN(25),
			I26		=> MUX_I_DATA_IN(26),
			I27		=> MUX_I_DATA_IN(27),
			I28		=> MUX_I_DATA_IN(28),
			I29		=> MUX_I_DATA_IN(29),
			I30		=> MUX_I_DATA_IN(30),
			I31		=> MUX_I_DATA_IN(31),
			O		=> CPU_I_DATA);
	
	PRL_LED : LED
		port map(
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_E 	=> L_CS(ID_PRL_LED),
			I_WR 	=> CPU_O_WR_PRL,
			I_DATA	=> CPU_O_DATA(7 downto 0),
			O_LED	=> O_LED);

	PRL_FUART: uart PORT MAP (
			I_CLK 		=> I_CLK,
			I_RST 		=> I_RST,
			I_WR 		=> CPU_O_WR_PRL,
			I_RD 		=> CPU_O_RD_PRL,
			I_RXE 		=> L_CS(ID_PRL_FUART_RX),
			I_TXE 		=> L_CS(ID_PRL_FUART_TX),
			I_BRS 		=> CPU_O_DATA(8),
			I_TX_RDY_A	=> CPU_O_RDY_PRL_A,
			I_RX_RDY_A	=> CPU_O_RDY_PRL_A,
			I_DATA 		=> CPU_O_DATA(7 downto 0),
			I_RXD 		=> I_FRXD,
			O_DATA 		=> FUART_O_DATA,
			O_TXD 		=> O_FTXD,
			O_TX_RDY 	=> FUART_TX_RDY,
			O_RX_RDY 	=> FUART_RX_RDY);
			
	PRL_LCD: LCD
		port map(
			I_CLK 		=> I_CLK,
			I_RST 		=> I_RST,
			I_E 		=> L_CS(ID_PRL_LCD),
			I_WR 		=> CPU_O_WR_PRL,
			I_FLG_DATA	=> CPU_O_DATA(8),
			I_BYTE		=> CPU_O_DATA(7 downto 0),
			I_RDY_A		=> CPU_O_RDY_PRL_A,
			O_RDY		=> LCD_O_RDY,
			O_LCD_RW	=> O_LCD_RW,
			O_LCD_RS	=> LCD_O_RS,
			O_LCD_E		=> O_LCD_E,
			O_SF_CE0	=> O_SF_CE0,
			O_SF_D		=> LCD_SF_D);

	O_LCD_RS     <= LCD_O_RS;
	IO_SF_D_11_8 <= LCD_SF_D when (LCD_O_RDY='0') else "ZZZZ";

	CPU_instance : OxFFFFua
		port map(
			I_CLK 		=> I_CLK,
			I_RST 		=> I_RST,
			I_RDY_PRL 	=> CPU_I_RDY_PRL,
			I_DATA 		=> CPU_I_DATA,
			O_ADDR_PRL	=> CPU_O_ADDR_PRL,
			O_WR_PRL	=> CPU_O_WR_PRL,
			O_RD_PRL	=> CPU_O_RD_PRL,
			O_RDY_PRL_A => CPU_O_RDY_PRL_A,
			O_DATA 		=> CPU_O_DATA);	
	
	CPU_I_RDY_PRLs(ID_PRL_LED)		<= C_VCC;
	CPU_I_RDY_PRLs(ID_PRL_SW)		<= C_VCC;
	CPU_I_RDY_PRLs(ID_PRL_FUART_RX)	<= FUART_RX_RDY;
	CPU_I_RDY_PRLs(ID_PRL_FUART_TX)	<= FUART_TX_RDY;
	CPU_I_RDY_PRLs(ID_PRL_LCD)		<= LCD_O_RDY;

	MUX_I_DATA_IN(ID_PRL_SW)		<= X"000" & I_SW;
	MUX_I_DATA_IN(ID_PRL_FUART_RX)	<= X"00"  & FUART_O_DATA;

	O_WR 	<= CPU_O_WR_PRL;
	O_DATA 	<= CPU_O_DATA;
	O_RDY	<= CPU_I_RDY_PRL;
	O_RDYA	<= CPU_O_RDY_PRL_A;
	
end arch;

