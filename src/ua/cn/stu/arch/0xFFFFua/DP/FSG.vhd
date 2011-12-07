----------------------------------------------------------------------------------
-- Flag Storage
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity FSG is
	port (
		I_CLK	: IN	STD_LOGIC;
		I_RST	: IN	STD_LOGIC;
		I_C 	: IN	STD_LOGIC;
		I_Z 	: IN	STD_LOGIC;
		O_C 	: OUT	STD_LOGIC;
		O_Z 	: OUT	STD_LOGIC);
end FSG;

architecture Behavioral of FSG is

	component FDRE is 
		port (
			Q	: OUT	STD_ULOGIC;
			D	: IN	STD_ULOGIC;
			C	: IN	STD_ULOGIC;
			CE	: IN	STD_ULOGIC;
			R	: IN	STD_ULOGIC);
	end component;
	
	signal L_z : STD_LOGIC := '0';
	signal L_c : STD_LOGIC := '0';
	
	constant L_VCC : STD_LOGIC := '1';
begin

	process(I_CLK,I_RST)
	begin
		if (I_RST='1') then
			L_c <= '0';
			L_z <= '0';
		elsif(I_CLK='0' and I_CLK'event) then
			L_c <= I_C;
			L_z <= I_Z;
		end if;
	end process;

	O_C <= L_c;
	O_Z <= L_z;
	
end Behavioral;


