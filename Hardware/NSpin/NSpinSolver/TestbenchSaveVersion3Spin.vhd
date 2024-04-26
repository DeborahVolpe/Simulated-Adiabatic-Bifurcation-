library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Testbench Processor Adiabatic Bifurcation

entity testbench is
end entity testbench;

architecture test of testbench is

	component SpinMachine3
		port	(
				clk							:	in std_logic;
				reset						:	in std_logic;
				start						:	in std_logic;
				S0							: 	out std_logic;
				S1							:	out std_logic;
				S2							:	out std_logic;
				done						:	out std_logic;
				start_out					:	out std_logic
				);
	end component SpinMachine3;
	
	component clock_gen 
		port ( 
			  clk   : out std_logic
			  );
	end component clock_gen;
	
	component reset_gen
		port ( 
			  reset  : out std_logic
			  );
	end component;
		
	signal clk										: std_logic;
	signal reset									: std_logic;
	signal reset_in									: std_logic;
	signal start									: std_logic;
	signal S0										: std_logic;
	signal S1										: std_logic;
	signal S2                                       : std_logic;
	signal done										: std_logic;
	signal start_out								: std_logic;
	
	
	begin
	
		DUT : SpinMachine3
				port map	(
							clk							=> clk, 
							reset						=> reset, 
							start						=> start, 
							S0							=> S0, 
							S1							=> S1, 
							S2							=> S2, 
							done						=> done, 
							start_out					=> start_out
							);
								
								
		clkGen: clock_gen 
					port  map	( 
								clk					=> clk
								);
								
		rstGen: reset_gen
					port map	( 
								reset				=> reset_in
								);
							
		start		<= '0', '1' after 30 ns, '0' after 50 ns;
		reset           <= not(reset_in);
end architecture test;