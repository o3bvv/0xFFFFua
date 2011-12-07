----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CB is
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
		O_RDY_PRL_A	: out	STD_LOGIC;
		O_WR_RAM	: out	STD_LOGIC;
		O_RD_DP		: out	STD_LOGIC;
		O_RD_PRL	: out	STD_LOGIC;
		O_RET		: out	STD_LOGIC);
end CB;

architecture Behavioral of CB is
	
	signal L_flg_BRA	: STD_LOGIC;
	signal L_flg_JMPL	: STD_LOGIC;
	signal L_flg_CALL	: STD_LOGIC;
	signal L_flg_RET	: STD_LOGIC;
	signal L_flg_LI		: STD_LOGIC;
	signal L_flg_ALOP	: STD_LOGIC;
	signal L_flg_LD		: STD_LOGIC;
	signal L_flg_UD		: STD_LOGIC;
	signal L_flg_IN		: STD_LOGIC;
	signal L_flg_OUT	: STD_LOGIC;	
	
	signal L_flg_32bit_instruction	: STD_LOGIC;
	signal L_flg_data_tx_instruction: STD_LOGIC;
	
	signal L_BRA_condition			: STD_LOGIC_VECTOR (2 downto 0);
	signal L_BRA_condition_satisfied: STD_LOGIC;
	
	signal L_instruction_prefix		: STD_LOGIC_VECTOR (2 downto 0);
	signal L_instruction_suffix		: STD_LOGIC_VECTOR (1 downto 0);
begin
	
	process(I_CLK)
	begin
		if (I_CLK='1' and I_CLK'event) then
			O_RDY_PRL_A <= I_RDY_PRL;
		end if;
	end process;
	
	L_instruction_prefix <= I_INSTR(5 downto 3);
	L_instruction_suffix <= I_INSTR(2 downto 1);
	
	L_BRA_condition	<= L_instruction_suffix & I_INSTR(0);
	
	L_BRA_condition_satisfied <= '1' when (L_BRA_condition="010" and I_CZ(0)='1')	-- JE
										or (L_BRA_condition="011" and I_CZ(0)='0')	-- JNE
										or (L_BRA_condition="100" and I_CZ(1)='1')	-- JC, JB
										or (L_BRA_condition="101" and I_CZ(1)='0')	-- JNC
										or (L_BRA_condition="110" and I_CZ="00")	-- JA
									else '0';
	
	L_flg_data_tx_instruction <= '1' when L_instruction_prefix="011" else '0';
	
	L_flg_BRA	<= '1' when L_instruction_prefix="000" else '0';
	L_flg_JMPL	<= '1' when L_instruction_prefix="001" else '0';
	L_flg_CALL	<= '1' when L_instruction_prefix="010" else '0';
	L_flg_RET	<= '1' when L_instruction_prefix="110" else '0';
	L_flg_LI	<= '1' when L_instruction_prefix="101" else '0';
	L_flg_ALOP	<= '1' when L_instruction_prefix="100" else '0';
	
	L_flg_LD	<= '1'	when L_flg_data_tx_instruction='1'
							and  L_instruction_suffix="00" else '0';
	L_flg_UD	<= '1'	when L_flg_data_tx_instruction='1'
							and  L_instruction_suffix="01" else '0';
	L_flg_IN	<= '1'	when L_flg_data_tx_instruction='1'
							and  L_instruction_suffix="10" else '0';
	L_flg_OUT	<= '1'	when L_flg_data_tx_instruction='1'
							and  L_instruction_suffix="11" else '0';
							
	L_flg_32bit_instruction <= '1'	when L_flg_UD='1'
										or L_flg_IN='1'
										or L_flg_OUT='1'
										or L_flg_LI='1'
										or L_flg_ALOP='1' else '0';
	
	O_START_DP <= L_flg_ALOP;
	
	O_RET 		<= L_flg_RET;
	
	O_RD_DP		<= L_flg_UD or L_flg_OUT;
	O_RD_PRL	<= L_flg_IN;
	
	O_WR_RAM	<= L_flg_UD;
	O_WR_DP		<= L_flg_IN or L_flg_LD or L_flg_LI;
	O_WR_PRL 	<= L_flg_OUT and I_RDY_PRL;
			
	O_DP_DI_ADDR <= "01" when L_flg_LI='1' else
					"10" when L_flg_IN='1' else "00"; -- LD
	
	O_F_IP	<= 	"000" when (L_flg_ALOP='1'
						and I_RDY_DP='0')
					  or ((L_flg_IN='1' or L_flg_OUT='1')
						and I_RDY_PRL='0')	else					-- do NOP
				"100" when L_flg_JMPL='1'	else					-- JMPL
				"101" when L_flg_BRA='1'
						and (L_BRA_condition="001"
							or L_BRA_condition_satisfied='1') else	-- JMP
				"011" when L_flg_RET='1'	else					-- RET
				"010" when L_flg_CALL='1'	else					-- CALL
				"110" when L_flg_32bit_instruction='1' else			-- +2
				"001" when L_flg_32bit_instruction='0';				-- +1
end Behavioral;

