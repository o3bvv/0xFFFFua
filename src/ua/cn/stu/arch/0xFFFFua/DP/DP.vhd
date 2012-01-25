----------------------------------------------------------------------------------
-- Data Path:
-- Arithmetical and Logical Unit + Registers
-- 
-- [Code] : [Operation]
-- 00000 : ADD
-- 00010 : NEG
-- 00011 : XOR
-- 00100 : AND
-- 00101 : TEST
-- 00111 : CPY
-- 01000 : SUB
-- 01001 : CMP
-- 01010 : MUL
-- 01011 : DIV
-- 01100 : OR
-- 10000 : RL
-- 10001 : ADDC
-- 10010 : [RESERVED: NEG]
-- 10100 : SL0
-- 10101 : SR0
-- 10110 : SLX
-- 10111 : SLC
-- 11000 : RR
-- 11001 : SUBC
-- 11010 : [RESERVED: MUL]
-- 11011 : [RESERVED: DIV]
-- 11100 : SL1
-- 11101 : SR1
-- 11110 : SRX
-- 11111 : SRC
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DP is
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
end DP;

architecture arch of DP is

	component ASLOU is
		port (
			I_F :	in  	STD_LOGIC_VECTOR (2 downto 0);
			I_A :	in  	STD_LOGIC_VECTOR (15 downto 0);
			I_B :	in  	STD_LOGIC_VECTOR (15 downto 0);
			I_C : 	in  	STD_LOGIC;
			O_Y : 	out  	STD_LOGIC_VECTOR (15 downto 0);
			O_C : 	out  	STD_LOGIC;
			O_Z : 	out  	STD_LOGIC);
	end component;

	signal ASLOU_f	: STD_LOGIC_VECTOR (2 downto 0)		:= (others => '0');
	signal ASLOU_y	: STD_LOGIC_VECTOR (15 downto 0) 	:= (others => '0');
	signal ASLOU_ci	: STD_LOGIC := '0';
	signal ASLOU_co	: STD_LOGIC := '0';
	signal ASLOU_z	: STD_LOGIC := '0';

	component MPU is
		port (
			I_CLK 	: in	STD_LOGIC;
			I_RST 	: in	STD_LOGIC;
			I_START : in	STD_LOGIC;
			I_HHR 	: in	STD_LOGIC;
			I_A 	: in	STD_LOGIC_VECTOR (15 downto 0);
			I_B 	: in	STD_LOGIC_VECTOR (15 downto 0);
			O_RDY 	: out	STD_LOGIC;
			O_Z 	: out	STD_LOGIC;
			O_HR 	: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal MPU_start: STD_LOGIC := '0';
	signal MPU_rdy	: STD_LOGIC := '0';
	signal MPU_z	: STD_LOGIC := '0';
	signal MPU_hr	: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

	component DVU is
		port (
			I_CLK 	: in	STD_LOGIC;
			I_RST 	: in 	STD_LOGIC;
			I_START : in	STD_LOGIC;
			I_QO	: in	STD_LOGIC;
			I_A 	: in	STD_LOGIC_VECTOR (15 downto 0);
			I_B 	: in	STD_LOGIC_VECTOR (15 downto 0);
			O_Y 	: out	STD_LOGIC_VECTOR (15 downto 0);
			O_Z 	: out	STD_LOGIC;
			O_HAI 	: out	STD_LOGIC;
			O_RDY 	: out	STD_LOGIC;
			O_DIVZ 	: out	STD_LOGIC);
	end component;
	
	signal DVU_start: STD_LOGIC := '0';
	signal DVU_z	: STD_LOGIC := '0';
	signal DVU_rdy	: STD_LOGIC := '0';
	signal DVU_y	: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	
	component Negativator is
		port (
			I_NUM : in	STD_LOGIC_VECTOR (15 downto 0);
			O_NUM : out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
		
	signal NEG_out	: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	
	component RF is
		port (
			I_CLK 		: in	STD_LOGIC;
			I_WR 		: in	STD_LOGIC;
			I_AB_INC	: in	STD_LOGIC;
			I_AC_INC	: in	STD_LOGIC;
			I_AB 		: in	STD_LOGIC_VECTOR (4 downto 0);
			I_AC 		: in	STD_LOGIC_VECTOR (4 downto 0);
			I_AD 		: in	STD_LOGIC_VECTOR (4 downto 0);
			I_B			: in	STD_LOGIC_VECTOR (15 downto 0);
			O_C			: out	STD_LOGIC_VECTOR (15 downto 0);
			O_D			: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal RF_wr 		: STD_LOGIC := '0';
	signal RF_ab_inc 	: STD_LOGIC := '0';
	signal RF_ac_inc 	: STD_LOGIC := '0';
	signal RF_b		 	: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal RF_c		 	: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal RF_d		 	: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	
	component FSG is
		port (
			I_CLK	: IN	STD_LOGIC;
			I_RST	: IN	STD_LOGIC;
			I_C 	: IN	STD_LOGIC;
			I_Z 	: IN	STD_LOGIC;
			O_C 	: OUT	STD_LOGIC;
			O_Z 	: OUT	STD_LOGIC);
	end component;
	
	signal FSG_ci 	: STD_LOGIC := '0';
	signal FSG_co 	: STD_LOGIC := '0';
	signal FSG_zi 	: STD_LOGIC := '0';
	signal FSG_zo 	: STD_LOGIC := '0';
	
	type LOP_STATES is (FREE, BUSY, DONE, FINISHED);
		
	signal L_mpu_state	: LOP_STATES := FREE;
	signal L_dvu_state	: LOP_STATES := FREE;
	
	signal L_flg_RL 	: STD_LOGIC := '0';
	signal L_flg_RR 	: STD_LOGIC := '0';
	
	signal L_flg_CPY 	: STD_LOGIC := '0';
	
	signal L_flg_MPU 	: STD_LOGIC := '0';
	signal L_flg_DVU 	: STD_LOGIC := '0';
	
	signal L_flg_SLN 	: STD_LOGIC := '0';
	signal L_flg_SLX 	: STD_LOGIC := '0';
	signal L_flg_SLC 	: STD_LOGIC := '0';
	signal L_flg_SRN 	: STD_LOGIC := '0';
	signal L_flg_SRX 	: STD_LOGIC := '0';
	signal L_flg_SRC 	: STD_LOGIC := '0';
	
begin

	RF_isntance: RF
		port map(
			I_CLK 		=> I_CLK,
			I_WR 		=> RF_wr,
			I_AB_INC	=> RF_ab_inc,
			I_AC_INC	=> RF_ac_inc,
			I_AB 		=> I_AB,
			I_AC 		=> I_AC,
			I_AD 		=> I_AD,
			I_B			=> RF_b,
			O_C			=> RF_c,
			O_D			=> RF_d);

	MUX_B: 
		RF_b <= 
			RF_d								-- read from D
			when I_RDD='1' else
			
			RF_c								-- copy from C
			when L_flg_CPY='1' else				
			
			I_DATA								-- write to B
			when I_WRD='1' else
			
			NEG_out								-- result from Negativator
			when I_OPC(3 downto 0)="0010" else
			
			MPU_hr								-- result from MPU
			when L_flg_MPU='1' else
			
			DVU_y								-- result from DVU
			when L_flg_DVU='1' else
			
			RF_d(14 downto 0) & RF_d(15)		-- RL
			when L_flg_RL='1' else
			
			RF_d(0) & RF_d(15 downto 1)			-- RR
			when L_flg_RR='1' else
			
			RF_d(14 downto 0) & I_OPC(3)		-- SL0, SL1
			when L_flg_SLN='1' else
			
			I_OPC(3) & RF_d(15 downto 1)		-- SR0, SR1
			when L_flg_SRN='1' else
			
			RF_d(14 downto 0) & RF_d(0)			-- SLX
			when L_flg_SLX='1' else
			
			RF_d(15) & RF_d(15 downto 1)		-- SRX
			when L_flg_SRX='1' else
			
			RF_d(14 downto 0) & FSG_co			-- SLC
			when L_flg_SLC='1' else
			
			FSG_co & RF_d(15 downto 1)			-- SRC
			when L_flg_SRC='1' else
			
			ASLOU_y;							-- result from ASLOU

	WR_MUX:
		RF_wr <= '1'
			when I_WRD ='1' 
				 or L_flg_CPY='1'
				 or L_mpu_state=DONE
				 or L_dvu_state=DONE
				 or (L_mpu_state=BUSY and MPU_rdy='1')
				 or (L_dvu_state=BUSY and DVU_rdy='1')
				 or (I_START='1'
					 and L_flg_MPU='0'
					 and L_flg_DVU='0'
					 and I_OPC/="00101" -- TEST
					 and I_OPC/="01001")-- CMP
			else '0';

	RF_ab_inc <= '1'
				when L_mpu_state=DONE
					 or L_dvu_state=DONE
				else '0';

	ASLOU_isntance: ASLOU
		port map(
			I_F => ASLOU_f,
			I_A => RF_c,
			I_B => RF_d,
			I_C => ASLOU_ci,
			O_Y => ASLOU_y,
			O_C => ASLOU_co,
			O_Z => ASLOU_z);
			
	ASLOU_f		<= I_OPC(1) & I_OPC(2) & I_OPC(3);
	ASLOU_ci	<= FSG_co when I_OPC(4)='1' else '0';
			
	MPU_isntance: MPU
		port map(
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_START => MPU_start,
			I_HHR 	=> RF_ab_inc,
			I_A 	=> RF_c,
			I_B 	=> RF_d,
			O_RDY 	=> MPU_rdy,
			O_Z 	=> MPU_z,
			O_HR 	=> MPU_hr);
			
	DVU_isntance: DVU
		port map(
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_START => DVU_start,
			I_QO	=> not RF_ab_inc,
			I_A 	=> RF_c,
			I_B 	=> RF_d,
			O_Y 	=> DVU_y,
			O_Z 	=> DVU_z,
			O_HAI 	=> RF_ac_inc,
			O_RDY 	=> DVU_rdy,
			O_DIVZ 	=> O_DIVZ);
	
	NEG_isntance: Negativator
		port map(
			I_NUM => RF_d,
			O_NUM => NEG_out);
		
	FSG_isntance: FSG
		port map(
			I_CLK	=> I_CLK,
			I_RST	=> I_RST,
			I_C 	=> FSG_ci,
			I_Z 	=> FSG_zi,
			O_C 	=> FSG_co,
			O_Z 	=> FSG_zo);
	
	MUX_CARRY_OUT:
		FSG_ci <=
			I_CZ(1)
			when I_RET='1' else
			
			RF_d(15)
			when L_flg_RL='1' 
				 or L_flg_SLN='1'
				 or L_flg_SLX='1'
				 or L_flg_SLC='1' else
			
			RF_d(0)
			when L_flg_RR='1'
				 or L_flg_SRN='1'
				 or L_flg_SRX='1'
				 or L_flg_SRC='1' else
			
			ASLOU_co;
	
	MUX_ZERO:
		FSG_zi <=
			I_CZ(0)
			when I_RET='1' else
		
			MPU_z
			when L_flg_mpu='1' else
			
			DVU_z
			when L_flg_dvu='1' else
			
			ASLOU_z;
	
	STATES: process(I_CLK, I_RST)
	begin
		if (I_RST='1') then
			L_mpu_state <= FREE;
			L_dvu_state <= FREE;
		elsif(I_CLK='1' and I_CLK'event) then

			case L_mpu_state is
				when FREE => 
					if I_START='1' and L_flg_mpu='1' then
						L_mpu_state <= BUSY;
					end if;
				when BUSY => 
					if MPU_rdy='1' then
						L_mpu_state <= DONE;
					end if;
				when DONE => 
						L_mpu_state <= FINISHED;
				when FINISHED => 
						L_mpu_state <= FREE;
			end case;
			
			case L_dvu_state is
				when FREE => 
					if I_START='1' and L_flg_dvu='1' then
						L_dvu_state <= BUSY;
					end if;
				when BUSY => 
					if DVU_rdy='1' then
						L_dvu_state <= DONE;
					end if;
				when DONE => 
						L_dvu_state <= FINISHED;
				when FINISHED => 
						L_dvu_state <= FREE;
			end case;
		end if;
	end process;
	
	L_flg_CPY	<= '1' when I_OPC="00111" else '0';
	
	L_flg_MPU	<= '1' when I_OPC(3 downto 0)="1010" else '0';
	L_flg_DVU	<= '1' when I_OPC(3 downto 0)="1011" else '0';
	
	MPU_start 	<= '1' when L_flg_MPU='1' and I_START='1' and L_mpu_state=FREE else '0';
	DVU_start 	<= '1' when L_flg_DVU='1' and I_START='1' and L_dvu_state=FREE else '0';
	
	L_flg_RL	<= '1' when I_OPC="10000" else '0';
	L_flg_RR	<= '1' when I_OPC="11000" else '0';
	
	L_flg_SLN	<= '1' when I_OPC(4)='1' and I_OPC(2 downto 0)="100" else '0';
	L_flg_SRN	<= '1' when I_OPC(4)='1' and I_OPC(2 downto 0)="101" else '0';
	
	L_flg_SLX	<= '1' when I_OPC="10110" else '0';
	L_flg_SRX	<= '1' when I_OPC="11110" else '0';
	
	L_flg_SLC	<= '1' when I_OPC="10111" else '0';
	L_flg_SRC	<= '1' when I_OPC="11111" else '0';
	
	O_C  <= RF_c;
	O_D  <= RF_b; 	-- yes, it's 'b'
	O_CZ <= FSG_co & FSG_zo;	
	
	O_RDY<= '1'
			when L_mpu_state=FINISHED
				 or L_dvu_state=FINISHED
				 or (I_WRD='0'
					and L_flg_MPU='0'
					and L_flg_DVU='0')
			else '0';
end arch;
