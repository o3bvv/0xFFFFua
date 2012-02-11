library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity OxFFFFua is
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
end OxFFFFua;

architecture arch of OxFFFFua is
	
	type MATRIX32x11 is array(31 downto 0) of STD_LOGIC_VECTOR (10 downto 0);
	
	component MUX3x16 is
		port (
			I0		: in	STD_LOGIC_VECTOR (15 downto 0);
			I1		: in	STD_LOGIC_VECTOR (15 downto 0);
			I2		: in	STD_LOGIC_VECTOR (15 downto 0);
			I_ADDR	: in	STD_LOGIC_VECTOR (1 downto 0);
			O		: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal DPI_MUX_ADDR	: STD_LOGIC_VECTOR (1 downto 0) := (others=>'0');
	
	component ROM_512x16_DUO is
		port (		
			I_CLK	: in	STD_LOGIC;
			
			I_ADDR	: in	STD_LOGIC_VECTOR (8 downto 0);
					
			O_DATA0	: out	STD_LOGIC_VECTOR (15 downto 0);
			O_DATA1	: out	STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal ROM_ADDR  : STD_LOGIC_VECTOR (8 downto 0)  := (others => '0');
	signal ROM_DATA0 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal ROM_DATA1 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');	
	
	component RAM_512x16
		port (
			I_CLK  : in  STD_LOGIC;
			I_RST  : in  STD_LOGIC;
			I_WR   : in  STD_LOGIC;
			I_ADDR : in  STD_LOGIC_VECTOR (8 downto 0);
			I_DATA : in  STD_LOGIC_VECTOR (15 downto 0);
			O_DATA : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
	
	signal RAM_WR	  : STD_LOGIC := '0';
	signal RAM_ADDR   : STD_LOGIC_VECTOR (8 downto 0)  := (others => '0');
	signal RAM_O_DATA : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	signal RAM_I_DATA : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
	
	component DP
		port(
			 I_CLK : IN  std_logic;
			 I_RST : IN  std_logic;
			 I_RDD : IN  std_logic;
			 I_WRD : IN  std_logic;
			 I_START : IN  std_logic;
			 I_OPC : IN  std_logic_vector(4 downto 0);
			 I_AB : IN  std_logic_vector(4 downto 0);
			 I_AC : IN  std_logic_vector(4 downto 0);
			 I_AD : IN  std_logic_vector(4 downto 0);
			 I_DATA : IN  std_logic_vector(15 downto 0);
			 I_CZ : IN  std_logic_vector(1 downto 0);
			 I_RET : IN  std_logic;
			 O_RDY : OUT  std_logic;
			 O_DIVZ : OUT  std_logic;
			 O_CZ : OUT  std_logic_vector(1 downto 0);
			 O_C : OUT  std_logic_vector(15 downto 0);
			 O_D : OUT  std_logic_vector(15 downto 0)
			);
    end component;
	
	signal DP_RDD   : std_logic := '0';
	signal DP_WRD   : std_logic := '0';
	signal DP_START : std_logic := '0';
	signal DPI_DATA : std_logic_vector(15 downto 0) := (others => '0');
	signal DPI_CZ   : std_logic_vector(1 downto 0)  := (others => '0');
	signal DP_RET   : std_logic := '0';

	signal DP_RDY  : std_logic;
	signal DP_DIVZ : std_logic;
	signal DPO_CZ  : std_logic_vector(1 downto 0);
	signal DP_C    : std_logic_vector(15 downto 0);
	signal DP_D    : std_logic_vector(15 downto 0);
	
    signal PRL_WR : std_logic := '0';
	signal PRL_RD : std_logic := '0';
	
	signal L_RDY_PRL_A : std_logic := '0';
	signal L_DATA 	   : std_logic_vector(15 downto 0) := (others => '0');
	
begin

	ROM: ROM_512x16_DUO
		port map( 
			I_CLK 	=> I_CLK,
			I_ADDR 	=> ROM_ADDR,
			O_DATA0	=> ROM_DATA0,
			O_DATA1	=> ROM_DATA1);			
	
	RAM: RAM_512x16
		port map(
			I_CLK 	=> I_CLK,
			I_RST 	=> I_RST,
			I_WR	=> RAM_WR,
			I_ADDR	=> RAM_ADDR,
			I_DATA	=> RAM_I_DATA,
			O_DATA	=> RAM_O_DATA);
			
	RAM_I_DATA <= DP_D;
	RAM_ADDR   <= DP_C(8 downto 0);
	
	DP_inst: DP
		port map (
          I_CLK   => I_CLK,
          I_RST   => I_RST,
          I_RDD   => DP_RDD,
          I_WRD   => DP_WRD,
          I_START => DP_START,
          I_AB 	  => ROM_DATA0(9 downto 5),
		  I_AC 	  => ROM_DATA0(4 downto 0),
		  I_AD 	  => ROM_DATA1(4 downto 0),
		  I_OPC   => ROM_DATA1(15 downto 11),
          I_DATA  => DPI_DATA,
          I_CZ    => DPI_CZ,
          I_RET   => DP_RET,
          O_RDY   => DP_RDY,
          O_DIVZ  => DP_DIVZ,
          O_CZ    => DPO_CZ,
          O_C     => DP_C,
          O_D     => DP_D);
		  
	DP_MUX : MUX3x16
			port map(
				I_ADDR 	=> DPI_MUX_ADDR,
				I0		=> RAM_O_DATA,
				I1		=> ROM_DATA1,
				I2		=> I_DATA,
				O	 	=> DPI_DATA);
	
	process(I_CLK, I_RST)
		
		--------
		-- CB --
		--------
		
		variable steps_wait   : natural := 0;
		variable address_wait : STD_LOGIC := '1';
	
		variable instruction 		: STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
		variable instruction_prefix : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		variable instruction_suffix : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
		
		variable BRA_condition			 : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
		variable BRA_condition_satisfied : STD_LOGIC := '0';
		
		variable flg_32bit_instruction	 : STD_LOGIC := '0';
		variable flg_data_tx_instruction : STD_LOGIC := '0';
		
		variable flg_BRA  : STD_LOGIC := '0';
		variable flg_JMPL : STD_LOGIC := '0';
		variable flg_CALL : STD_LOGIC := '0';
		variable flg_RET  : STD_LOGIC := '0';
		variable flg_LI	  : STD_LOGIC := '0';
		variable flg_ALOP : STD_LOGIC := '0';
		variable flg_LD	  : STD_LOGIC := '0';
		variable flg_UD	  : STD_LOGIC := '0';
		variable flg_IN	  : STD_LOGIC := '0';
		variable flg_OUT  : STD_LOGIC := '0';
		
		--------
		-- IP --
		--------
		variable STACK_body	: MATRIX32x11 := (others => (others => '0'));
		variable STACK_ptr 	: integer range 0 to 32 := 0;
		
		variable v_ROM_addr,
				 v_ROM_addr_next_1,
				 v_ROM_addr_next_2 : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
	begin
		
		if (I_RST='1') then
			address_wait := '1';
			steps_wait   := 0;
			STACK_ptr    := 0;
			v_ROM_addr   := (others => '0');
			ROM_addr     <= (others => '0');
			DP_WRD 		 <= '0';
			DP_RDD 		 <= '0';
			PRL_WR 		 <= '0';
			PRL_RD 		 <= '0';
		elsif (I_CLK='1' and I_CLK'event) then
			
			instruction := ROM_DATA0(15 downto 10);
			
			instruction_prefix := instruction(5 downto 3);
			instruction_suffix := instruction(2 downto 1);
			
			-- PARSE BRA CONDITION SATISFIED
			
			BRA_condition	:= instruction_suffix & instruction(0);
	
			if (   (BRA_condition="010" and DPO_CZ(0)='1')	-- JE
				or (BRA_condition="011" and DPO_CZ(0)='0')	-- JNE
				or (BRA_condition="100" and DPO_CZ(1)='1')	-- JC, JB
				or (BRA_condition="101" and DPO_CZ(1)='0')	-- JNC
				or (BRA_condition="110" and DPO_CZ="00")	-- JA
				) then
				
				BRA_condition_satisfied := '1';
			else
				BRA_condition_satisfied := '0';
			end if;
			
			if (instruction_prefix="011") then	-- PORT OUT
				flg_data_tx_instruction := '1';
			else
				flg_data_tx_instruction := '0';
			end if;
			
			-- PARSE INSTRUCTION PREFIX
			
			if (instruction_prefix="000") then
				flg_BRA := '1';
			else
				flg_BRA := '0';
			end if;
			
			if (instruction_prefix="001") then
				flg_JMPL := '1';
			else
				flg_JMPL := '0';
			end if;
			
			if (instruction_prefix="010") then
				flg_CALL := '1';
			else
				flg_CALL := '0';
			end if;
			
			if (instruction_prefix="110") then
				flg_RET := '1';
			else
				flg_RET := '0';
			end if;
			
			if (instruction_prefix="101") then
				flg_LI := '1';
			else
				flg_LI := '0';
			end if;
			
			if (instruction_prefix="100") then
				flg_ALOP := '1';
			else
				flg_ALOP := '0';
			end if;		
			
			-- PARSE INSTRUCTION SUFFIX
			
			if (flg_data_tx_instruction='1'
					and  instruction_suffix="00") then
					
				flg_LD := '1';
			else
				flg_LD := '0';
			end if;
			
			if (flg_data_tx_instruction='1'
					and  instruction_suffix="01") then
					
				flg_UD := '1';
			else
				flg_UD := '0';
			end if;
			
			if (flg_data_tx_instruction='1'
					and  instruction_suffix="10") then
					
				flg_IN := '1';
			else
				flg_IN := '0';
			end if;
			
			if (flg_data_tx_instruction='1'
					and  instruction_suffix="11") then
					
				flg_OUT := '1';
			else
				flg_OUT := '0';
			end if;
				
			-- GET OPERATION LENGTH
				
			if (   flg_UD	='1'
				or flg_IN	='1'
				or flg_OUT  ='1'
				or flg_LI	='1'
				or flg_ALOP ='1') then
					
				flg_32bit_instruction := '1';
			else
				flg_32bit_instruction := '0';
			end if;
			
			-- SET DP MUX ADDRESS
			
			if (flg_LI='1') then
				DPI_MUX_ADDR <= "01";
			elsif (flg_IN='1') then
				DPI_MUX_ADDR <= "10";
			else  -- LD
				DPI_MUX_ADDR <= "00";
			end if;
			
			-- CONTROL BLOCK
			if (address_wait='0') then
				if (flg_LI='1') then
					case steps_wait is
						when 0 =>
							steps_wait := 2;
						when 2 =>
							DP_WRD <= '1';
							steps_wait := 1;
						when others =>
							DP_WRD <= '0';
							steps_wait := 0;
					end case;
				elsif(flg_OUT='1') then
					case steps_wait is
						when 0 =>						
							DP_RDD <= '1';
							steps_wait := 3;
							O_ADDR_PRL <= ROM_DATA1(9 downto 5);
						when 3 =>
							steps_wait := 2;
						when 2 =>
							DP_RDD <= '0';
							if (I_RDY_PRL='1') then
								L_DATA <= DP_D;
								PRL_WR <= '1';
								steps_wait := 1;
							end if;						
						when others =>
							PRL_WR <= '0';						
							if (I_RDY_PRL='1') then
								steps_wait := 0;
							end if;	
					end case;
				elsif(flg_IN='1') then
					case steps_wait is
						when 0 =>
							steps_wait := 3;
							O_ADDR_PRL <= ROM_DATA1(9 downto 5);
						when 3 =>
							if (I_RDY_PRL='1') then
								PRL_RD <= '1';
								steps_wait := 2;
							end if;
						when 2 =>
							if (I_RDY_PRL='1') then
								PRL_RD <= '0';
								DP_WRD <= '1';
								steps_wait := 1;
							end if;
						when others =>
							DP_WRD <= '0';
							steps_wait := 0;
					end case;
				elsif(flg_LD='1') then
					case steps_wait is
						when 0 =>
							steps_wait := 1;
							DP_WRD <= '1';
						when others =>
							DP_WRD <= '0';
							steps_wait := 0;
					end case;
				elsif(flg_ALOP='1') then
					case steps_wait is
						when 0 =>
							steps_wait := 1;
							DP_START <= '1';
						when others =>
							DP_START <= '0';
							if (DP_RDY='1') then
								steps_wait := 0;
							end if;
					end case;
				end if;
			end if;
			
			-- INSTRUCTION POINTER MANAGER

			if (steps_wait=0 and address_wait='0') then
				address_wait := '1';
				if (flg_JMPL='1') then					
					-- do JMPL
					v_ROM_addr := ROM_DATA0(8 downto 0);
				elsif (flg_BRA='1' 
					and (BRA_condition="001" or BRA_condition_satisfied='1')) then					
					-- do JMP
					v_ROM_addr := 					
						conv_std_logic_vector(
							SIGNED(v_ROM_addr) + SIGNED(ROM_DATA0(8 downto 0)),
							v_ROM_addr'length);
				elsif (flg_RET='1') then
					-- do RET					
					DPI_CZ     <= STACK_body(STACK_ptr - 1)(10 downto 9);
					v_ROM_addr := STACK_body(STACK_ptr - 1)(8 downto 0);
					STACK_ptr  := STACK_ptr - 1;
				elsif (flg_CALL='1') then					
					-- do CALL
					STACK_body(STACK_ptr) := DPO_CZ & v_ROM_addr_next_1;					
					STACK_ptr  := STACK_ptr + 1;
					v_ROM_addr := ROM_DATA0(8 downto 0);
				elsif (flg_32bit_instruction='1') then
					-- go +2
					v_ROM_addr := v_ROM_addr_next_2;
				elsif (flg_BRA='0' or (flg_BRA='1' and BRA_condition/="000")) then
					-- go +1
					v_ROM_addr := v_ROM_addr_next_1;
				end if;
			elsif (address_wait = '1') then
				address_wait := '0';
			end if;
			
			v_ROM_addr_next_1 := 
				conv_std_logic_vector(
					UNSIGNED(v_ROM_addr) + 1, v_ROM_addr_next_1'length);
			v_ROM_addr_next_2 :=
				conv_std_logic_vector(
					UNSIGNED(v_ROM_addr) + 2, v_ROM_addr_next_2'length);
			
			ROM_ADDR    <= v_ROM_addr;
			L_RDY_PRL_A <= I_RDY_PRL;
		end if;
		
	end process;

	O_WR_PRL    <= PRL_WR;
	O_RD_PRL 	<= PRL_RD;
	
	O_RDY_PRL_A <= L_RDY_PRL_A;
	
	O_DATA	 	<= L_DATA;

end arch;

