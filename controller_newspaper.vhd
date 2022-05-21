--------------------------------------------------------------------------------
-- IVH Project
-- Author: Roman Janota
-- Date : 08/05/2022
--	File : controller_newspaper.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.newspaper_pack.ALL;

entity controller_newspaper is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           A : out  STD_LOGIC_VECTOR (3 downto 0);
           R : out  STD_LOGIC_VECTOR (7 downto 0));
end controller_newspaper;

architecture Behavioral of controller_newspaper is
	signal led_clk_en : std_logic;	-- enable all leds
	signal col_clk_en : std_logic;	-- enable a specific column
	signal store_data : std_logic_vector(127 downto 0) := (others => '0');	--storing data to be displayed
	signal current_col : integer range 0 to 15;

	-- 3 rom signals and an address for all of them
	signal rom_data : std_logic_vector(0 to 127);
	signal rom_data2 : std_logic_vector(0 to 127);
	signal rom_data3 : std_logic_vector(0 to 127);
	signal rom_address : integer range 0 to 15;
	
	-- finite state machine signals
	signal fsm_rot_r_en : std_logic;
	signal fsm_rot_l_en : std_logic;
	signal fsm_anim_en : std_logic;
	signal fsm_counter : integer;
	signal fsm_output : std_logic;
	signal direction : DIRECTION_T;

begin

-- instantiate entities

led_clk : entity work.counter
	generic map(OUT_P => 12)
	port map (CLK => CLK, RESET => RST, EN => led_clk_en);
	
col_clk : entity work.counter
	generic map(OUT_P => 20)
	port map (CLK => CLK, RESET => RST, EN => col_clk_en);

fsm : entity work.fsm_newspaper
	port map (CLK => CLK, RST => RST, ROT_L_EN => fsm_rot_l_en, ROT_R_EN => fsm_rot_r_en, ANIM_EN => fsm_anim_en, OUTPUT => fsm_output, OUTPUT_DIR => direction);
	
rom : entity work.rom16x128
		port map (CLK => CLK, RST => RST, address => rom_address, DATA => rom_data);
		
rom2 : entity work.rom16x128
		port map (CLK => CLK, RST => RST, address => rom_address, DATA => rom_data2);

rom3 : entity work.rom16x128
		port map (CLK => CLK, RST => RST, address => rom_address, DATA => rom_data3);	

-- generating columns by using the for generate construction		
	
generate_columns: for i in 0 to 15 generate
		signal state : STD_LOGIC_VECTOR (7 downto 0);
      signal init_state : STD_LOGIC_VECTOR (7 downto 0);
      signal neigh_left : STD_LOGIC_VECTOR (7 downto 0);
      signal neigh_right : STD_LOGIC_VECTOR (7 downto 0);
begin
	store_data(i*8+7 downto i*8) <= state; -- store the output data

	C0: if i = 0 generate -- left most column
		init_state <= rom_data(0 to 7);
		neigh_left <= rom_data2(120 to 127);
		neigh_right <= rom_data3(8 to 15);
	end generate;
	
	C15: if i = 15 generate -- right most column
		init_state <= rom_data(120 to 127);
		neigh_left <= rom_data2(112 to 119);
		neigh_right <= rom_data3(0 to 7);
	end generate;
	
	CX: if i > 0 and i < 15 generate -- other columns
		init_state <= rom_data(8*i to (8*i + 7));
		neigh_left <= rom_data2((8 * (i-1)) to (8*i - 1));
		neigh_right <= rom_data3(8 * (i + 1) to (8*(i+1) + 7));
	end generate;

	COLUMN: entity work.column_entity
		generic map (N=>8)
		port map (CLK => CLK, RST => RST, STATE => state, INIT_STATE => init_state,
		NEIGH_LEFT => neigh_left, NEIGH_RIGHT => neigh_right, DIRECTION => direction, EN=> col_clk_en);

end generate;

-- generating fsm inputs/outputs

FSM_CNT : process(CLK)
begin
	if CLK'EVENT and CLK='1' then
		if RST = '1' then
			current_col <= 0;
			fsm_counter <= 0;
		else
			if led_clk_en = '1' then
				current_col <= current_col + 1;
				if current_col = 15 then
					current_col <= 0;
					fsm_counter <= fsm_counter + 1;
				end if;
			end if;
			if fsm_counter >= 0 and fsm_counter < 3 then
				fsm_rot_r_en <= '1';
				
			elsif fsm_counter >= 3 and fsm_counter < 6 then
				fsm_rot_r_en <= '0';
				fsm_rot_l_en <= '1';
			
			elsif	fsm_counter >= 6 and fsm_counter < 9 then
				fsm_rot_l_en <= '0';
				fsm_anim_en <= '1';
				
			else
				fsm_anim_en <= '0';
				fsm_counter <= 0;
				
			end if;
		end if;	
	end if;
end process FSM_CNT;

-- generating rom inputs/outputs

ROM_GEN : process (CLK)

begin

	if CLK'event and CLK = '1' then
		if RST = '1' then
			rom_address <= 0;
		else
			if col_clk_en = '1' then
				if rom_address < 15 then
					rom_address <= rom_address + 1;
				else
					rom_address <= 0;
					end if;
			end if;
		
		end if;
	end if;

end process ROM_GEN;

A <= std_logic_vector(to_unsigned(current_col, A'length)); -- pass the address of a column to be display
R <= store_data(current_col * 8 + 7 downto current_col * 8);	-- pass the data to the column of the FPGA

end Behavioral;

