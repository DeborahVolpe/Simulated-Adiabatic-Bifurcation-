library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- bN_mux4to1 is a generic multiplexer with 4 inputs and 1 output. 

entity bN_4to1mux is
	generic	(N : integer := 8);
	port 	(  
			x		: in std_logic_vector (N-1 downto 0); --00
			y		: in std_logic_vector (N-1 downto 0); --01
			z		: in std_logic_vector (N-1 downto 0); --10
			k		: in std_logic_vector (N-1 downto 0); --11
			s		: in std_logic_vector (1 downto 0);
			output	: out std_logic_vector (N-1 downto 0)
			);
end entity bN_4to1mux;

architecture structure of bN_4to1mux is

	component bN_2to1mux is
		generic (N : positive := 8);
		port	( 
				x		: in std_logic_vector (N-1 downto 0);
				y		: in std_logic_vector (N-1 downto 0);
				s		: in std_logic;
				output	: out std_logic_vector(N-1 downto 0)
				);
	end component;
	
	signal u1, u2 			: std_logic_vector (N-1 downto 0);
	
	begin
		
		mux1: bN_2to1mux 
					generic map (
								N 		=> N
								)
					port map	(
								x		=> x,
								y 		=> y, 
								s		=> s(0), 
								output	=> u1
								);
								
		mux2: bN_2to1mux 
					generic map (
								N 		=> N
								)
					port map	(
								x		=> z,
								y 		=> k, 
								s		=> s(0), 
								output	=> u2
								);
								
								
		mux3: bN_2to1mux
					generic map	(
								N 		=> N	
								)
					port map	(
								x 		=> u1,
								y 		=> u2, 
								s		=> s(1), 
								output	=> output
								);

end architecture structure;