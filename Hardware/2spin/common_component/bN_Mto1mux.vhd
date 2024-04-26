library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.bus_multiplexer_pkg.all;

-- multiplex M to 1 for std_logic_vector
-- generic for the number of bit 

entity bN_Mto1mux is
	generic (
			N 			: integer := 8;
			M			: integer := 3;
			SEL			: integer := 1
			);
	port	( 
			x			: in bus_array(M-1 downto 0, N-1 downto 0);	
			s			: in std_logic_vector(SEL-1 downto 0);
			output		: out std_logic_vector(N-1 downto 0)
			);
end entity bN_Mto1mux;

architecture behavioural of bN_Mto1mux is

	component bN_2to1mux
		generic (N : positive := 8);
		port	( 
				x		: in std_logic_vector (N-1 downto 0); --0
				y		: in std_logic_vector (N-1 downto 0); --1
				s		: in std_logic;
				output	: out std_logic_vector(N-1 downto 0)
			  );
	end component bN_2to1mux;

	signal out_of_range			: std_logic;
	signal temp					: std_logic_vector(N-1 downto 0);
	signal out_of_range_out		: std_logic_vector(N-1 downto 0);
	
	
	begin
		

		slv_from_slm_row(temp, x, to_integer(unsigned(s)));
		out_of_range_out	<= (others => '0');
		
		p : process(s)
			begin
				if to_integer(unsigned(s)) > (M-1) then
					out_of_range	<= '1';
				else
					out_of_range	<= '0';
				end if;
			end process;
			
		mux_out_of_range : bN_2to1mux
				generic map (
							N		=> N
							)
				port map	( 
							x		=> temp,
							y		=> out_of_range_out,
							s		=> out_of_range,
							output	=> output
							);

		
end architecture behavioural;