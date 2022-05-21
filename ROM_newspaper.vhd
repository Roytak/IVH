--------------------------------------------------------------------------------
-- IVH Project
-- Author: Roman Janota
-- Date : 08/05/2022
--	File : ROM_newspaper.vhd
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity rom16x128 is
port(
CLK : in std_logic;
RST : in std_logic;
address: in integer range 0 to 15;
data : out std_logic_vector(0 to 127)
);
end entity;

architecture rtl of rom16x128 is
type rom_array is array (0 to 15) of std_logic_vector (0 to 127);
constant rom: rom_array := (
"00000001000000010000100111111111000000000000000011111111000000000000000000000001111111110000000100000000000000000000000000000000",
"00000000000000010000000100001001111111110000000000000000111111110000000000000000000000011111111100000001000000000000000000000000",
"00000000000000000000000100000001000010011111111100000000000000001111111100000000000000000000000111111111000000010000000000000000",
"00000000000000000000000000000001000000010000100111111111000000000000000011111111000000000000000000000001111111110000000100000000",
"00000000000000000000000000000000000000010000000100001001111111110000000000000000111111110000000000000000000000011111111100000001",
"00000001000000000000000000000000000000000000000100000001000010011111111100000000000000001111111100000000000000000000000111111111",
"11111111000000010000000000000000000000000000000000000001000000010000100111111111000000000000000011111111000000000000000000000001",
"00000001111111110000000100000000000000000000000000000000000000010000000100001001111111110000000000000000111111110000000000000000",
"00000000000000011111111100000001000000000000000000000000000000000000000100000001000010011111111100000000000000001111111100000000",
"00000000000000000000000111111111000000010000000000000000000000000000000000000001000000010000100111111111000000000000000011111111",
"11111111000000000000000000000001111111110000000100000000000000000000000000000000000000010000000100001001111111110000000000000000",
"00000000111111110000000000000000000000011111111100000001000000000000000000000000000000000000000100000001000010011111111100000000",
"00000000000000001111111100000000000000000000000111111111000000010000000000000000000000000000000000000001000000010000100111111111",
"11111111000000000000000011111111000000000000000000000001111111110000000100000000000000000000000000000000000000010000000100001001",
"00001001111111110000000000000000111111110000000000000000000000011111111100000001000000000000000000000000000000000000000100000001",
"00000001000010011111111100000000000000001111111100000000000000000000000111111111000000010000000000000000000000000000000000000001"
);
begin

data <= rom(address);
end architecture;
