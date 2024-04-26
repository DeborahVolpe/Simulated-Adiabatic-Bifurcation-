library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- M level of pipeline
-- register to store std_logic_vector

entity reg_N_level is
	generic	(
			N : positive := 5;
			M : positive := 1 -- pipeline level
			); 
	port	(	
			D       : in std_logic_vector (N-1 downto 0);
			clk     : in std_logic;
			Q       : out std_logic_vector (N-1 downto 0)
			);
end entity reg_N_level;

architecture structure of reg_N_level is

	component reg_s 
		generic	(N : positive := 5); 
		port	(
				D       : in std_logic_vector (N-1 downto 0);
				clk     : in std_logic;
				Q       : out std_logic_vector (N-1 downto 0)
				);
	end component;
	
	type matrix is array ( M downto 0 ) of std_logic_vector ( N-1 downto 0 );
	signal Q_temp : matrix;
	
	begin
	
	Q_temp(0) <= D;
	
	G : for i in 0 to M-1 generate
		r : reg_s
				generic	map	(
							N 		=> N
							)
				port map	(
							D       => Q_temp(i),
							clk     => clk,
							Q       => Q_temp(i+1)
							);
	end generate;
	
	Q <= Q_temp(M);
	
end architecture structure;