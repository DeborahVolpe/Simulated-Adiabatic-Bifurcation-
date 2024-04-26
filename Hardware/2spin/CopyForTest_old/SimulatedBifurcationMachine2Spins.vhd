library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimulatedBifurcationMachine2Spins is
	port	(
			clk							:	in std_logic;
			reset						:	in std_logic;
			start						:	in std_logic;
			data_in						:	in std_logic_vector(28 downto 0);
			S0							: 	out std_logic;
			S1							:	out std_logic;
			done						:	out std_logic;
			X0R							:	out std_logic;
			Y0R							:	out std_logic;
			X1R							: 	out std_logic;
			Y1R							:	out std_logic;
			X0							:	out std_logic_vector(28 downto 0);
			Y0							:	out std_logic_vector(28 downto 0);
			X1							: 	out std_logic_vector(28 downto 0);
			Y1							: 	out std_logic_vector(28 downto 0)
			);
end entity SimulatedBifurcationMachine2Spins;

architecture Structure of SimulatedBifurcationMachine2Spins is 

	component SimulatedBifurcation2Spins
		generic	(
				INT 						: positive := 3;
				FRAC						: positive := 9;
				N							: positive := 20 -- 2^N number of iteration
				);
		port	(
				clk							:	in std_logic;
				reset						:	in std_logic;
				start						:	in std_logic;
				data_in						:	in std_logic_vector((INT+FRAC)-1 downto 0);
				S0							: 	out std_logic;
				S1							:	out std_logic;
				done						:	out std_logic;
				X0R							:	out std_logic;
				Y0R							:	out std_logic;
				X1R							: 	out std_logic;
				Y1R							:	out std_logic;
				X0							:	out std_logic_vector((INT+FRAC)-1 downto 0);
				Y0							:	out std_logic_vector((INT+FRAC)-1 downto 0);
				X1							: 	out std_logic_vector((INT+FRAC)-1 downto 0);
				Y1							: 	out std_logic_vector((INT+FRAC)-1 downto 0)
				);
	end component SimulatedBifurcation2Spins;
	
	
	begin
	
		DUT : SimulatedBifurcation2Spins
					generic	map (
								INT 				=> 20,
								FRAC				=> 9,
								N					=> 10 -- 2**10 iteration				
								)
					port map	(
								clk					=> clk,									
								reset				=> reset,
								start				=> start,
								data_in				=> data_in,
								S0					=> S0,
								S1					=> S1,
								done				=> done,
								X0R					=> X0R,
								Y0R					=> Y0R,
								X1R					=> X1R,
								Y1R					=> Y1R,
								X0					=> X0,
								Y0					=> Y0,
								X1					=> X1,
								Y1					=> Y1
								);


end architecture Structure;