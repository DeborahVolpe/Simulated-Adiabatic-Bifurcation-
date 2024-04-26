library ieee;
use ieee.std_logic_1164.all;

entity clock_gen is
	port ( 
		  clk   : out std_logic
		  );
end entity clock_gen;

architecture behaviour of clock_gen is
	signal clock 	: std_logic;
	constant T: time:= 10 ns;

	begin
		
		clk_process: process
		begin
		  clock <= '0';
		  wait for(T/2);
		  clock <= '1';
		  wait for (T/2);
		end process;
			
		clk <= clock;

end architecture behaviour;
    
  
  
      