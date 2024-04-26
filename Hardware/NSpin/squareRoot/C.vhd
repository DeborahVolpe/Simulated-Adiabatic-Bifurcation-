library ieee;
use ieee.std_logic_1164.all;

--Controlled Subtract Multiplex with y fixed at 1 and u fixed at 0
--design by contraction
--the difference is not calculated because in this case it is not used by subsequent blocks
--base block for square root unit 

entity C is
port    (
        x   : in std_logic;
		b   : in std_logic; 
        b0	: out std_logic --borrow
        );
end entity C;

architecture behaviour of C is
begin
	b0 <= (b and not(x));
end architecture behaviour;