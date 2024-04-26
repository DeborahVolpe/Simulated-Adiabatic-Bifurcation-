library ieee;
use ieee.std_logic_1164.all;

entity reset_gen is
	port ( 
		  reset  : out std_logic
		  );
end entity;

architecture behaviour of reset_gen is

begin
    
reset <= '0', '1' after 2 ns;

end architecture behaviour;
    
  
