library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_textio.all;
use work.bus_multiplexer_pkg.all;

-- multiplex 8 to 1 for std_logic_vector
-- generic for the number of bit 

entity b3_8to1mux is
        port 	(
				x0				: in std_logic_vector(2 downto 0);			
				x1				: in std_logic_vector(2 downto 0);
				x2				: in std_logic_vector(2 downto 0);
				x3				: in std_logic_vector(2 downto 0);
				x4				: in std_logic_vector(2 downto 0);
				x5				: in std_logic_vector(2 downto 0);
				x6				: in std_logic_vector(2 downto 0);
				x7				: in std_logic_vector(2 downto 0);
                sel 			: in std_logic_vector(2 downto 0);
                output 			: out std_logic_vector(2 downto 0)
				);
end entity b3_8to1mux;

architecture structural of b3_8to1mux is

	-- used component
	component bN_Mto1mux 
		generic (
				N 			: positive := 8;
				M			: positive := 3;
				SEL			: positive := 1
				);
		port	( 
				x			: in bus_array(M-1 downto 0, N-1 downto 0);	
				s			: in std_logic_vector(SEL-1 downto 0);
				output		: out std_logic_vector(N-1 downto 0)
				);
	end component bN_Mto1mux;

	signal matrix			: bus_array(7 downto 0, 2 downto 0);
	
	
	
	begin
	
		matrix(0,0) <= x0(0);
		matrix(0,1) <= x0(1);
		matrix(0,2) <= x0(2); 
		matrix(1,0) <= x1(0);
		matrix(1,1) <= x1(1);
		matrix(1,2) <= x1(2); 
		matrix(2,0) <= x2(0);
		matrix(2,1) <= x2(1);
		matrix(2,2) <= x2(2);
		matrix(3,0) <= x3(0);
		matrix(3,1) <= x3(1);
		matrix(3,2) <= x3(2);
		matrix(4,0) <= x4(0);
		matrix(4,1) <= x4(1);
		matrix(4,2) <= x4(2);
		matrix(5,0) <= x5(0);
		matrix(5,1) <= x5(1);
		matrix(5,2) <= x5(2);
		matrix(6,0) <= x6(0);
		matrix(6,1) <= x6(1);
		matrix(6,2) <= x6(2);
		matrix(7,0) <= x7(0);
		matrix(7,1) <= x7(1);
		matrix(7,2) <= x7(2);
		
		mux : bN_Mto1mux 
				generic map	(
							N 			=> 3,
							M			=> 8,
							SEL			=> 3
							)
				port map	( 
							x			=> matrix,	
							s			=> sel,
							output		=> output
							);

       
end architecture structural;