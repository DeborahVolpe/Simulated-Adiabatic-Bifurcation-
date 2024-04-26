library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.all;
use work.bus_multiplexer_pkg.all;

-- Testbench Processor Adiabatic Bifurcation

entity tb is
end entity tb;

architecture test of tb is

	component NSpinSolver is
		generic	(
				INT 					: integer := 5;
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
	
	component clock_gen 
		port ( 
			  clk   : out std_logic
			  );
	end component clock_gen;
	
	
	file ParamFile, file_outputS, file_output_X_Y	: text;
	file ParamFileRandom							: text;
	signal clk										: std_logic;
	signal reset									: std_logic;
	signal start									: std_logic;
	signal done										: std_logic;
	signal xReady									: std_logic;
	signal yReady									: std_logic;
	
______________________________________________

	
	begin
	
		DUT : NSpinSolver
					generic map (
		
_________________________________________________
								)
					port map	(
								clk						=> clk,
								reset					=> reset,
								start					=> start,
								Data_in					=> data_in,
								done					=> done, 
								xReady					=> xReady,
								yReady					=> yReady,
								S						=> S, 
								X_out					=> X_out,
								Y_out					=> Y_out
								);
___________________________________________________								
								
		clkGen: clock_gen 
					port  map	( 
								clk					=> clk
								);
								
							
		read_files_process: process
									variable v_ILINEP    		: line;
									variable v_ILINEYR    		: line;
									variable v_OLINE    		: line;
									variable v_OLINE_X_Y    	: line;
									variable i 					: integer := 0;
									variable k 					: integer := 0;
									variable y 					: integer := 0;
									variable space 				: character;
			
_____________________________________________________________
										start <= '0';
										reset <= '0';
										wait for 12 ns;
										reset <= '1';
										wait for 12 ns;
										start <= '1';
										wait for 10 ns;
										start <= '0';
										k := 0;
								
__________________________________________________
								
									while not endfile(ParamFile) loop
										-- read the parameters
										-- We read in order the following parameters:
										-- ShapePt, Delta4K, K_1, offset, Delta, xi
										-- deltaT, HVector0, HVector1, J12, J21, YOld
__________________________________________________________________________________									
											readline(ParamFileRandom, v_ILINEYR);
_____________________________________________________________________________________											
										else
											readline(ParamFile, v_ILINEP);
											read(v_ILINEP, data_in_v);
											data_in <= data_in_v;
											wait for 10 ns;
										end if;
										k:= k+1;
										
									end loop;
									--close parameters file
									file_close(ParamFile);
									loop
										wait until xReady = '1' or done ='1';
										if done = '1' then
											exit;
										end if;
										wait for 12 ns;
___________________________________________________
										wait until yReady = '1';
										wait for 8 ns;
_______________________________________________										
										writeline(file_output_X_Y, v_OLINE_X_Y);
									
									end loop;
					
	
									wait for 11 ns; -- wait for one clock period	
______________________________________________________________________
									writeline(file_outputS, v_OLINE);
									write(v_OLINE_X_Y, '_');
									writeline(file_output_X_Y, v_OLINE_X_Y);
									i:=i+1;
									end loop;
									--close output file
									file_close(file_outputS);
									file_close(file_output_X_Y);	
									file_close(ParamFileRandom);
									wait;
							end process;
end architecture test;
____________________________________________________