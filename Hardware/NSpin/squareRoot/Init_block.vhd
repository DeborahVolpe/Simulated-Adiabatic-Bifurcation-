library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--First row of square root components

entity Init_block is

	port    (
			P   : in std_logic;
			U	: out std_logic
			);
			
end entity Init_block;

architecture structure of Init_block is

begin

	U <= not(P);
	
end architecture structure;
