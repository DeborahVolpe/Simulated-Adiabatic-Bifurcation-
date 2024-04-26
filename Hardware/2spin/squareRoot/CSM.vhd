library ieee;
use ieee.std_logic_1164.all;

--Controlled Subtract Multiplex
--base block for square root unit

entity CSM is
port    (
        x   : in std_logic;
        y   : in std_logic;
		b   : in std_logic;
        u   : in std_logic;
        b0	: out std_logic; -- borrow
		d	: out std_logic -- difference
        );
end entity CSM;

architecture behaviour of CSM is

signal temp : std_logic;
begin
	b0 <= (not(x) and not(y)) or (b and not(x)) or (b and not(y));
	d <= (not(x) and not(y) and not(b) and not(u)) or (not(x) and y and b and not(u)) or (x and y and not(b)) or (x and u) or (x and not(y) and b);
end architecture behaviour;