--------------------------------------------------------------------------------
-- IVH Project
-- Author: Roman Janota
-- Date : 08/05/2022
--	File : fsm_newspaper.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use work.newspaper_pack.ALL;

entity fsm_newspaper is
	Port ( CLK : in std_logic;
			 RST : in std_logic;
			 ROT_L_EN : in std_logic;
			 ROT_R_EN : in std_logic;
			 ANIM_EN : in std_logic;
			 OUTPUT : out std_logic;	-- decide whether the direction is correct based on this output
			 OUTPUT_DIR : out DIRECTION_T
			 );
end fsm_newspaper;

architecture Behavioral of fsm_newspaper is
   type state_type is (st1_IDLE, st2_ROT_R, st3_ROT_L, st4_ANIM); 
   signal state, next_state : state_type; 
   signal out_i : std_logic;  
	signal out_dir_i : DIRECTION_T;

begin

SYNC_PROC: process (CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (RST = '1') then
            state <= st1_IDLE;
            OUTPUT <= '0';
         else
            state <= next_state;
            OUTPUT <= out_i;
				OUTPUT_DIR <= out_dir_i;
         end if;        
      end if;
   end process;
 
   OUTPUT_DECODE: process (state, out_i, out_dir_i)
   begin
      if state = st1_IDLE then
         out_i <= '0';
      elsif state = st2_ROT_R then
         out_i <= '1';
			out_dir_i <= DIR_RIGHT;
		elsif state = st3_ROT_L then
			out_i <= '1';
			out_dir_i <= DIR_LEFT;
		else
			out_i <= '1';
			out_dir_i <= DIR_ANIM;
      end if;
   end process;
 
   NEXT_STATE_DECODE: process (state, ROT_L_EN, ROT_R_EN, ANIM_EN)
   begin
      next_state <= state;  
      
      case (state) is
         when st1_IDLE =>
				if ROT_L_EN = '1' or ROT_R_EN = '1' or ANIM_EN = '1' then
					next_state <= st2_ROT_R;
				else
					next_state <= st1_IDLE;
				end if;	
				
			when st2_ROT_R =>
				if ROT_L_EN = '1' then
					next_state <= st2_ROT_R;
				else
					next_state <= st3_ROT_L;
				end if;
				
			when st3_ROT_L =>
				if ROT_R_EN = '1' then
					next_state <= st3_ROT_L;
				else
					next_state <= st4_ANIM;
				end if;

			when st4_ANIM =>
				if ANIM_EN = '1' then
					next_state <= st4_ANIM;
				else
					next_state <= st1_IDLE;
				end if;
				
         when others =>
            next_state <= st1_IDLE;
      end case;      
   end process;
end Behavioral;

