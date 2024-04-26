library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.bus_multiplexer_pkg.all;

entity SimulatedBifurcationMachine5Spin is
	port	(
			clk						: in std_logic;
			reset					: in std_logic;
			start					: in std_logic;
			Data_in					: in std_logic_vector(19 downto 0);
			done					: out std_logic;
			xReady					: out std_logic;
			yReady					: out std_logic;
			S						: out std_logic_vector(4 downto 0);
			X_out					: out bus_array(4 downto 0, 19 downto 0);	
			Y_out					: out bus_array(4 downto 0, 19 downto 0)
			);
end entity SimulatedBifurcationMachine5Spin;

architecture Structure of SimulatedBifurcationMachine5Spin is

	component NSpinSolver
		generic	(
				INT 					: integer := 3;
				FRAC					: integer := 9;
				M						: integer := 2; -- Address lenght
				NSPIN					: integer := 3; -- Number of Spin
				N						: integer := 20; --Bits for iteration
				N_ITERATION				: integer := 1000 -- Number of iteration
				);
		port	(
				clk						: in std_logic;
				reset					: in std_logic;
				start					: in std_logic;
				Data_in					: in std_logic_vector(INT+FRAC-1 downto 0);
				done					: out std_logic;
				xReady					: out std_logic;
				yReady					: out std_logic;
				S						: out std_logic_vector(NSPIN-1 downto 0);
				X_out					: out bus_array(NSPIN-1 downto 0, INT+FRAC-1 downto 0);	
				Y_out					: out bus_array(NSPIN-1 downto 0, INT+FRAC-1 downto 0)
				);
	end component NSpinSolver;
	
	begin
	
		comp : NSpinSolver
					generic map (
								INT 					=> 11, 
								FRAC					=> 9, 
								M						=> 3, 
								NSPIN					=> 5,
								N						=> 9, 
								N_ITERATION				=> 300
								)
					port map	(
								clk						=> clk,
								reset					=> reset,
								start					=> start,
								Data_in					=> Data_in,
								done					=> done, 
								xReady					=> xReady,
								yReady					=> yReady,
								S						=> S, 
								X_out					=> X_out,
								Y_out					=> Y_out
								);
end architecture Structure;