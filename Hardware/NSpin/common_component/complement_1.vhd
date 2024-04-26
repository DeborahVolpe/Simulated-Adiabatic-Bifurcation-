library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity complement_1 is
	generic	( N : POSITIVE:=8);
	port 	( 
			B			: in std_logic_vector (N-1 downto 0);
			sub_add_n 	: in std_logic;
			B_c 		: out std_logic_vector (N-1 downto 0)
			);
end entity complement_1;

architecture structure of complement_1 is

	begin
		G : for i in 0 to (N-1) generate
			B_c(i) <= B(i) xor sub_add_n;
		end generate;

end architecture structure;
 