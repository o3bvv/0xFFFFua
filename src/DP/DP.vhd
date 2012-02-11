--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;	

entity DP is
	port (
		I_CLK 	: in  STD_LOGIC;
		I_RST 	: in  STD_LOGIC;
		I_RDD 	: in  STD_LOGIC;
		I_WRD 	: in  STD_LOGIC;
		I_START : in  STD_LOGIC;
		I_OPC 	: in  STD_LOGIC_VECTOR (4 downto 0);
		I_AB 	: in  STD_LOGIC_VECTOR (4 downto 0);
		I_AC 	: in  STD_LOGIC_VECTOR (4 downto 0);
		I_AD 	: in  STD_LOGIC_VECTOR (4 downto 0);
		I_DATA 	: in  STD_LOGIC_VECTOR (15 downto 0);
		I_CZ 	: in  STD_LOGIC_VECTOR (1 downto 0);
		I_RET 	: in  STD_LOGIC;
		O_RDY 	: out STD_LOGIC := '1';
		O_DIVZ 	: out STD_LOGIC := '0';
		O_CZ 	: out STD_LOGIC_VECTOR (1 downto 0)  := (others=>'0');
		O_C 	: out STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
		O_D 	: out STD_LOGIC_VECTOR (15 downto 0) := (others=>'0'));
end DP;

architecture arch of DP is
	
	type MATRIX32x16 is array(31 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
	type LOP_STATES is (FREE, BUSY, DONE, FINISHED);	
		
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

	signal ASLOU_f	: STD_LOGIC_VECTOR (2 downto 0)	 := (others => '0');
	signal ASLOU_y	: STD_LOGIC_VECTOR (15 downto 0);
	signal ASLOU_ci	: STD_LOGIC := '0';
	signal ASLOU_co	: STD_LOGIC;
	signal ASLOU_z	: STD_LOGIC;	
	
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
	
	signal MPU_start: STD_LOGIC;
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
	
	signal DVU_start: STD_LOGIC;
	signal DVU_z	: STD_LOGIC := '0';
	signal DVU_rdy	: STD_LOGIC := '0';
	signal DVU_y	: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	
	signal
		RF_AB_INC,
		RF_AC_INC : STD_LOGIC := '0';
	
	signal
		L_FLG_Z,
		L_FLG_C : STD_LOGIC := '0';
	
	signal
		L_D,
		L_C : STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
begin

	ASLOU_isntance: ASLOU
		port map(
			I_F => ASLOU_f,
			I_A => L_C,
			I_B => L_D,
			I_C => ASLOU_ci,
			O_Y => ASLOU_y,
			O_C => ASLOU_co,
			O_Z => ASLOU_z);
			
	ASLOU_f	 <= I_OPC(1) & I_OPC(2) & I_OPC(3);
	ASLOU_ci <= L_FLG_C when I_OPC(4)='1' else '0';
	
	MPU_isntance: MPU
		port map(
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_START => MPU_start,
			I_HHR 	=> RF_AB_INC,
			I_A 	=> L_C,
			I_B 	=> L_D,
			O_RDY 	=> MPU_rdy,
			O_Z 	=> MPU_z,
			O_HR 	=> MPU_hr);
			
	DVU_isntance: DVU
		port map(
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_START => DVU_start,
			I_QO	=> not RF_AB_INC,
			I_A 	=> L_C,
			I_B 	=> L_D,
			O_Y 	=> DVU_y,
			O_Z 	=> DVU_z,
			O_HAI 	=> RF_AC_INC,
			O_RDY 	=> DVU_rdy,
			O_DIVZ 	=> O_DIVZ);

	process(I_RST, I_CLK, RF_AB_INC, RF_AC_INC, I_START)
		
		variable
			FLG_Z,
			FLG_C : STD_LOGIC := '0';
		
		variable v_mpu_state : LOP_STATES := FREE;
		variable v_dvu_state : LOP_STATES := FREE;
		
		variable v_flg_RL : STD_LOGIC := '0';
		variable v_flg_RR : STD_LOGIC := '0';
		
		variable v_flg_CPY : STD_LOGIC := '0';
		variable v_flg_NEG : STD_LOGIC := '0';
		
		variable v_flg_MPU : STD_LOGIC := '0';
		variable v_flg_DVU : STD_LOGIC := '0';
		
		variable v_flg_SLN : STD_LOGIC := '0';
		variable v_flg_SLX : STD_LOGIC := '0';
		variable v_flg_SLC : STD_LOGIC := '0';
		variable v_flg_SRN : STD_LOGIC := '0';
		variable v_flg_SRX : STD_LOGIC := '0';
		variable v_flg_SRC : STD_LOGIC := '0';
		
		variable RF_body : MATRIX32x16 := (others=> (others=>'0'));
		variable RF_b	 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
		
		variable
			v_AB, v_AC, v_AD : natural range 0 to 31 := 0;			
	begin
	
		-- Set channels' addresses
		v_AD := TO_INTEGER(UNSIGNED(I_AD));
			
		if (RF_AB_INC = '1'
			or v_mpu_state = DONE
			or v_dvu_state = DONE) then
				
			v_AB := TO_INTEGER(UNSIGNED(I_AB)+1);
		else
			v_AB := TO_INTEGER(UNSIGNED(I_AB));
		end if;
			
		if (RF_AC_INC = '1') then
			v_AC := TO_INTEGER(UNSIGNED(I_AC)+1);
		else
			v_AC := TO_INTEGER(UNSIGNED(I_AC));
		end if;
		
	
		if (I_RST='1') then
			
			v_AB := 0;
			v_AC := 0;
			v_AD := 0;
		
			v_mpu_state := FREE;
			v_dvu_state := FREE;
		elsif (I_CLK='1' and I_CLK'event) then

			-- decode operation
			
			if (I_OPC="00111") then
				v_flg_CPY := '1';
			else
				v_flg_CPY := '0';
			end if;
			
			if (I_OPC(3 downto 0)="0010") then
				v_flg_NEG := '1';
			else
				v_flg_NEG := '0';
			end if;
			
			if (I_OPC(3 downto 0)="1010") then
				v_flg_MPU := '1';
			else
				v_flg_MPU := '0';
			end if;
			
			if (I_OPC(3 downto 0)="1011") then
				v_flg_DVU := '1';
			else
				v_flg_DVU := '0';
			end if;						
			
			if (I_OPC="10000") then
				v_flg_RL := '1';
			else
				v_flg_RL := '0';
			end if;
			
			if (I_OPC="11000") then
				v_flg_RR := '1';
			else
				v_flg_RR := '0';
			end if;
			
			if (I_OPC(4)='1' and I_OPC(2 downto 0)="100") then
				v_flg_SLN := '1';
			else
				v_flg_SLN := '0';
			end if;
			
			if (I_OPC(4)='1' and I_OPC(2 downto 0)="101") then
				v_flg_SRN := '1';
			else
				v_flg_SRN := '0';
			end if;
			
			if (I_OPC="10110") then
				v_flg_SLX := '1';
			else
				v_flg_SLX := '0';
			end if;
			
			if (I_OPC="11110") then
				v_flg_SRX := '1';
			else
				v_flg_SRX := '0';
			end if;
			
			if (I_OPC="10111") then
				v_flg_SLC := '1';
			else
				v_flg_SLC := '0';
			end if;
			
			if (I_OPC="11111") then
				v_flg_SRC := '1';
			else
				v_flg_SRC := '0';
			end if;
			
			-- Set DIV and MUL states
			
			case v_mpu_state is
				when FREE => 
					if (I_START='1' and v_flg_mpu='1') then
						v_mpu_state := BUSY;
						MPU_start <= '1';
					end if;
				when BUSY => 
					if MPU_rdy='1' then
						MPU_start <= '0';
						v_mpu_state := DONE;
					end if;
				when DONE => 
						v_mpu_state := FINISHED;
				when FINISHED => 
						v_mpu_state := FREE;
				when others => null;
			end case;
			
			case v_dvu_state is
				when FREE => 
					if (I_START='1' and v_flg_dvu='1') then
						v_dvu_state := BUSY;
						DVU_start <= '1';
					end if;
				when BUSY => 
					if DVU_rdy='1' then
						DVU_start <= '0';
						v_dvu_state := DONE;
					end if;
				when DONE => 
						v_dvu_state := FINISHED;
				when FINISHED => 
						v_dvu_state := FREE;
				when others => null;
			end case;
			
			if (   v_mpu_state=DONE
				or v_dvu_state=DONE) then
				RF_ab_inc <= '1';
			else
				RF_ab_inc <= '0';
			end if;
			
			-- MUX CARRY
			
			if (I_RET='1') then
				FLG_C := I_CZ(1);
			elsif (   v_flg_RL='1' 
				or v_flg_SLN='1'
				or v_flg_SLX='1'
				or v_flg_SLC='1') then
				 
				FLG_C := RF_body(v_AD)(15);
			elsif (  v_flg_RR='1'
				  or v_flg_SRN='1'
				  or v_flg_SRX='1'
				  or v_flg_SRC='1') then
				FLG_C := RF_body(v_AD)(0);
			elsif (I_START='1')	 then
				FLG_C := ASLOU_co;
			end if;
			
			-- MUX ZERO
			
			if (I_RET='1') then
				FLG_Z := I_CZ(0);
			elsif (v_flg_mpu='1') then				 
				FLG_Z := MPU_z;
			elsif (v_flg_dvu='1') then
				FLG_Z := DVU_z;
			elsif (I_START='1')	 then
				FLG_Z := ASLOU_z;
			end if;
			
			-- MUX RF:B
			
			if (v_flg_CPY='1') then
				
				-- copy from C
				RF_b := RF_body(v_AC);
			elsif (I_WRD='1') then
				
				-- write to B
				RF_b := I_DATA;
			elsif (v_flg_NEG='1') then
				
				-- result from Negativator
				RF_b := STD_LOGIC_VECTOR(UNSIGNED(not RF_body(v_AD)) + 1);
			elsif (v_flg_MPU='1'
				and (v_mpu_state = DONE
					or (v_mpu_state = BUSY
						and MPU_rdy = '1'))) then
				
				-- result from MPU
				RF_b := MPU_hr;
			elsif (v_flg_DVU='1'
				and (v_dvu_state = DONE
					or (v_dvu_state = BUSY
						and DVU_rdy = '1'))) then
				
				-- result from DVU
				RF_b := DVU_y;
			elsif (v_flg_RL='1') then
				
				-- RL
				RF_b := RF_body(v_AD)(14 downto 0) & RF_body(v_AD)(15);
			elsif (v_flg_RR='1') then
				
				-- RR
				RF_b := RF_body(v_AD)(0) & RF_body(v_AD)(15 downto 1);
			elsif (v_flg_SLN='1') then
				
				-- SL0, SL1
				
				RF_b := RF_body(v_AD)(14 downto 0) & I_OPC(3);
			elsif (v_flg_SRN='1') then
				
				-- SR0, SR1
				RF_b := I_OPC(3) & RF_body(v_AD)(15 downto 1);
			elsif (v_flg_SLX='1') then
				
				-- SLX
				RF_b := RF_body(v_AD)(14 downto 0) & RF_body(v_AD)(0);
			elsif (v_flg_SRX='1') then
				
				-- SRX
				RF_b := RF_body(v_AD)(15) & RF_body(v_AD)(15 downto 1);
			elsif (v_flg_SLC='1') then
				
				-- SLC
				RF_b := RF_body(v_AD)(14 downto 0) & FLG_C;
			elsif (v_flg_SRC='1') then
				
				-- SRC
				RF_b := FLG_C & RF_body(v_AD)(15 downto 1);
			elsif (I_START='1')	 then
				RF_b := ASLOU_y;
			end if;
			
			-- MUX RF:WR
			
			if (I_WRD='1' 
				 or v_flg_CPY='1'
				 or v_mpu_state=DONE
				 or v_dvu_state=DONE
				 or (v_mpu_state=BUSY and MPU_rdy='1')
				 or (v_dvu_state=BUSY and DVU_rdy='1')
				 or (I_START='1'
					 and v_flg_MPU='0'
					 and v_flg_DVU='0'
					 and I_OPC/="00101" -- TEST
					 and I_OPC/="01001")-- CMP
				) then
				
				RF_body(v_AB) := RF_b;
			end if;

			L_FLG_Z <= FLG_Z;
			L_FLG_C <= FLG_C;

			if (I_RDD='1') then				
				O_D <= RF_body(v_AD);
			end if;
		end if;
		
		if (v_dvu_state=FREE and v_mpu_state=FREE and I_START='0') then
			O_RDY<='1';
		else
			O_RDY<='0';
		end if;
		
		L_C <= RF_body(v_AC);
		L_D <= RF_body(v_AD);
	end process;	

	O_C  <= L_C;
	O_CZ <= L_FLG_C & L_FLG_Z;
	
end arch;

