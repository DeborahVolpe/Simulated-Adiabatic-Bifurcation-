library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- multiplex 2 to 1 for std_logic_vector
-- generic for the number of bit 

entity bN_2to1mux is
	generic (N : positive := 8);
	port	( 
			x		: in std_logic_vector (N-1 downto 0); --0
			y		: in std_logic_vector (N-1 downto 0); --1
			s		: in std_logic;
			output	: out std_logic_vector(N-1 downto 0)
		  );
end entity bN_2to1mux;

architecture structure of bN_2to1mux is
	begin
	
		G: for i in 0 to N-1 generate
		
			output(i) <= (not(s) and x(i)) or (s and y(i));
			
		end generate;
	
end architecture structure;