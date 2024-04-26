library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Testbench Processor Adiabatic Bifurcation

entity testbench is
end entity testbench;

architecture test of testbench is

	component pA0updater 
		generic (
				INT 				: positive := 3;
				FRAC				: positive := 9
				);
		port	(
				clk					:	in std_logic;
				reset				: 	in std_logic;
				NewIteration		:	in std_logic;
				LastIteration		:	in std_logic;
				start				:	in std_logic;
				A0_start			:	in std_logic_vector((INT+FRAC)-1 downto 0);
				ShapePt				:	in std_logic_vector((INT+FRAC)-1 downto 0);
				Delta4K				:	in std_logic_vector((INT+FRAC)-1 downto 0);
				K_1					:	in std_logic_vector((INT+FRAC)-1 downto 0);
				Offset				:	in std_logic_vector((INT+FRAC)-1 downto 0);
				ptReady				:	out std_logic;
				A0Ready				:	out std_logic;
				done				:	out std_logic;
				pt_out				:	out std_logic_vector((INT+FRAC)-1 downto 0);
				A0_out				: 	out std_logic_vector((INT+FRAC)-1 downto 0)
				);
	end component pA0updater;
	
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
		
	file ParamFile, file_output	: text;
	signal clk					: std_logic;
	signal NewIteration			: std_logic;
	signal LastIteration		: std_logic;
	signal start				: std_logic;
	signal reset				: std_logic;
	signal A0_start				: std_logic_vector(19 downto 0);
	signal ShapePt				: std_logic_vector(19 downto 0);
	signal Delta4K				: std_logic_vector(19 downto 0);
	signal K_1					: std_logic_vector(19 downto 0);
	signal Offset				: std_logic_vector(19 downto 0);
	signal ptReady				: std_logic;
	signal A0Ready				: std_logic;
	signal done					: std_logic;
	signal pt_out				: std_logic_vector(19 downto 0);
	signal A0_out				: std_logic_vector(19 downto 0);
	
	
	begin
	
		DUT : pA0updater 
					generic map	(
								INT 				=> 5,
								FRAC				=> 15
								)
					port map	(
								clk					=> clk,
								reset				=> reset,
								NewIteration		=> NewIteration,
								LastIteration		=> LastIteration,
								start				=> start,
								A0_start			=> A0_start,
								ShapePt				=> ShapePt,
								Delta4K				=> Delta4K,
								K_1					=> K_1,
								Offset				=> Offset,
								ptReady				=> ptReady,
								A0Ready				=> A0Ready,
								done				=> done,
								pt_out				=> pt_out,
								A0_out				=> A0_out
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
									variable v_ILINEP    			: line;
									variable v_OLINE    			: line;
									variable v_SPACE    			: character;
									variable A0_start_v				: std_logic_vector(19 downto 0);
									variable ShapePt_v, Delta4K_v  	: std_logic_vector(19 downto 0);
									variable K_1_v, offset_v		: std_logic_vector(19 downto 0);

									
								 begin
									-- open input and output file
									file_open(ParamFile, "InputParameter.txt", read_mode);
									file_open(file_output, "output_file.txt", write_mode);
									
									-- read the parameters
									-- The file format is the follow:
									-- ShapePt + Delta4K, K_1, offset
									readline(ParamFile, v_ILINEP);
									read(v_ILINEP, A0_start_v);
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, ShapePt_v);
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, Delta4K_v);
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, K_1_v);
									read(v_ILINEP, v_SPACE);
									read(v_ILINEP, offset_v);
	
									A0_start	<= 	A0_start_v;
									ShapePt		<=	ShapePt_v;	
									Delta4K		<= 	Delta4K_v;
									K_1			<= 	K_1_v;
									offset		<=	offset_v;

									file_close(ParamFile);

									LastIteration <= '0';
									start <= '1';
									NewIteration <= '1';
								   

									for i in 1 to 200 loop
										wait for 10 ns; -- wait for one clock period
										start <= '0';				
									  
										wait until ptReady = '1';
										wait for 10 ns; -- wait for one clock period
										write(v_OLINE, pt_out);
										
										wait until A0Ready = '1';
										wait for 10 ns; -- wait for onr clock period
										write(v_OLINE, ' ');
										write(v_OLINE, A0_out);
										writeline(file_output, v_OLINE);
									   
									end loop;
									NewIteration <= '0';
								
								 --close all file
								 file_close(file_output);
									
							   wait;
							end process;
		
	
	
	
end architecture test;