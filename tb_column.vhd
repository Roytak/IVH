--------------------------------------------------------------------------------
-- IVH Project
-- Author: Roman Janota
-- Date : 08/05/2022
--	File : tb_column.vhd
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.newspaper_pack.ALL;
 
ENTITY tb_column IS
END tb_column;
 
ARCHITECTURE behavior OF tb_column IS 
 
    COMPONENT column_entity
	 GENERIC ( N : integer);
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         STATE : OUT  std_logic_vector(7 downto 0);
         INIT_STATE : IN  std_logic_vector(7 downto 0);
         NEIGH_LEFT : INOUT  std_logic_vector(7 downto 0);
         NEIGH_RIGHT : INOUT  std_logic_vector(7 downto 0);
         DIRECTION : IN  DIRECTION_T;
         EN : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal INIT_STATE : std_logic_vector(7 downto 0) := (others => '0');
   signal DIRECTION : DIRECTION_T := DIR_LEFT;
   signal EN : std_logic := '0';

	--BiDirs
   signal NEIGH_LEFT : std_logic_vector(7 downto 0);
   signal NEIGH_RIGHT : std_logic_vector(7 downto 0);

 	--Outputs
   signal STATE : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: column_entity 
	GENERIC MAP (N => 8)
	PORT MAP (
          CLK => CLK,
          RST => RST,
          STATE => STATE,
          INIT_STATE => INIT_STATE,
          NEIGH_LEFT => NEIGH_LEFT,
          NEIGH_RIGHT => NEIGH_RIGHT,
          DIRECTION => DIRECTION,
          EN => EN
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RST <= '1';
      wait for 100 ns;	
		RST <= '0';

      wait for CLK_period*10;

      -- insert stimulus here 
		INIT_STATE <= "10101010";
		EN <= '1';
		wait for 40 ns;
		EN <= '0';
		
		wait for 20 ns;
		
		DIRECTION <= DIR_RIGHT;
		
		wait for 20 ns;
		
		INIT_STATE <= "00001111";
		EN <= '1', '0' after 40 ns;

      wait;
   end process;

END;
