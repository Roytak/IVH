--------------------------------------------------------------------------------
-- IVH Project
-- Author: Roman Janota
-- Date : 08/05/2022
--	File : tb_fsm.vhd
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.newspaper_pack.ALL;

 
ENTITY tb_fsm IS
END tb_fsm;
 
ARCHITECTURE behavior OF tb_fsm IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fsm_newspaper
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         ROT_L_EN : IN  std_logic;
         ROT_R_EN : IN  std_logic;
         ANIM_EN : IN  std_logic;
         OUTPUT : OUT  std_logic;
         OUTPUT_DIR : OUT  DIRECTION_T
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal ROT_L_EN : std_logic := '0';
   signal ROT_R_EN : std_logic := '0';
   signal ANIM_EN : std_logic := '0';

 	--Outputs
   signal OUTPUT : std_logic;
   signal OUTPUT_DIR : DIRECTION_T;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fsm_newspaper PORT MAP (
          CLK => CLK,
          RST => RST,
          ROT_L_EN => ROT_L_EN,
          ROT_R_EN => ROT_R_EN,
          ANIM_EN => ANIM_EN,
          OUTPUT => OUTPUT,
          OUTPUT_DIR => OUTPUT_DIR
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
		
		ROT_L_EN <= '0';
		ROT_R_EN <= '0';
		ANIM_EN <= '0';
		
		wait for 50 ns;
		
		ROT_L_EN <= '1', '0' after 10ns;
		
		wait for 50 ns;
		
		ROT_R_EN <= '1', '0' after 10ns;
		
		wait for 50 ns;
		
		ANIM_EN <= '1', '0' after 10ns;

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
