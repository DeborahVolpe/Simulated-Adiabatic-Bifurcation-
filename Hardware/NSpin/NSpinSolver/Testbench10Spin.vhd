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
	
	signal data_in									: std_logic_vector(31 downto 0);
	signal X_out									: bus_array(9 downto 0, 31 downto 0);
	signal Y_out									: bus_array(9 downto 0, 31 downto 0);
	signal S										: std_logic_vector(9 downto 0);
	signal X0										: std_logic_vector(31 downto 0);
	signal Y0										: std_logic_vector(31 downto 0);
	signal S0										: std_logic;
	signal X1										: std_logic_vector(31 downto 0);
	signal Y1										: std_logic_vector(31 downto 0);
	signal S1										: std_logic;
	signal X2										: std_logic_vector(31 downto 0);
	signal Y2										: std_logic_vector(31 downto 0);
	signal S2										: std_logic;
	signal X3										: std_logic_vector(31 downto 0);
	signal Y3										: std_logic_vector(31 downto 0);
	signal S3										: std_logic;
	signal X4										: std_logic_vector(31 downto 0);
	signal Y4										: std_logic_vector(31 downto 0);
	signal S4										: std_logic;
	signal X5										: std_logic_vector(31 downto 0);
	signal Y5										: std_logic_vector(31 downto 0);
	signal S5										: std_logic;
	signal X6										: std_logic_vector(31 downto 0);
	signal Y6										: std_logic_vector(31 downto 0);
	signal S6										: std_logic;
	signal X7										: std_logic_vector(31 downto 0);
	signal Y7										: std_logic_vector(31 downto 0);
	signal S7										: std_logic;
	signal X8										: std_logic_vector(31 downto 0);
	signal Y8										: std_logic_vector(31 downto 0);
	signal S8										: std_logic;
	signal X9										: std_logic_vector(31 downto 0);
	signal Y9										: std_logic_vector(31 downto 0);
	signal S9										: std_logic;

	
	begin
	
		DUT : NSpinSolver
					generic map (
		
								INT 					=> 12,
								FRAC 					=> 20,
								M 					    => 4,
								NSPIN 					=> 10,
								N 					    => 7,
								N_ITERATION	 		=> 100
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
		slv_from_slm_row(X0, X_out, 0);
		slv_from_slm_row(Y0, Y_out, 0);
		S0					<= S(0);
		slv_from_slm_row(X1, X_out, 1);
		slv_from_slm_row(Y1, Y_out, 1);
		S1					<= S(1);
		slv_from_slm_row(X2, X_out, 2);
		slv_from_slm_row(Y2, Y_out, 2);
		S2					<= S(2);
		slv_from_slm_row(X3, X_out, 3);
		slv_from_slm_row(Y3, Y_out, 3);
		S3					<= S(3);
		slv_from_slm_row(X4, X_out, 4);
		slv_from_slm_row(Y4, Y_out, 4);
		S4					<= S(4);
		slv_from_slm_row(X5, X_out, 5);
		slv_from_slm_row(Y5, Y_out, 5);
		S5					<= S(5);
		slv_from_slm_row(X6, X_out, 6);
		slv_from_slm_row(Y6, Y_out, 6);
		S6					<= S(6);
		slv_from_slm_row(X7, X_out, 7);
		slv_from_slm_row(Y7, Y_out, 7);
		S7					<= S(7);
		slv_from_slm_row(X8, X_out, 8);
		slv_from_slm_row(Y8, Y_out, 8);
		S8					<= S(8);
		slv_from_slm_row(X9, X_out, 9);
		slv_from_slm_row(Y9, Y_out, 9);
		S9					<= S(9);
								
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
			
									variable data_in_v 			: std_logic_vector(31 downto 0);
									begin
									file_open(ParamFileRandom, "resultsMaxCut1/Problem_10_y_init_variables.txt", read_mode);
									file_open(file_outputS, "resultsMaxCut1/output_file_10.txt", write_mode);
									file_open(file_output_X_Y, "resultsMaxCut1/output_file_X_Y_10.txt", write_mode);
									while i < 100 loop
										start <= '0';
										reset <= '0';
										wait for 12 ns;
										reset <= '1';
										wait for 12 ns;
										start <= '1';
										wait for 10 ns;
										start <= '0';
										k := 0;
								
										file_open(ParamFile, "resultsMaxCut1/InputParameter_10.txt", read_mode);
								
									while not endfile(ParamFile) loop
										-- read the parameters
										-- We read in order the following parameters:
										-- ShapePt, Delta4K, K_1, offset, Delta, xi
										-- deltaT, HVector0, HVector1, J12, J21, YOld
										if k = 16 then
											readline(ParamFileRandom, v_ILINEYR);
											read(v_ILINEYR, y);
											read(v_ILINEYR, space);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
											read(v_ILINEYR, y);
											read(v_ILINEYR, space);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
											read(v_ILINEYR, y);
											read(v_ILINEYR, space);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
											read(v_ILINEYR, y);
											read(v_ILINEYR, space);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
											read(v_ILINEYR, y);
											read(v_ILINEYR, space);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
											read(v_ILINEYR, y);
											read(v_ILINEYR, space);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
											read(v_ILINEYR, y);
											read(v_ILINEYR, space);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
											read(v_ILINEYR, y);
											read(v_ILINEYR, space);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
											read(v_ILINEYR, y);
											read(v_ILINEYR, space);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
											read(v_ILINEYR, y);
											data_in <= std_logic_vector(to_signed(y, 32));
											wait for 10 ns;
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
										write(v_OLINE_X_Y, X6);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, X7);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, X8);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, X9);
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
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y6);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y7);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y8);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y9);
										writeline(file_output_X_Y, v_OLINE_X_Y);
									
									end loop;
					
	
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
									write(v_OLINE, ' ');
									write(v_OLINE, S6);
									write(v_OLINE, ' ');
									write(v_OLINE, S7);
									write(v_OLINE, ' ');
									write(v_OLINE, S8);
									write(v_OLINE, ' ');
									write(v_OLINE, S9);
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
