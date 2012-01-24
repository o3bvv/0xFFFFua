----------------------------------------------------------------------------------
-- Division Unit
-- Operates with signed numbers
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity DVU is
	port (
		I_CLK 	: in	STD_LOGIC;						-- CLOCK
		I_RST 	: in 	STD_LOGIC;						-- RESET
		I_START : in	STD_LOGIC;						-- START at rising edge
		I_QO	: in	STD_LOGIC;						-- '1' : output QUOTIENT
														-- '0' : output REMAINDER
		I_A 	: in	STD_LOGIC_VECTOR (15 downto 0); -- Operand A (DIVIDENT)
		I_B 	: in	STD_LOGIC_VECTOR (15 downto 0); -- Operand B (DIVIDER)
		O_Y 	: out	STD_LOGIC_VECTOR (15 downto 0); -- Result 
														-- (QUOTIENT or REMAINDER)
		O_Z 	: out	STD_LOGIC;						-- ZERO result
		O_HAI 	: out	STD_LOGIC;						-- '1' Hight part of A input
														-- '0' Low part of A input
		O_RDY 	: out	STD_LOGIC;						-- READY flag
		O_DIVZ 	: out	STD_LOGIC);						-- Division by ZERO flag
end DVU;

architecture Behavioral of DVU is
	
	type STATES is (
		LOAD_0, LOAD_1, DIV, SIGN, DONE, IDLE);
		
	signal L_state		: STATES := IDLE;
	signal L_signFinal	: STD_LOGIC := '0';
	signal L_signA		: STD_LOGIC := '0';
	signal L_signB		: STD_LOGIC := '0';
	signal L_divz		: STD_LOGIC := '0';

begin
	
	process(I_CLK, I_RST, I_QO)
		variable v_D	: STD_LOGIC_VECTOR (30 downto 0) := (others => '0');
		variable v_R 	: STD_LOGIC_VECTOR (30 downto 0) := (others => '0');
		variable v_Q	: STD_LOGIC_VECTOR (14 downto 0) := (others => '0');
		
		constant oper_cnt	: integer := 16;
		variable div_cycle	: integer range 0 to oper_cnt := 0;
	begin
		if (I_RST='1') then
			L_state <= IDLE;
			v_Q := (others => '0');
			v_R := (others => '0');
			v_D := (others => '0');
		elsif (I_CLK='1' and I_CLK'event) then
		
			case L_state is
				
				when LOAD_0	=>
				
					if (I_B=X"0000") then
						L_divz 	<= '1';
						L_state <= DONE;
					else
						v_D(30 downto 16) := I_B(14 downto 0);
						v_R(30 downto 16) := I_A(14 downto 0);
						
						L_signA 	<= I_A(15);
						L_signB 	<= I_B(15);
						
						L_signFinal	<= I_A(15) xor I_B(15);
						L_state 	<= LOAD_1;	
					end if;
					
				when LOAD_1 =>
						
					v_R(15 downto 0) := I_A;
					v_D(15 downto 0) := X"0000";
						
					if (L_signA='1') then
						v_R := not v_R;
						v_R := conv_std_logic_vector(
									(UNSIGNED(v_R) + 1), 31);
					end if;
					
					if (L_signB='1') then
						v_D := not v_D;
						v_D	:= conv_std_logic_vector(
									(UNSIGNED(v_D) + 1), 31);
					end if;
						
					v_Q 		:= (others => '0');	
					div_cycle 	:= 0;					
					L_state 	<= DIV;
						
				when DIV	=>
					
					v_R	:= conv_std_logic_vector(
								(SIGNED('0'& v_R) - SIGNED('0'& v_D)), 31);					
					v_Q := v_Q(13 downto 0) & not v_R(30);

					if (v_R(30)='1') then
						v_R	:= conv_std_logic_vector(
								(UNSIGNED(v_R) + UNSIGNED(v_D)), 31);
					end if;
					
					v_D := '0' & v_D(30 downto 1);
					
					if (div_cycle=oper_cnt) then
						L_state 	<= SIGN;
					else
						div_cycle 	:= div_cycle+1;
					end if;
				
				when SIGN	=> 
					if (L_signFinal='1') then
						v_Q := not v_Q;
						v_Q := conv_std_logic_vector(
									UNSIGNED(v_Q)+1,15);
					end if;
					L_state <= DONE;
				
				when DONE	=>				
					L_state <= IDLE;
					
				when IDLE	=>
					if (I_START='1') then
						L_divz 	<= '0';
						L_state <= LOAD_0;
					end if;
			end case;
		end if;
		
		if (I_QO='1') then
			O_Y <= L_signFinal & v_Q;
		else
			O_Y <= '0'& v_R(14 downto 0);
		end if;
		
		if (L_signFinal & v_Q=X"0000") then
			O_Z	<= '1';
		else 
			O_Z <= '0';
		end if;
		
	end process;

	O_HAI 	<= '1' when L_state=LOAD_0 	else '0';
	O_RDY 	<= '1' when L_state=DONE 	else '0';
	O_DIVZ	<= L_divz;
end Behavioral;

