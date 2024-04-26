library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Testbench Processor Adiabatic Bifurcation

entity testbench is
end entity testbench;

architecture test of testbench is

	component Sum2Spins
		generic(
				INT 	: positive := 3;
				FRAC	: positive := 9
				);
		port	(
				clk  					:	in std_logic;
				reset					: 	in std_logic;		
				start					: 	in std_logic;
				NewIteration			: 	in std_logic; -- Equal to one when the overall system is ready to start a new iteration
				LastIteration			:	in std_logic; -- Equal to one if the considered iteration is the last one			
				J12_xi					:	in std_logic_vector(INT+FRAC-1 downto 0);
				J21_xi					: 	in std_logic_vector(INT+FRAC-1 downto 0);
				X0						:	in std_logic_vector(INT+FRAC-1 downto 0);
				X1						:	in std_logic_vector(INT+FRAC-1 downto 0);
				SumsReady				:	out std_logic;
				Sum0 					:	out std_logic_vector(INT+FRAC-1 downto 0);
				Sum1					:	out std_logic_vector(INT+FRAC-1 downto 0)
				);
	end component Sum2Spins;

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
		
	file ParamFile, XFile, file_outputSum: text;
	
	signal clk, reset, start						: std_logic;
	signal NewIteration, LastIteration				: std_logic;
	signal SumsReady								: std_logic;
	signal J12, J21									: std_logic_vector(19 downto 0);
	signal X0, X1									: std_logic_vector(19 downto 0); 
	signal Sum0										: std_logic_vector(19 downto 0);
	signal Sum1										: std_logic_vector(19 downto 0);
	
	
	begin
	
		DUT : Sum2Spins
					generic map (
								INT 					=> 5,
								FRAC					=> 15
								)
					port map	(
								clk  					=> clk,
								reset					=> reset,		
								start					=> start,
								NewIteration			=> NewIteration,
								LastIteration			=> LastIteration,		
								J12_xi					=> J12,
								J21_xi					=> J21,
								X0						=> X0,
								X1						=> X1,
								SumsReady				=> SumsReady,
								Sum0 					=> Sum0,
								Sum1					=> Sum1
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
									variable v_ILINEX    		: line;
									variable v_OLINE    		: line;
									variable v_SPACE    		: character;
									variable J12_v, J21_v  		: std_logic_vector(19 downto 0);
									variable xi_v				: std_logic_vector(19 downto 0);
									variable X0_v, X1_v  		: std_logic_vector(19 downto 0);
									
								 begin
									-- open input and output file
									file_open(ParamFile, "InputParameter.txt", read_mode);
									file_open(XFile, "InputX.txt", read_mode);
									file_open(file_outputSum, "output_file.txt", write_mode);
									
									-- read the parameters
									-- The file format is the follow:
									-- J12 + J21
									readline(ParamFile, v_ILINEP);
									read(v_ILINEP, J12_v);
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, J21_v);
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, xi_v);

									J12			<=	J12_v;	
									J21			<= 	J21_v;
									xi			<= 	xi_v;

									file_close(ParamFile);

									LastIteration <= '0';
								   

								   while not endfile(XFile) loop
									-- read the parameters
									-- The file format is the follow:
									-- X0 + X1
										readline(XFile, v_ILINEX);
										read(v_ILINEX, X0_v);
										read(v_ILINEX, v_SPACE);
										read(v_ILINEX, X1_v);
										X0 	<= X0_v;
										X1	<= X1_v;
								
										
										start <= '1';
										NewIteration <= '1';
										wait for 10 ns; -- wait for one clock period
										start <= '0';						
									  
										wait until SumsReady = '1';
										wait for 11 ns; -- wait for one clock period
										write(v_OLINE, Sum0);
										write(v_OLINE, ' ');
										write(v_OLINE, Sum1);
										writeline(file_outputSum, v_OLINE);							   
								 end loop;
								
								 --close all file
								 file_close(XFile);
								 file_close(file_outputSum);
									
							   wait;
							end process;
		
	
	
	
end architecture test;