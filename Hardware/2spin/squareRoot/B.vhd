library ieee;
use ieee.std_logic_1164.all;

--Controlled Subtract Multiplex with y fixed at 0 and b0 fixed at 0
--design by contraction
--base block for square root unit 

entity B is
port    (
        x   : in std_logic;
        u   : in std_logic;
        b0	: out std_logic; --borrow
		d	: out std_logic --difference
        );
end entity B;

architecture behaviour of B is
begin
	b0 <= not(x);
	d <= x xnor u;
end architecture behaviour;