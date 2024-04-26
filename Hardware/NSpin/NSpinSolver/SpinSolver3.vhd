library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.bus_multiplexer_pkg.all;

entity SpinSolver3 is
	port(
		clk				: in std_logic;
		reset			: in std_logic;
		start			: in std_logic;
		Data_in			: in std_logic_vector(21 downto 0);
		done			: out std_logic;
		xReady			: out std_logic;
		yReady			: out std_logic;
		S				: out std_logic_vector(2 downto 0);
		X_out			: out bus_array(2 downto 0, 21 downto 0);	
		Y_out			: out bus_array(2 downto 0, 21 downto 0)
		);
end entity SpinSolver3;

architecture Structure of SpinSolver3 is

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
								FRAC					=> 11, 
								M						=> 2, 
								NSPIN					=> 3,
								N						=> 11, 
								N_ITERATION				=> 2000
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