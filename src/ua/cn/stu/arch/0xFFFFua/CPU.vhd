----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
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
end CPU;

architecture struct of CPU is
	
	component MUX2 is
		port (
			I0 		: in	STD_LOGIC;
			I1 		: in	STD_LOGIC;
			I_ADDR 	: in	STD_LOGIC;
			O 		: out	STD_LOGIC);
	end component;
	
	component MUX3x16 is
		port (
			I0		: in	STD_LOGIC_VECTOR (15 downto 0);
			I1		: in	STD_LOGIC_VECTOR (15 downto 0);
			I2		: in	STD_LOGIC_VECTOR (15 downto 0);
			I_ADDR	: in	STD_LOGIC_VECTOR (1 downto 0);
			O		: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component ROM1Kx16_DUO is
		port ( 
			I_CLK 	: in	STD_LOGIC;
			I_RST 	: in	STD_LOGIC;
			I_ADDR 	: in	STD_LOGIC_VECTOR (10 downto 0);
			O_DATA1	: out	STD_LOGIC_VECTOR (15 downto 0);
			O_DATA2	: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal ROM_I_ADDR	: STD_LOGIC_VECTOR (10 downto 0);
	signal ROM_O_DATA1	: STD_LOGIC_VECTOR (15 downto 0);
	signal ROM_O_DATA2	: STD_LOGIC_VECTOR (15 downto 0);
	
	component RAM2Kx16 is
		port (
			I_CLK	: in	STD_LOGIC;
			I_RST	: in	STD_LOGIC;
			I_WR	: in	STD_LOGIC;
			I_ADDR	: in	STD_LOGIC_VECTOR (10 downto 0);
			I_DATA	: in	STD_LOGIC_VECTOR (15 downto 0);
			O_DATA	: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal RAM_O_DATA	: STD_LOGIC_VECTOR(15 downto 0)  := (others => '0');
	
	component CB is
		port (
			I_CLK 		: in	STD_LOGIC;
			I_INSTR 	: in	STD_LOGIC_VECTOR (5 downto 0);
			I_CZ 		: in	STD_LOGIC_VECTOR (1 downto 0);
			I_RDY_DP 	: in	STD_LOGIC;
			I_RDY_PRL 	: in	STD_LOGIC;
			I_DIVZ	 	: in	STD_LOGIC;
			O_F_IP 		: out	STD_LOGIC_VECTOR (2 downto 0);
			O_DP_DI_ADDR: out	STD_LOGIC_VECTOR (1 downto 0);
			O_START_DP	: out	STD_LOGIC;
			O_WR_DP		: out	STD_LOGIC;
			O_WR_PRL	: out	STD_LOGIC;
			O_WR_RAM	: out	STD_LOGIC;
			O_RD_DP		: out	STD_LOGIC;
			O_RD_PRL	: out	STD_LOGIC;
			O_RDY_PRL_A : out	STD_LOGIC;
			O_RET		: out	STD_LOGIC);
	end component;
	
	signal CB_O_F_IP		: STD_LOGIC_VECTOR (2 downto 0);
	signal O_DP_DI_ADDR		: STD_LOGIC_VECTOR (1 downto 0);
	signal CB_O_WRD_DP		: STD_LOGIC;
	signal CB_O_RDD_DP		: STD_LOGIC;
	signal CB_O_START_DP	: STD_LOGIC;
	signal CB_O_RET			: STD_LOGIC;
	signal CB_O_WR_RAM		: STD_LOGIC;
	signal CB_O_RD_PRL		: STD_LOGIC;
	
	component DP is
		port (
			I_CLK 	: in	STD_LOGIC;
			I_RST 	: in	STD_LOGIC;
			I_RDD 	: in	STD_LOGIC;
			I_WRD 	: in	STD_LOGIC;
			I_START : in	STD_LOGIC;
			I_OPC 	: in	STD_LOGIC_VECTOR (4 downto 0);
			I_AB 	: in	STD_LOGIC_VECTOR (4 downto 0);
			I_AC 	: in	STD_LOGIC_VECTOR (4 downto 0);
			I_AD 	: in	STD_LOGIC_VECTOR (4 downto 0);
			I_DATA 	: in	STD_LOGIC_VECTOR (15 downto 0);
			I_CZ 	: in	STD_LOGIC_VECTOR (1 downto 0);
			I_RET 	: in	STD_LOGIC;
			O_RDY 	: out	STD_LOGIC;
			O_DIVZ 	: out	STD_LOGIC;
			O_CZ 	: out	STD_LOGIC_VECTOR (1 downto 0);
			O_C 	: out	STD_LOGIC_VECTOR (15 downto 0);
			O_D 	: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
		
	signal DP_I_DATA	: STD_LOGIC_VECTOR (15 downto 0);
	signal DP_O_CZ		: STD_LOGIC_VECTOR (1 downto 0);
	signal DP_O_RDY		: STD_LOGIC;
	signal DP_O_DIVZ	: STD_LOGIC;
	signal DP_O_C		: STD_LOGIC_VECTOR (15 downto 0);
	signal DP_O_D		: STD_LOGIC_VECTOR (15 downto 0);
	
	component IP is
		port (
			I_CLK	: 	in	STD_LOGIC;
			I_RST	: 	in	STD_LOGIC;
			F 		: 	in	STD_LOGIC_VECTOR (2 downto 0);
			I_DATA	: 	in	STD_LOGIC_VECTOR (10 downto 0);
			I_CZ 	: 	in	STD_LOGIC_VECTOR (1 downto 0);
			O_CZ 	: 	out	STD_LOGIC_VECTOR (1 downto 0);
			O_ADDR 	: 	out	STD_LOGIC_VECTOR (10 downto 0));
	end component;
	
	signal IP_O_CZ		: STD_LOGIC_VECTOR (1 downto 0);
begin

	ROM: ROM1Kx16_DUO
		port map( 
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_ADDR 	=> ROM_I_ADDR,
			O_DATA1	=> ROM_O_DATA1,
			O_DATA2	=> ROM_O_DATA2);
			
	O_ADDR_PRL <= ROM_O_DATA2(9 downto 5);
	
	RAM: RAM2Kx16
		port map(
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_WR	=> CB_O_WR_RAM,
			I_ADDR	=> DP_O_C(10 downto 0),
			I_DATA	=> DP_O_D,
			O_DATA	=> RAM_O_DATA);
			
	IP_instance: IP
		port map(
			I_CLK	=> I_CLK,
			I_RST	=> I_RST,
			F 		=> CB_O_F_IP,
			I_DATA	=> ROM_O_DATA1(10 downto 0),
			I_CZ 	=> DP_O_CZ,
			O_CZ 	=> IP_O_CZ,
			O_ADDR 	=> ROM_I_ADDR);
	
	DP_MUX : MUX3x16
			port map(
				I_ADDR 	=> O_DP_DI_ADDR,
				I0		=> RAM_O_DATA,
				I1		=> ROM_O_DATA2,
				I2		=> I_DATA,
				O	 	=> DP_I_DATA);
	
	DP_instance: DP
		port map(
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_RDD 	=> CB_O_RDD_DP,
			I_WRD 	=> CB_O_WRD_DP,
			I_START => CB_O_START_DP,
			I_AB 	=> ROM_O_DATA1(9 downto 5),
			I_AC 	=> ROM_O_DATA1(4 downto 0),
			I_AD 	=> ROM_O_DATA2(4 downto 0),
			I_OPC 	=> ROM_O_DATA2(15 downto 11),
			I_DATA 	=> DP_I_DATA,
			I_CZ 	=> IP_O_CZ,
			I_RET 	=> CB_O_RET,
			O_RDY 	=> DP_O_RDY,
			O_DIVZ 	=> DP_O_DIVZ,
			O_CZ 	=> DP_O_CZ,
			O_C 	=> DP_O_C,
			O_D 	=> DP_O_D);
	
	O_DATA <= DP_O_D;
			
	CB_instance: CB
		port map(
			I_CLK 		=> I_CLK,
			I_INSTR 	=> ROM_O_DATA1(15 downto 10),
			I_CZ 		=> DP_O_CZ,
			I_RDY_DP 	=> DP_O_RDY,
			I_RDY_PRL 	=> I_RDY_PRL,
			I_DIVZ	 	=> DP_O_DIVZ,
			O_F_IP 		=> CB_O_F_IP,
			O_START_DP	=> CB_O_START_DP,
			O_WR_DP		=> CB_O_WRD_DP,
			O_WR_PRL	=> O_WR_PRL,
			O_WR_RAM	=> CB_O_WR_RAM,
			O_RD_DP		=> CB_O_RDD_DP,
			O_RD_PRL	=> CB_O_RD_PRL,
			O_RDY_PRL_A => O_RDY_PRL_A,
			O_RET		=> CB_O_RET,
			O_DP_DI_ADDR=>O_DP_DI_ADDR);
			
	O_RD_PRL <= CB_O_RD_PRL;

end struct;

