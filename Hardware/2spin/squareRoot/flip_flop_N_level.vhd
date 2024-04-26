library ieee;
use ieee.std_logic_1164.all;

-- N level of flip flop to store std_logic
-- the reset in this block is synchronous

entity flip_flop_N_level is
	generic	(
			N 		: positive := 32
			);
	port	(
			D   	: in std_logic;
			clk 	: in std_logic;
			Q  		: buffer std_logic_vector ( N-1 downto 0) -- output of all flip flop 
			);
end entity flip_flop_N_level;

architecture structure of flip_flop_N_level  is

	component flipflop_s 
		port	(
				D   	: in std_logic;
				clk 	: in std_logic;
				Q   	: out std_logic
				);
	end component flipflop_s;

	begin
	
	FD_0 :	flipflop_s port map	(
								D   	=> D, 
								clk 	=> clk,
								Q   	=> Q(0)
								);
								
	G : for i in 1 to N-1 generate
		FD : 	flipflop_s port map	(
									D   	=> Q(i-1), 
									clk 	=> clk,
									Q   	=> Q(i)
									);
	end generate;
	
end architecture structure;
	
		
