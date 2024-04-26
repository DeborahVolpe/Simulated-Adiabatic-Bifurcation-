library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	generic ( N : positive := 8);
	port(
		a			: in std_logic_vector(N-1 downto 0);
		b 			: in std_logic_vector(N-1 downto 0);
		carry_in 	: in std_logic;
		sum 		: out std_logic_vector(N-1 downto 0)
		);
end entity adder;

architecture behaviour of adder is

	signal a_signed, b_signed			: signed (N-1 downto 0);
	signal sum_signed					: signed (N-1 downto 0);
	signal carry_in_std					: std_logic_vector(1 downto 0);
	signal carry_in_signed				: signed(1 downto 0);
	
	begin
	
		a_signed 			<= signed(A);
		b_signed 			<= signed(B);
		carry_in_std(0)		<= carry_in;
		carry_in_std(1)		<= '0';
		carry_in_signed		<= signed(carry_in_std);
		sum_signed	 		<= a_signed + b_signed + carry_in_signed;
		sum					<= std_logic_vector(sum_signed);
		
end architecture behaviour;
