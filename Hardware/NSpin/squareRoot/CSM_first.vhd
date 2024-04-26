library ieee;
use ieee.std_logic_1164.all;

--Controlled Subtract Multiplex
--base block for square root unit

entity CSM_first is
port    (
        y   : in std_logic;
		b   : in std_logic;
        u   : in std_logic;
        b0	: out std_logic; -- borrow
		d	: out std_logic -- difference
        );
end entity CSM_first;

architecture behaviour of CSM_first is

begin

	b0 <= not(y)or b;
	d <= (not(y) and not(b) and not(u)) or (y and b and not(u));
	
end architecture behaviour;