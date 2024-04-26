library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Testbench Processor Adiabatic Bifurcation

entity testbench is
end entity testbench;

architecture test of testbench is

	component ProcessorAdiabatic
		generic(
				INT 	: positive := 3;
				FRAC	: positive := 9
				);
		port(
			clk  				:	in std_logic;
			reset				: 	in std_logic;
			start				:	in std_logic;
			SumReady			: 	in std_logic;
			NewIteration		:	in std_logic;
			LastIteration		:	in std_logic;
			A0					:	in std_logic_vector((INT+FRAC)-1 downto 0);
			p					:	in std_logic_vector((INT+FRAC)-1 downto 0);
			K					:	in std_logic_vector((INT+FRAC)-1 downto 0);
			Delta				: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			deltaT				:	in std_logic_vector((INT+FRAC)-1 downto 0);
			sum					:	in std_logic_vector((INT+FRAC)-1 downto 0);
			hVectori			:	in std_logic_vector((INT+FRAC)-1 downto 0);
			xOld_in				:	in std_logic_vector((INT+FRAC)-1 downto 0);
			yOld_in				:	in std_logic_vector((INT+FRAC)-1 downto 0);
			xNew				:	out std_logic_vector((INT+FRAC)-1 downto 0);
			yNew				:	out std_logic_vector((INT+FRAC)-1 downto 0);
			xReady				: 	out std_logic;
			yReady				:	out std_logic;
			done				:	out std_logic
			);
	end component ProcessorAdiabatic;
	
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
		
	file ParamFile, SumFile, PA0File, file_outputX_Y: text;
	signal clk					: std_logic;
	signal reset				: std_logic;
	signal start				: std_logic;
	signal NewIteration			: std_logic;
	signal LastIteration		: std_logic;
	signal SumReady				: std_logic;
	signal A0					: std_logic_vector(15 downto 0);
	signal p					: std_logic_vector(15 downto 0);
	signal K					: std_logic_vector(15 downto 0);
	signal Delta				: std_logic_vector(15 downto 0);
	signal deltaT				: std_logic_vector(15 downto 0);
	signal sum					: std_logic_vector(15 downto 0);
	signal hVectori				: std_logic_vector(15 downto 0);
	signal xOld_in				: std_logic_vector(15 downto 0);
	signal yOld_in				: std_logic_vector(15 downto 0);
	signal xNew					: std_logic_vector(15 downto 0);
	signal yNew					: std_logic_vector(15 downto 0);
	signal xReady				: std_logic;
	signal yReady				: std_logic;
	signal done					: std_logic;
	
	
	begin
	
		DUT : ProcessorAdiabatic
					generic map(
								INT					=> 7,
								FRAC				=> 9
								)
					port map	(
								clk  				=> clk,
								reset				=> reset,
								start				=> start,
								SumReady			=> SumReady,
								NewIteration		=> NewIteration,
								LastIteration		=> LastIteration,
								A0					=> A0,
								p					=> p,
								K					=> K,
								Delta				=> Delta,
								deltaT				=> deltaT,
								sum					=> sum,
								hVectori			=> hVectori,
								xOld_in				=> xOld_in,
								yOld_in				=> yOld_in,
								xNew				=> xNew,
								yNew				=> yNew,
								xReady				=> xReady,
								yReady				=> yReady,
								done				=> done
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
									variable v_ILINES    		: line;
									variable v_ILINEPA0 		: line;
									variable v_OLINE    		: line;
									variable v_SPACE    		: character;
									variable K_v, Delta_v  		: std_logic_vector(15 downto 0);
									variable deltaT_v, sum_v	: std_logic_vector(15 downto 0);
									variable hVectori_v			: std_logic_vector(15 downto 0);
									variable xOld_v, yOld_v		: std_logic_vector(15 downto 0);
									variable p_v, A0_v			: std_logic_vector(15 downto 0);
									
								 begin
									-- open input and output file
									file_open(ParamFile, "InputParameter.txt", read_mode);
									file_open(SumFile, "InputSum.txt", read_mode);
									file_open(PA0File, "InputPA0.txt", read_mode);
									file_open(file_outputX_Y, "output_file.txt", write_mode);
									
									-- read the parameters
									-- The file format is the follow:
									-- K + Delta + deltaT + xi + HVector + x + y
									readline(ParamFile, v_ILINEP);
									read(v_ILINEP, K_v);
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, Delta_v);
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, deltaT_v);
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, hVectori_v);	
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, xOld_v);	
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, yOld_v);		


									K			<=	K_v;	
									Delta		<= 	Delta_v;
									deltaT		<=	deltaT_v;		
									hVectori	<= 	hVectori_v;
									xOld_in		<= 	xOld_v;
									yOld_in		<= 	yOld_v;	

									file_close(ParamFile);

									LastIteration <= '0';
								   

								   while not endfile(PA0File) loop
									-- read the parameters
									-- The file format is the follow:
									-- p + A0
										readline(PA0File, v_ILINEPA0);
										read(v_ILINEPA0, p_v);
										read(v_ILINEPA0, v_SPACE);
										read(v_ILINEPA0, A0_v);
										p 	<= p_v;
										A0	<= A0_v;
							
										SumReady <= '0';
										start <= '1';
										NewIteration <= '1';
										wait for 10 ns; -- wait for one clock period
										start <= '0';
										NewIteration <= '0';						
									  
										wait until xReady = '1';
										wait for 11 ns; -- wait for one clock period
										write(v_OLINE, xNew);
										
										-- read the parameters
										-- The file format is the follow:
										-- sum
										readline(SumFile, v_ILINES);
										read(v_ILINES, sum_v);
										sum	<= sum_v; 
										SumReady <= '1';
										
										
										wait until yReady = '1';
										SumReady <= '0';
										wait for 8 ns; -- wait for onr clock period
										write(v_OLINE, ' ');
										write(v_OLINE, yNew);
										writeline(file_outputX_Y, v_OLINE);
									   
								 end loop;
								
								 --close all file
								 file_close(SumFile);
								 file_close(PA0File);
								 file_close(file_outputX_Y);
									
							   wait;
							end process;
		
	
	
	
end architecture test;