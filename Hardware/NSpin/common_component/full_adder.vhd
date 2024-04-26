library ieee; 
use ieee.std_logic_1164.all;

-- basic full adder 

entity full_adder is
    port(
            a			: in std_logic;
            b		    : in std_logic;
            c_in		: in std_logic;
            s		    : out std_logic;
            c_out		: out std_logic
        );
end entity full_adder;

architecture structure of full_adder is

begin

    s <= a xor b xor c_in;
    c_out <= (a and b) or (a and c_in) or (b and c_in);    

end architecture structure;