library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Testbench Processor Adiabatic Bifurcation

entity testbench is
end entity testbench;

architecture test of testbench is

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
	signal data_in									: std_logic_vector(13 downto 0);
	signal S0										: std_logic;
	signal S1										: std_logic;
	signal done										: std_logic;
	signal X0R										: std_logic;
	signal Y0R										: std_logic;
	signal X1R										: std_logic;
	signal Y1R										: std_logic;
	signal X0										: std_logic_vector(13 downto 0);
	signal Y0										: std_logic_vector(13 downto 0);
	signal X1										: std_logic_vector(13 downto 0);
	signal Y1										: std_logic_vector(13 downto 0);
	
	
	begin
	
		DUT : SimulatedBifurcation2Spins
					generic	map (
								INT 				=> 5,
								FRAC				=> 9,
								N					=> 8 -- 2**8 iteration				
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
									variable data_in_v 			: std_logic_vector(13 downto 0);
									
								 begin
								 
									start <= '0';
									wait for 2 ns; -- reset active in this region
									-- open input and output file
									file_open(ParamFile, "InputParameter.txt", read_mode);
									file_open(file_outputS, "output_file.txt", write_mode);
									file_open(file_output_X_Y, "output_file_X_Y.txt", write_mode);
									
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
									
									--close parameters file
									file_close(ParamFile);
									
									while done = '0' loop
										wait until X0R = '1';
										wait for 11 ns;
										write(v_OLINE_X_Y, X0);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, X1);
										write(v_OLINE_X_Y, ' ');
										
										wait until Y0R = '1';
										wait for 8 ns;
										write(v_OLINE_X_Y, Y0);
										write(v_OLINE_X_Y, ' ');
										write(v_OLINE_X_Y, Y1);
										write(v_OLINE_X_Y, ' ');
										writeline(file_output_X_Y, v_OLINE_X_Y);
									
									end loop;
					
									file_close(file_output_X_Y);
						
									  
									wait for 11 ns; -- wait for one clock period
									write(v_OLINE, S0);
									write(v_OLINE, ' ');
									write(v_OLINE, S1);
									writeline(file_outputS, v_OLINE);
								
									--close output file
									file_close(file_outputS);		
							   wait;
							end process;
end architecture test;