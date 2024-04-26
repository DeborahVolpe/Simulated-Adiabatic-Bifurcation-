library ieee;
use ieee.std_logic_1164.all;

--Controlled Subtract Multiplex with y fixed at 1
--design by contraction
--base block for square root unit

entity A is
port    (
        x   : in std_logic;
		b   : in std_logic;
        u   : in std_logic;
        b0	: out std_logic; -- borrow
		d	: out std_logic -- difference
        );
end entity A;

architecture behaviour of A is
begin
	b0 <= (b and not(x));
	d <=  (not(x) and b and not(u)) or (x and not(b)) or (x and u);
end architecture behaviour;