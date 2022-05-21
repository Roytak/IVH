--------------------------------------------------------------------------------
-- IVH Project
-- Author: Roman Janota
-- Date : 08/05/2022
--	File : tb_controller.vhd
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_controller IS
END tb_controller;
 
ARCHITECTURE behavior OF tb_controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT controller_newspaper
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         A : OUT  std_logic_vector(3 downto 0);
         R : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal A : std_logic_vector(3 downto 0);
   signal R : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controller_newspaper PORT MAP (
          CLK => CLK,
          RST => RST,
          A => A,
          R => R
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

      wait;
   end process;

END;
