--------------------------------------------------------------------------------
-- IVH Project
-- Author: Roman Janota
-- Date : 08/05/2022
--	File : counter.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity counter is
	 Generic (OUT_P : integer); -- this constant has to be a log2 of the clock output period needed, assuming the clock period is 1		
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           EN : out  STD_LOGIC);
end counter;

architecture Behavioral of counter is
	signal cnt : std_logic_vector(OUT_P downto 0);
begin

	process(CLK, RESET)
	begin
		if RESET = '1' then
			cnt <= (others => '0');
		else
			if CLK'event and CLK= '1' then
				cnt <= cnt + 1;
			end if;
		end if;
	end process;
EN <= '1' WHEN cnt = 0 ELSE '0';
end Behavioral;		