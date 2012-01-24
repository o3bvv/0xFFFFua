----------------------------------------------------------------------------------
-- Multiply unit
-- Operates with signed numbers
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MPU is
	port (
		I_CLK 	: in	STD_LOGIC;						-- clock
		I_RST 	: in	STD_LOGIC;						-- reset
		I_START : in	STD_LOGIC;						-- start at rising edge
		I_HHR 	: in	STD_LOGIC;						-- output high half of result
		I_A 	: in	STD_LOGIC_VECTOR (15 downto 0);	-- operand A
		I_B 	: in	STD_LOGIC_VECTOR (15 downto 0);	-- operand B
		O_RDY 	: out	STD_LOGIC;						-- ready flag
		O_Z 	: out	STD_LOGIC;						-- zero result flag
		O_HR 	: out	STD_LOGIC_VECTOR (15 downto 0));-- half of result
end MPU;

architecture Behavioral of MPU is
	type STATES is (
		LOAD,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15, DONE, IDLE);
		
	signal L_state	: STATES := IDLE;

	signal L_A, L_B	: STD_LOGIC_VECTOR(15 downto 0);
	signal L_SM		: STD_LOGIC_VECTOR(16 downto 0);
	signal L_R		: STD_LOGIC_VECTOR(31 downto 0);

	signal L_work	: STD_LOGIC;
begin

	STATE: process(I_CLK, I_RST)
	
	begin
		if (I_RST='1') then
			L_state <= IDLE;
			L_A		<= X"0000";
			L_B		<= X"0000";
			L_R		<= X"00000000";
		elsif (I_CLK='1' and I_CLK'event) then			
		
			case L_state is
									
				when A0		=> L_state <= A1;
				when A1		=> L_state <= A2;
				when A2		=> L_state <= A3;
				when A3		=> L_state <= A4;
				when A4		=> L_state <= A5;
				when A5		=> L_state <= A6;
				when A6		=> L_state <= A7;
				when A7		=> L_state <= A8;
				when A8		=> L_state <= A9;
				when A9		=> L_state <= A10;
				when A10	=> L_state <= A11;
				when A11	=> L_state <= A12;
				when A12	=> L_state <= A13;
				when A13	=> L_state <= A14;
				when A14	=> L_state <= A15;
				when A15	=> 
								L_state <= DONE;
								L_work	<= '0';
				
				when DONE	=>
					L_state <= IDLE;
				
				when LOAD	=> 
					L_A		<= I_A;
					L_B		<= I_B;
					L_R		<= X"00000000";
					L_work	<= '1';
					L_state <= A0;
				
				when IDLE	=>
					if (I_START='1') then
						L_state <= LOAD;
					end if;
			end case;
			
			if (L_work='1') then
				L_B <= '0' 	& L_B(15 downto 1);
				L_R <= L_SM & L_R(15 downto 1);
			end if;
		end if;
	end process;

	SUM: L_SM <=
		STD_LOGIC_VECTOR(SIGNED(L_R(31)& L_R(31 downto 16)) - SIGNED(L_A))
		when L_B(0)='1' and L_state=A15 else
		STD_LOGIC_VECTOR(SIGNED(L_R(31)& L_R(31 downto 16)) + SIGNED(L_A))
		when L_B(0)='1' else
		L_R(31)& L_R(31 downto 16);

	OUT_MUX:O_HR <= 
		L_R(15 downto 0) 
		when I_HHR='0' else
		L_R(31 downto 16);

	O_RDY 	<='1' when L_state=DONE 	else '0';
	O_Z 	<='1' when L_R=X"00000000"	else '0';
	
end Behavioral;

