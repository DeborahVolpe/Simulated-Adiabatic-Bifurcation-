library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Testbench Processor Adiabatic Bifurcation

entity testbench is
end entity testbench;

architecture test of testbench is

	component SumNSpins
		generic	(
				INT 	: positive := 3;
				FRAC	: positive := 9;
				M		: positive := 2; -- Address lenght
				NSPIN	: positive := 3 -- Number of Spin
				);
		port	(
				clk  					:	in std_logic;
				reset					:	in std_logic;
				start_sample			:	in std_logic;
				start					:	in std_logic;
				NewIteration			:	in std_logic;
				LastIteration			:	in std_logic;
				J_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
				x1_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
				x2_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
				done					: 	out std_logic;
				SumReady				:	out std_logic;
				SumFinal				:	out std_logic_vector(INT+FRAC-1 downto 0);
				xSel					:	out std_logic_vector(M-1 downto 0)
				);
	end component SumNSpins;

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
		
	file ParamFile, XFile, file_outputSum	: text;
	signal clk								: std_logic;
	signal reset							: std_logic;
	signal start_sample0					: std_logic;
	signal start0							: std_logic;
	signal NewIteration0					: std_logic;
	signal LastIteration0					: std_logic;
	signal J0								: std_logic_vector(13 downto 0);
	signal x1_in0							: std_logic_vector(13 downto 0);
	signal x2_in0							: std_logic_vector(13 downto 0);
	signal done0							: std_logic;
	signal SumReady0						: std_logic;
	signal SumFinal0						: std_logic_vector(13 downto 0);
	signal xSel0							: std_logic_vector(0 downto 0);
	signal start_sample1					: std_logic;
	signal start1							: std_logic;
	signal NewIteration1					: std_logic;
	signal LastIteration1					: std_logic;
	signal J1								: std_logic_vector(13 downto 0);
	signal x1_in1							: std_logic_vector(13 downto 0);
	signal x2_in1							: std_logic_vector(13 downto 0);
	signal done1							: std_logic;
	signal SumReady1						: std_logic;
	signal SumFinal1						: std_logic_vector(13 downto 0);
	signal xSel1							: std_logic_vector(0 downto 0);
	signal start_sample2					: std_logic;
	signal start2							: std_logic;
	signal NewIteration2					: std_logic;
	signal LastIteration2					: std_logic;
	signal J2								: std_logic_vector(13 downto 0);
	signal x1_in2							: std_logic_vector(13 downto 0);
	signal x2_in2							: std_logic_vector(13 downto 0);
	signal done2							: std_logic;
	signal SumReady2						: std_logic;
	signal SumFinal2						: std_logic_vector(13 downto 0);
	signal xSel2							: std_logic_vector(0 downto 0);
	signal SumReady							: std_logic;
	
	
	begin
	
	
		DUT0 : SumNSpins
					generic map	(
								INT 					=> 5,
								FRAC					=> 9,
								M						=> 2,
								NSPIN					=> 3
								)
					port map	(
								clk  					=> clk,
								reset					=> reset,
								start_sample			=> start_sample0,
								start					=> start0,
								NewIteration			=> NewIteration0,
								LastIteration			=> LastIteration0,
								J_in					=> J0,
								x1_in					=> x1_in0,
								x2_in					=> x2_in0,
								done					=> done0,
								SumReady				=> SumReady0,
								SumFinal				=> SumFinal0,
								xSel					=> xSel0
								);
							
							
		DUT1 : SumNSpins
					generic map	(
								INT 					=> 5,
								FRAC					=> 9,
								M						=> 2,
								NSPIN					=> 3
								)
					port map	(
								clk  					=> clk,
								reset					=> reset,
								start_sample			=> start_sample1,
								start					=> start1,
								NewIteration			=> NewIteration1,
								LastIteration			=> LastIteration1,
								J_in					=> J1,
								x1_in					=> x1_in1,
								x2_in					=> x2_in1,
								done					=> done1,
								SumReady				=> SumReady1,
								SumFinal				=> SumFinal1,
								xSel					=> xSel1
								);
							
							
		DUT2 : SumNSpins
					generic map	(
								INT 					=> 5,
								FRAC					=> 9,
								M						=> 2,
								NSPIN					=> 3
								)
					port map	(
								clk  					=> clk,
								reset					=> reset,
								start_sample			=> start_sample2,
								start					=> start2,
								NewIteration			=> NewIteration2,
								LastIteration			=> LastIteration2,
								J_in					=> J2,
								x1_in					=> x1_in2,
								x2_in					=> x2_in2,
								done					=> done2,
								SumReady				=> SumReady2,
								SumFinal				=> SumFinal2,
								xSel					=> xSel2
								);
		
		SumReady		<= SumReady0 and SumReady1 and SumReady2;
								
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
									variable v_ILINEX    		: line;
									variable v_OLINE    		: line;
									variable v_SPACE    		: character;
									variable J0_v, J1_v, J2_v 	: std_logic_vector(13 downto 0);
									variable x0_v, x1_v, x2_v	: std_logic_vector(13 downto 0);
									
								 begin
									-- open input and output file
									file_open(ParamFile, "InputParameter.txt", read_mode);
									file_open(XFile, "InputX.txt", read_mode);
									
									start0	<= '0';
									start1	<= '0';
									start2	<= '0';
									
									-- read the parameters
									-- The file format is the follow:
									-- J12 + J21
									start_sample0	<= '1';
									wait for 10 ns;
									readline(ParamFile, v_ILINEP);
									read(v_ILINEP, J0_v);

									J0		<= J0_v;
									
									wait for 10 ns;
									readline(ParamFile, v_ILINEP);
									read(v_ILINEP, J0_v);
									
									J0		<= J0_v;
									start_sample0	<= '0';

									start_sample1	<= '1';
									wait for 10 ns;
									readline(ParamFile, v_ILINEP);
									read(v_ILINEP, J1_v);

									J1		<= J1_v;
									
									wait for 10 ns;
									readline(ParamFile, v_ILINEP);
									read(v_ILINEP, J1_v);
									
									J1		<= J1_v;
									start_sample1	<= '0';
									
									
									start_sample2	<= '1';
									wait for 10 ns;
									readline(ParamFile, v_ILINEP);
									read(v_ILINEP, J2_v);

									J2		<= J2_v;
									
									wait for 10 ns;
									readline(ParamFile, v_ILINEP);
									read(v_ILINEP, J2_v);
									
									J2		<= J2_v;
									start_sample2 <= '0';
									
									wait for 10 ns;
									start0	<= '1';
									start1	<= '1';
									start2	<= '1';

				
									file_close(ParamFile);

									LastIteration0 <= '0';
									LastIteration1 <= '0';
									LastIteration2 <= '0';
								   
									file_open(file_outputSum, "output_file.txt", write_mode);
								   while not endfile(XFile) loop
									-- read the parameters
									-- The file format is the follow:
									-- x0, x1, x2
										readline(XFile, v_ILINEX);
										read(v_ILINEX, x0_v);
										read(v_ILINEX, v_SPACE);
										read(v_ILINEX, x1_v);
										read(v_ILINEX, v_SPACE);
										read(v_ILINEX, x2_v);
										
										x1_in0		<=	x1_v;
										x2_in0		<=	x2_v;
										
										x1_in1		<= 	x0_v;
										x2_in1		<=	x2_v;
										
										x1_in2		<= x0_v;
										x2_in2		<= x1_v;
								
										NewIteration0 <= '1';
										NewIteration1 <= '1';
										NewIteration2 <= '1';
										wait for 10 ns; -- wait for one clock period
										start0	<= 	'0';
										start1	<= 	'0';
										start2	<=	'0';
										NewIteration0 <= '0';
										NewIteration1 <= '0';
										NewIteration2 <= '0';
								
									  
										wait until SumReady = '1';
										wait for 11 ns; -- wait for one clock period
										write(v_OLINE, SumFinal0);
										write(v_OLINE, ' ');
										write(v_OLINE, SumFinal1);
										write(v_OLINE, ' ');
										write(v_OLINE, SumFinal2);
										writeline(file_outputSum, v_OLINE);	
								 end loop;
								
								 --close all file
								 file_close(XFile);
								 file_close(file_outputSum);
									
							   wait;
							end process;
		
	
	
	
end architecture test;