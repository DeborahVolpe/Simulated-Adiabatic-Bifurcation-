library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.all;
use work.bus_multiplexer_pkg.all;

-- Testbench Processor Adiabatic Bifurcation

entity testbench is
end entity testbench;

architecture test of testbench is

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
		
	file ParamFile, file_outputS, file_output_X_Y	: text;
	signal clk										: std_logic;
	signal reset									: std_logic;
	signal start									: std_logic;
	signal Data_in									: std_logic_vector(19 downto 0);
	signal done										: std_logic;
	signal xReady									: std_logic;
	signal yReady									: std_logic;
	signal S										: std_logic_vector(5 downto 0);
	signal X_out									: bus_array(5 downto 0, 19 downto 0);
	signal Y_out									: bus_array(5 downto 0, 19 downto 0);
	signal X0										: std_logic_vector(19 downto 0);
	signal X1										: std_logic_vector(19 downto 0);
	signal X2										: std_logic_vector(19 downto 0);
	signal X3										: std_logic_vector(19 downto 0);
	signal X4										: std_logic_vector(19 downto 0);
	signal X5										: std_logic_vector(19 downto 0);
	signal Y0										: std_logic_vector(19 downto 0);
	signal Y1 										: std_logic_vector(19 downto 0);
	signal Y2										: std_logic_vector(19 downto 0);
	signal Y3										: std_logic_vector(19 downto 0);	
	signal Y4										: std_logic_vector(19 downto 0);
	signal Y5										: std_logic_vector(19 downto 0);
	signal S0										: std_logic;
	signal S1										: std_logic;
	signal S2										: std_logic;
	signal S3										: std_logic;
	signal S4										: std_logic;
	signal S5										: std_logic;
	
	
	
	begin
	
		DUT : NSpinSolver
					generic map (
								INT 					=> 11, 
								FRAC					=> 9, 
								M						=> 3, 
								NSPIN					=> 6,
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
								
		slv_from_slm_row(X0, X_out, 0);
		slv_from_slm_row(X1, X_out, 1);
		slv_from_slm_row(X2, X_out, 2);
		slv_from_slm_row(X3, X_out, 3);
		slv_from_slm_row(X4, X_out, 4);
		slv_from_slm_row(X5, X_out, 5);
		slv_from_slm_row(Y0, Y_out, 0);
		slv_from_slm_row(Y1, Y_out, 1);
		slv_from_slm_row(Y2, Y_out, 2);
		slv_from_slm_row(Y3, Y_out, 3);
		slv_from_slm_row(Y4, Y_out, 4);
		slv_from_slm_row(Y5, Y_out, 5);
		
		S0					<= S(0);
		S1 					<= S(1);
		S2					<= S(2);
		S3					<= S(3);
		S4					<= S(4);
		S5					<= S(5);
								
		clkGen: clock_gen 
					port  map	( 
								clk					=> clk
								);
								
		rstGen: reset_gen
					port map	( 
								reset				=> reset
								);
							
		read_files_process: process
									variable v_ILINEP    		: line;
									variable v_OLINE    		: line;
									variable v_OLINE_X_Y    	: line;
									variable data_in_v 			: std_logic_vector(19 downto 0);
									
								 begin
								 
									start <= '0';
									wait for 2 ns; -- reset active in this region
									-- open input and output file
									file_open(ParamFile, "InputParameter6.txt", read_mode);
									file_open(file_outputS, "output_file6.txt", write_mode);
									file_open(file_output_X_Y, "output_file_X_Y6.txt", write_mode);
									
									start <= '1';
									wait for 10 ns; -- wait for one clock period
									start <= '0';	
				
									while not endfile(ParamFile) loop
										-- read the parameters
										-- We read in order the following parameters:
										-- ShapePt, Delta4K, K_1, offset, Delta, xi
										-- deltaT, HVector0, HVector1, J12, J21, YOld
										readline(ParamFile, v_ILINEP);
										read(v_ILINEP, data_in_v);
										data_in <= data_in_v;
										
										wait for 10 ns;
										
									end loop;
									
									--close parameters file
									file_close(ParamFile);
									
									while done = '0' loop
										wait until xReady = '1';
										wait for 11 ns;
										write(v_OLINE_X_Y, X0);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, X1);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, X2);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, X3);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, X4);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, X5);
										write(v_OLINE_X_Y, ' ');
										
										wait until yReady = '1';
										wait for 8 ns;
										write(v_OLINE_X_Y, Y0);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y1);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y2);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y3);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y4);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y5);
										writeline(file_output_X_Y, v_OLINE_X_Y);
									
									end loop;
					
									file_close(file_output_X_Y);	
	
									wait for 11 ns; -- wait for one clock period
									write(v_OLINE, S0);
									write(v_OLINE, ' ');
									write(v_OLINE, S1);
									write(v_OLINE, ' ');
									write(v_OLINE, S2);
									write(v_OLINE, ' ');
									write(v_OLINE, S3);
									write(v_OLINE, ' ');
									write(v_OLINE, S4);
									write(v_OLINE, ' ');
									write(v_OLINE, S5);
									writeline(file_outputS, v_OLINE);
								
									--close output file
									file_close(file_outputS);		
							   wait;
							end process;
end architecture test;