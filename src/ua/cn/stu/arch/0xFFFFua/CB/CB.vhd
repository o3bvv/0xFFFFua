----------------------------------------------------------------------------------
-- Control Block
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CB is
	port (
		I_CLK 		: in	STD_LOGIC;
		I_RST 		: in	STD_LOGIC;
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
begin
	
	process(I_CLK, I_RST)
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
	begin
		if (I_RST='1') then
			v_wait_addr_set := '0';
		elsif (I_CLK='1' and I_CLK'event) then			
					
			O_RDY_PRL_A <= I_RDY_PRL;
			
			v_instruction_prefix := I_INSTR(5 downto 3);
			v_instruction_suffix := I_INSTR(2 downto 1);
			
			-- PARSE BRA CONDITION SATISFIED
			
			v_BRA_condition	:= v_instruction_suffix & I_INSTR(0);
	
			if (   (v_BRA_condition="010" and I_CZ(0)='1')	-- JE
				or (v_BRA_condition="011" and I_CZ(0)='0')	-- JNE
				or (v_BRA_condition="100" and I_CZ(1)='1')	-- JC, JB
				or (v_BRA_condition="101" and I_CZ(1)='0')	-- JNC
				or (v_BRA_condition="110" and I_CZ="00")	-- JA
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
			
			O_START_DP 	<= v_flg_ALOP;
	
			O_RET 		<= v_flg_RET;			
			
			O_RD_DP		<= v_flg_UD or v_flg_OUT;
			O_RD_PRL	<= v_flg_IN;
			
			O_WR_RAM	<= v_flg_UD;
			O_WR_DP		<= v_flg_IN or v_flg_LD or v_flg_LI;
			O_WR_PRL 	<= v_flg_OUT and I_RDY_PRL;
					
			if (v_flg_LI='1') then
				O_DP_DI_ADDR <= "01";
			elsif (v_flg_IN='1') then
				O_DP_DI_ADDR <= "10";
			else  -- LD
				O_DP_DI_ADDR <= "00";
			end if;

			if (v_wait_addr_set='0') then
			
				O_F_IP <= "000";
				v_wait_addr_set := '1';
			else
				
				v_wait_addr_set := '0';
				
				if ((v_flg_ALOP='1' and I_RDY_DP='0')
					or ((v_flg_IN='1' or v_flg_OUT='1') and I_RDY_PRL='0')
					or (v_flg_BRA='1' and v_BRA_condition="000")) then
					
					O_F_IP	<= 	"000"; -- do NOP
				elsif (v_flg_JMPL='1') then
				
					O_F_IP	<= 	"100"; -- do JMPL
				elsif (v_flg_BRA='1' 
					and (v_BRA_condition="001" or v_BRA_condition_satisfied='1')) then
				
					O_F_IP	<= 	"101"; -- do JMP
				elsif (v_flg_RET='1') then
				
					O_F_IP	<= 	"011"; -- do RET
				elsif (v_flg_CALL='1') then
				
					O_F_IP	<= 	"010"; -- do CALL
				elsif (v_flg_32bit_instruction='1') then
				
					O_F_IP	<= 	"110"; -- go +2
					
				else
				
					O_F_IP	<= 	"001"; -- go +1
				end if;			
			end if;
		end if;
	end process;

end Behavioral;

