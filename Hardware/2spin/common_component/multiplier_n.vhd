library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_n is
	generic ( N : positive:=4);
	port 	( 
			A		: in std_logic_vector (N-1 downto 0 );
			B 		: in std_logic_vector (N-1 downto 0 );
			P    	: out std_logic_vector (2*N-1 downto 0)
			);
end entity multiplier_n;

architecture behaviour of multiplier_n is

	signal a_signed, b_signed			: signed (N-1 downto 0);
	signal p_signed					: signed (2*N-1 downto 0);
	
	begin
	
		a_signed 	<= signed(A);
		b_signed 	<= signed(B);
		
		p_signed 	<= a_signed*b_signed;
		
		P 			<= std_logic_vector(p_signed);
		
end architecture behaviour;
				 
				 
				 