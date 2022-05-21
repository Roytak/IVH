--------------------------------------------------------------------------------
-- IVH Project
-- Author: Roman Janota
-- Date : 08/05/2022
--	File : tb_rom.vhd
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_rom IS
END tb_rom;
 
ARCHITECTURE behavior OF tb_rom IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT rom16x128
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         address : IN  integer range 0 to 15;
         data : OUT  std_logic_vector(0 to 127)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal address : integer range 0 to 15 := 0;

 	--Outputs
   signal data : std_logic_vector(0 to 127);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rom16x128 PORT MAP (
          CLK => CLK,
          RST => RST,
          address => address,
          data => data
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
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= address + 1;
		wait for 20ns;
		address <= 0;
		wait for 20ns;

      wait;
   end process;

END;
