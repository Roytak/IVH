--------------------------------------------------------------------------------
-- IVH Project
-- Author: Roman Janota
-- Date : 08/05/2022
--	File : column_entity.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.newspaper_pack.ALL;

entity column_entity is
	 Generic ( N : integer);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           STATE : out  STD_LOGIC_VECTOR (N-1 downto 0);
           INIT_STATE : in  STD_LOGIC_VECTOR (N-1 downto 0);
           NEIGH_LEFT : inout  STD_LOGIC_VECTOR (N-1 downto 0);
           NEIGH_RIGHT : inout  STD_LOGIC_VECTOR (N-1 downto 0);
           DIRECTION : in  DIRECTION_T;
           EN : in  STD_LOGIC);
end column_entity;

architecture Behavioral of column_entity is

begin

col_proc: process(CLK)

begin
	if CLK'event and CLK = '1' then
		if RST = '1' then
			STATE <= (others => '0');
			NEIGH_LEFT <= (others => '0');
			NEIGH_RIGHT <= (others => '0');
		else
			if EN = '1' then
				if DIRECTION = DIR_LEFT then -- if the direction is to the left, then assign the right column to the current one and the current column to the left column
					STATE <= NEIGH_RIGHT;
					NEIGH_LEFT <= INIT_STATE;
				end if;	
				if DIRECTION = DIR_RIGHT then	-- if the direction is to the right, then assign the left column to the current one and the current column to the right column
					STATE <= NEIGH_LEFT;
					NEIGH_RIGHT <= INIT_STATE;
				end if;
			end if;
		end if;
	end if;
end process col_proc;


end Behavioral;

