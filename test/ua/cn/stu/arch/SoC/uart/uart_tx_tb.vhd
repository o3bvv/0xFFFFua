LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_ARITH.ALL;
 
ENTITY uart_tx_tb IS
	generic(
			G_DATA_WIDTH : natural := 8);
END uart_tx_tb;
 
ARCHITECTURE behavior OF uart_tx_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component uart_tx is
		generic(
			G_DATA_WIDTH : natural := G_DATA_WIDTH);
		port (
			I_CLK	: in	STD_LOGIC;
			I_RST	: in	STD_LOGIC;
			I_DATA	: in	STD_LOGIC_VECTOR (G_DATA_WIDTH-1 downto 0);
			I_WR	: in	STD_LOGIC;
			I_E		: in	STD_LOGIC;
			I_RDY_A	: in	STD_LOGIC;
			O_RDY	: out	STD_LOGIC;
			O_TXD	: out	STD_LOGIC);
	end component;
	
	--Constants
	type t_bauds is (x1200, x2400, x4800, x9600, x19200);
	type t_baud_divs is array(0 to t_bauds'Pos(t_bauds'right)) of natural;
	
	--Local
	signal L_baud_divs: t_baud_divs := (
		20832-1,
		10416-1,
		5208-1,
		2604-1,
		1302-1);
	
	signal L_baud	: t_bauds 	:= x9600;
	signal L_baud_div: natural 	:= L_baud_divs(t_bauds'Pos(L_baud));
	
	signal L_clk 	: STD_LOGIC := '0';
	signal L_wr 	: STD_LOGIC := '1';	
    
	signal L_data: natural 	:= 0;
	
	--Inputs
	signal I_CLK  : std_logic := '0';
	signal I_DATA : STD_LOGIC_VECTOR (G_DATA_WIDTH-1 downto 0);

	--Outputs
	signal O_TXD : std_logic;
	signal O_RDY : std_logic := '0';

	-- Clock period definitions
	constant I_CLK_period : time := 10 ns;
 
BEGIN 

	uut: uart_tx
		port map(
			I_CLK	=> L_clk,
			I_RST	=> '0',
			I_DATA	=> I_DATA,
			I_WR	=> L_wr,
			I_E		=> '1',
			I_RDY_A	=> '1',
			O_TXD	=> O_TXD,
			O_RDY 	=> O_RDY);		
	
	process(I_CLK)
		variable div: natural := 0;
	begin
		if (I_CLK='1' and I_CLK'event) then
			if (div=L_baud_div) then
				L_clk <= not L_clk;
				div := 0;
			else 
				div := div+1;
			end if;
		end if;		
	end process;
	
	process(O_RDY)
	begin
		if (O_RDY='1' and O_RDY'event) then
			if (L_data<10) then
				L_data <= L_data+1;
			else
				L_data <= 0;			
			end if;
		end if;
	end process;
	
	
	L_wr <= '1';
	L_baud_div <= L_baud_divs(t_bauds'Pos(L_baud));
	
	I_DATA <= conv_std_logic_vector(L_data+48, I_DATA'length);
	I_CLK <= NOT I_CLK after I_CLK_period;	
END;
