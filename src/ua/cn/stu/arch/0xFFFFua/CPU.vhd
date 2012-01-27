----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

library UNISIM;
use UNISIM.VComponents.all;

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
		O_WR_DP 	: out	STD_LOGIC;
		O_RD_DP 	: out	STD_LOGIC;
		O_ROM_ADDR	: out	STD_LOGIC_VECTOR (9 downto 0);
		O_ROM0 		: out	STD_LOGIC_VECTOR (15 downto 0);
		O_ROM1 		: out	STD_LOGIC_VECTOR (15 downto 0);
		O_RDY_PRL_A	: out	STD_LOGIC);
end CPU;

architecture arch of CPU is
	
	component MUX3x16 is
		port (
			I0		: in	STD_LOGIC_VECTOR (15 downto 0);
			I1		: in	STD_LOGIC_VECTOR (15 downto 0);
			I2		: in	STD_LOGIC_VECTOR (15 downto 0);
			I_ADDR	: in	STD_LOGIC_VECTOR (1 downto 0);
			O		: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component ROM_1024x16_DUO is
		port ( 
			I_CLK 	: in	STD_LOGIC;
			I_RST 	: in	STD_LOGIC;
			I_ADDR 	: in	STD_LOGIC_VECTOR (9 downto 0);
			O_DATA0	: out	STD_LOGIC_VECTOR (15 downto 0);
			O_DATA1	: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal ROM_I_ADDR	: STD_LOGIC_VECTOR (9 downto 0)  := (others=>'0');
	signal ROM_O_DATA0	: STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
	signal ROM_O_DATA1	: STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
	
	component RAM_1024x16 is
		port (
			I_CLK	: in	STD_LOGIC;
			I_RST	: in	STD_LOGIC;
			I_WR	: in	STD_LOGIC;
			I_ADDR	: in	STD_LOGIC_VECTOR (9 downto 0);
			I_DATA	: in	STD_LOGIC_VECTOR (15 downto 0);
			O_DATA	: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal RAM_O_DATA	: STD_LOGIC_VECTOR(15 downto 0)  := (others => '0');
	
	--------------------------------------------------------
	-- CB
	--------------------------------------------------------
		
	signal O_DP_DI_ADDR		: STD_LOGIC_VECTOR (1 downto 0) := (others=>'0');
	signal CB_O_WRD_DP		: STD_LOGIC := '0';
	signal CB_O_RDD_DP		: STD_LOGIC := '0';
	signal CB_O_START_DP	: STD_LOGIC := '0';
	signal CB_O_RET			: STD_LOGIC := '0';
	signal CB_O_WR_RAM		: STD_LOGIC := '0';
	signal CB_O_RD_PRL		: STD_LOGIC := '0';
	
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
	
	signal DP_CLK		: STD_LOGIC := '0';	
	signal DP_I_DATA	: STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
	signal DP_I_CZ		: STD_LOGIC_VECTOR (1 downto 0)  := (others=>'0');
	signal DP_O_CZ		: STD_LOGIC_VECTOR (1 downto 0)  := (others=>'0');
	signal DP_O_RDY		: STD_LOGIC := '0';
	signal DP_O_DIVZ	: STD_LOGIC := '0';
	signal DP_O_C		: STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
	signal DP_O_D		: STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
	
	--------------------------------------------------------
	-- IP
	--------------------------------------------------------
	
	type MATRIX32x12 is array(31 downto 0) of STD_LOGIC_VECTOR (11 downto 0);

	--------------------------------------------------------
	--
	--------------------------------------------------------
	
	constant C_GND 	: STD_LOGIC	:= '0';
	
	signal L_RDY_PRL_A	: STD_LOGIC	:= '0';
	signal L_WR_PRL		: STD_LOGIC	:= '0';
	signal L_DATA		: STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
begin

	process(I_CLK, I_RST, ROM_O_DATA0, ROM_O_DATA1)
	
		--------
		-- CB --
		--------
	
		variable v_instruction : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
		variable v_instruction_prefix : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		variable v_instruction_suffix : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
		
		variable v_BRA_condition			: STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		variable v_BRA_condition_satisfied	: STD_LOGIC := '0';
		
		variable v_flg_32bit_instruction	: STD_LOGIC := '0';
		variable v_flg_data_tx_instruction	: STD_LOGIC := '0';
		
		variable v_flg_BRA	: STD_LOGIC := '0';
		variable v_flg_JMPL	: STD_LOGIC := '0';
		variable v_flg_CALL	: STD_LOGIC := '0';
		variable v_flg_RET	: STD_LOGIC := '0';
		variable v_flg_LI	: STD_LOGIC := '0';
		variable v_flg_ALOP	: STD_LOGIC := '0';
		variable v_flg_LD	: STD_LOGIC := '0';
		variable v_flg_UD	: STD_LOGIC := '0';
		variable v_flg_IN	: STD_LOGIC := '0';
		variable v_flg_OUT	: STD_LOGIC := '0';
		
		variable v_wait_addr_set : STD_LOGIC := '0';		
	
		variable IP_F : STD_LOGIC_VECTOR (2 downto 0);
	
		--------
		-- IP --
		--------
		variable STACK_body	: MATRIX32x12 := (others => (others => '0'));
		variable STACK_ptr 	: integer range 0 to 32 := 0;
		
		variable ROM_addr 		 : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
		variable ROM_addr_next_1 : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
		variable ROM_addr_next_2 : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');	
	begin
		if (I_RST='1') then
		
			IP_F := "000";
			v_wait_addr_set := '0';
		
			STACK_ptr := 0;
			ROM_addr  := (others => '0');
		elsif (I_CLK='1' and I_CLK'event) then
			
			L_RDY_PRL_A <= I_RDY_PRL;
			
			v_instruction := ROM_O_DATA0(15 downto 10);
			
			v_instruction_prefix := v_instruction(5 downto 3);
			v_instruction_suffix := v_instruction(2 downto 1);
			
			-- PARSE BRA CONDITION SATISFIED
			
			v_BRA_condition	:= v_instruction_suffix & v_instruction(0);
	
			if (   (v_BRA_condition="010" and DP_O_CZ(0)='1')	-- JE
				or (v_BRA_condition="011" and DP_O_CZ(0)='0')	-- JNE
				or (v_BRA_condition="100" and DP_O_CZ(1)='1')	-- JC, JB
				or (v_BRA_condition="101" and DP_O_CZ(1)='0')	-- JNC
				or (v_BRA_condition="110" and DP_O_CZ="00")		-- JA
				) then
				
				v_BRA_condition_satisfied := '1';
			else
				v_BRA_condition_satisfied := '0';
			end if;
			
			if (v_instruction_prefix="011") then	-- PORT OUT
				v_flg_data_tx_instruction := '1';
			else
				v_flg_data_tx_instruction := '0';
			end if;
			
			-- PARSE INSTRUCTION PREFIX
			
			if (v_instruction_prefix="000") then
				v_flg_BRA := '1';
			else
				v_flg_BRA := '0';
			end if;
			
			if (v_instruction_prefix="001") then
				v_flg_JMPL := '1';
			else
				v_flg_JMPL := '0';
			end if;
			
			if (v_instruction_prefix="010") then
				v_flg_CALL := '1';
			else
				v_flg_CALL := '0';
			end if;
			
			if (v_instruction_prefix="110") then
				v_flg_RET := '1';
			else
				v_flg_RET := '0';
			end if;
			
			if (v_instruction_prefix="101") then
				v_flg_LI := '1';
			else
				v_flg_LI := '0';
			end if;
			
			if (v_instruction_prefix="100") then
				v_flg_ALOP := '1';
			else
				v_flg_ALOP := '0';
			end if;		
			
			-- PARSE INSTRUCTION SUFFIX
			
			if (v_flg_data_tx_instruction='1'
					and  v_instruction_suffix="00") then
					
				v_flg_LD := '1';
			else
				v_flg_LD := '0';
			end if;
			
			if (v_flg_data_tx_instruction='1'
					and  v_instruction_suffix="01") then
					
				v_flg_UD := '1';
			else
				v_flg_UD := '0';
			end if;
			
			if (v_flg_data_tx_instruction='1'
					and  v_instruction_suffix="10") then
					
				v_flg_IN := '1';
			else
				v_flg_IN := '0';
			end if;
			
			if (v_flg_data_tx_instruction='1'
					and  v_instruction_suffix="11") then
					
				v_flg_OUT := '1';
			else
				v_flg_OUT := '0';
			end if;
				
			-- GET OPERATION LENGTH
				
			if (   v_flg_UD	  ='1'
				or v_flg_IN	  ='1'
				or v_flg_OUT  ='1'
				or v_flg_LI	  ='1'
				or v_flg_ALOP ='1') then
					
				v_flg_32bit_instruction := '1';
			else
				v_flg_32bit_instruction := '0';
			end if;			

			-- FORM OUTPUT
			
			CB_O_START_DP <= v_flg_ALOP;
			CB_O_RET 	  <= v_flg_RET;					
					
			if (v_flg_LI='1') then
				O_DP_DI_ADDR <= "01";
			elsif (v_flg_IN='1') then
				O_DP_DI_ADDR <= "10";
			else  -- LD
				O_DP_DI_ADDR <= "00";
			end if;			
			
			if (v_wait_addr_set='0') then
			
				IP_F := "000";
				
				CB_O_RDD_DP <= '0';
				CB_O_RD_PRL <= '0';
				
				
				CB_O_WRD_DP	<= '0';		
				
				CB_O_WR_RAM	<= v_flg_UD;
				L_WR_PRL <= v_flg_OUT and I_RDY_PRL;
				
				v_wait_addr_set := '1';
			else			
						
				v_wait_addr_set := '0';
				
				CB_O_RDD_DP	<= v_flg_UD or v_flg_OUT;
				CB_O_RD_PRL	<= v_flg_IN;
								
				CB_O_WRD_DP	<= v_flg_IN or v_flg_LD or v_flg_LI;				
				
				CB_O_WR_RAM <= '0';
				L_WR_PRL <= '0';
				
				if ((v_flg_ALOP='1' and DP_O_RDY='0')
					or ((v_flg_IN='1' or v_flg_OUT='1') and DP_O_RDY='0')
					or (v_flg_BRA='1' and v_BRA_condition="000")) then
					
					IP_F := "000"; -- do NOP
				elsif (v_flg_JMPL='1') then
				
					IP_F := "100"; -- do JMPL
					v_wait_addr_set := '1';
				elsif (v_flg_BRA='1' 
					and (v_BRA_condition="001" or v_BRA_condition_satisfied='1')) then
				
					IP_F := "101"; -- do JMP
					v_wait_addr_set := '1';
				elsif (v_flg_RET='1') then
				
					IP_F := "011"; -- do RET
					v_wait_addr_set := '1';
				elsif (v_flg_CALL='1') then
				
					IP_F := "010"; -- do CALL
					v_wait_addr_set := '1';
				elsif (v_flg_32bit_instruction='1') then
				
					IP_F := "110"; -- go +2					
				else				
					IP_F := "001"; -- go +1
				end if;			
			end if;	
			
			case IP_F is
				when "001" => ROM_addr := ROM_addr_next_1;
				when "110" => ROM_addr := ROM_addr_next_2;
				when "010" =>
					STACK_body(STACK_ptr) := DP_O_CZ & ROM_addr_next_1;
					ROM_addr  := ROM_O_DATA0(9 downto 0);
					STACK_ptr := STACK_ptr + 1;
				when "011" =>
					ROM_addr  := STACK_body(STACK_ptr - 1)(9 downto 0);
					DP_I_CZ   <= STACK_body(STACK_ptr - 1)(11 downto 10);
					STACK_ptr := STACK_ptr - 1;
				when "100" => ROM_addr := ROM_O_DATA0(9 downto 0);
				when "101" => ROM_addr := 
					conv_std_logic_vector(
						SIGNED(ROM_addr) + SIGNED(I_DATA(8 downto 0)), ROM_addr'length);
				when others => NULL;
			end case;
			
			ROM_addr_next_1 := conv_std_logic_vector(UNSIGNED(ROM_addr) + 1, ROM_addr_next_1'length);
			ROM_addr_next_2 := conv_std_logic_vector(UNSIGNED(ROM_addr) + 2, ROM_addr_next_2'length);
			
			ROM_I_ADDR <= ROM_addr;
		end if;
		
		DP_CLK <= I_CLK;
	end process;
	
	O_ROM_ADDR <= ROM_I_ADDR;
	O_ROM0 <= ROM_O_DATA0;
	O_ROM1 <= ROM_O_DATA1;

	O_WR_DP <= CB_O_WRD_DP;
	O_RD_DP <= CB_O_RDD_DP;

	ROM: ROM_1024x16_DUO
		port map( 
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_ADDR 	=> ROM_I_ADDR,
			O_DATA0	=> ROM_O_DATA0,
			O_DATA1	=> ROM_O_DATA1);			
	
	O_ADDR_PRL <= ROM_O_DATA1(9 downto 5);
	
	RAM: RAM_1024x16
		port map(
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_WR	=> CB_O_WR_RAM,
			I_ADDR	=> DP_O_C(9 downto 0),
			I_DATA	=> DP_O_D,
			O_DATA	=> RAM_O_DATA);			
	
	DP_MUX : MUX3x16
			port map(
				I_ADDR 	=> O_DP_DI_ADDR,
				I0		=> RAM_O_DATA,
				I1		=> ROM_O_DATA1,
				I2		=> I_DATA,
				O	 	=> DP_I_DATA);
	
	DP_instance: DP
		port map(
			I_CLK 	=> DP_CLK,
			I_RST 	=> I_RST,
			I_RDD 	=> CB_O_RDD_DP,
			I_WRD 	=> CB_O_WRD_DP,
			I_START => CB_O_START_DP,
			I_AB 	=> ROM_O_DATA0(9 downto 5),
			I_AC 	=> ROM_O_DATA0(4 downto 0),
			I_AD 	=> ROM_O_DATA1(4 downto 0),
			I_OPC 	=> ROM_O_DATA1(15 downto 11),
			I_DATA 	=> DP_I_DATA,
			I_CZ 	=> DP_I_CZ,
			I_RET 	=> CB_O_RET,
			O_RDY 	=> DP_O_RDY,
			O_DIVZ 	=> DP_O_DIVZ,
			O_CZ 	=> DP_O_CZ,
			O_C 	=> DP_O_C,
			O_D 	=> DP_O_D);
			
	process(L_WR_PRL)
	begin
		if (L_WR_PRL='1' and L_WR_PRL'event) then
			L_DATA <= DP_O_D;
		end if;
	end process;
	
	O_WR_PRL 	<= L_WR_PRL;
	O_RDY_PRL_A <= L_RDY_PRL_A;
	O_RD_PRL 	<= CB_O_RD_PRL;
	O_DATA	 	<= L_DATA;
end arch;

