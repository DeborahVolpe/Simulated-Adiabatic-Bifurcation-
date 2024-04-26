library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- testbench of square root generic block with a 32bit input and with random 
-- numbers as input

entity testbench is
end entity testbench;

architecture test of testbench is

component  square_generic is
	generic(N : positive := 32;
			M : positive := 16
			);
	port    (
			P   : in std_logic_vector(N-1 downto 0);
			clk	: in std_logic;
			start	: in std_logic;
			R	: out std_logic_vector(M+1 downto 0); -- M+2 length
			inv	: out std_logic; -- it said if the results is valid ( in case of negative input the results are not valid )
			ready	: out std_logic;
			U	: buffer std_logic_vector(M downto 0)
			);
end component square_generic;

signal  P   : std_logic_vector(13 downto 0);
signal  R	: std_logic_vector(8 downto 0);
signal	U	: std_logic_vector(7 downto 0);
signal inv	: std_logic;
signal clk	: std_logic;
signal start	: std_logic;
signal ready	: std_logic;
file file_input, file_output: text;
begin
	
	
	 read_file_process:  
        process
            variable v_ILINE    : line;
            variable v_OLINE    : line;
            variable v_SPACE    : character;
			variable v_P        : std_logic_vector(13 downto 0);
        begin
			-- opening input and output files
            file_open(file_input, "input_file14.txt", read_mode);
            file_open(file_output, "output_file14.txt", write_mode);
            
			--to the end of the file
            while not endfile(file_input) loop
                --I read the line in the file
                readline(file_input, v_ILINE);
                read(v_ILINE, v_P);
				P <= v_P;
		start <= '1';
                wait for 20 ns;
				
				--I write the outputs obtained in the correct format to the output file
                write(v_OLINE, U);
                write(v_OLINE, ' ');
                write(v_OLINE, R);
                write(v_OLINE, ' ');
                write(v_OLINE, inv);
                writeline(file_output, v_OLINE);
                
            end loop;
			
			for I in 1 to 4 loop
				wait for 20 ns;
				write(v_OLINE, U);
                write(v_OLINE, ' ');
                write(v_OLINE, R);
                write(v_OLINE, ' ');
                write(v_OLINE, inv);
                writeline(file_output, v_OLINE);
			end loop;
            
            --closing file
            file_close(file_input);
            file_close(file_output);
            
            wait;
        end process;
		
	dut:  square_generic generic map	(
							N => 14,
							M => 7
							)
				port map 	(
							P 	=> P,
							clk => clk,
							start	=> start,
							R	=> R,
							inv => inv,
							ready => ready,
							U 	=> U
							); 
							
	clk_process: process
		begin
			clk <= '0';	  
			wait for 10 ns;
			clk <= '1';
			wait for 10 ns;
	end process;
	
end architecture test;