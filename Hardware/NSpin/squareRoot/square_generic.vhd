library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--generic square root

entity square_generic is
	generic(N : positive := 32; --input bit number
			M : positive := 16 --number of output
			);
	port    (
			P   : in std_logic_vector(N-1 downto 0);
			clk : in std_logic;
			start: in std_logic;
			inv : out std_logic;
			ready : out std_logic;
			R	: out std_logic_vector(M+1 downto 0); -- M+2 length of remainder
			U	: out std_logic_vector(M downto 0)
			);
end entity square_generic;

architecture structuct of square_generic is

	component Init_block
		port    (
				P   : in std_logic;
				U	: out std_logic
				);
	end component Init_block;

	component Inter_block_first
		port    (
				P   	: in std_logic_vector(1 downto 0);
				y		: in std_logic;
				d_out	: out std_logic_vector(2 downto 0);
				U		: out std_logic
				);
	end component Inter_block_first;
	
	component Inter_block
		generic (N : positive := 4);
		port    (
				P   	: in std_logic_vector(1 downto 0);
				d_in	: in std_logic_vector (N-3 downto 0);
				y		: in std_logic_vector (N-4 downto 0);
				d_out	: out std_logic_vector(N-2 downto 0);
				U		: out std_logic
				);
	end component Inter_block;
	
	component Final_block 
		generic (N : positive := 18);
		port    (
				P   	: in std_logic_vector(1 downto 0);
				d_in	: in std_logic_vector (N-3 downto 0);
				y		: in std_logic_vector (N-4 downto 0);
				R		: out std_logic_vector(N-1 downto 0);
				U		: out std_logic
				);
	end component Final_block;
	
		component reg_s
		generic	(
				N : positive := 5
				); 
		port	(
				D       : in std_logic_vector (N-1 downto 0);
				clk     : in std_logic;
				Q       : out std_logic_vector (N-1 downto 0)
				);
	end component;
	
	component flip_flop_N_level 
		generic	(
				N 		: positive := 32
				);
		port	(
				D   	: in std_logic;
				clk 	: in std_logic;
				Q  		: out std_logic_vector ( N-1 downto 0) -- output of all flip flop 
				);
	end component;
	
	component reg_N_level 
		generic	(
				N : positive := 5;
				M : positive := 1 -- pipeline level
				); 
		port	(	
				D       : in std_logic_vector (N-1 downto 0);
				clk     : in std_logic;
				Q       : out std_logic_vector (N-1 downto 0)
				);
	end component reg_N_level;
	
	type matrix_d is array (M-2 downto 0) of std_logic_vector (M-1 downto 0);
	signal d 		: matrix_d;
	signal d_out	: matrix_d;
	type matrix_y is array (M-2 downto 0) of std_logic_vector (M-2 downto 0);
	signal y : matrix_y;
	type matrix_u is array (M-1 downto 0) of std_logic_vector (M-1 downto 0);
	signal U_temp 	: matrix_u;
	signal P_out 	: std_logic_vector( N-5 downto 0 );
	signal inv_temp : std_logic_vector(0 downto 0);
	signal ready_temp : std_logic_vector(0 downto 0);
	signal start_temp : std_logic_vector(0 downto 0);
	signal U_in	: std_logic_vector(M downto 0);
		
	begin
	
		-- initial block
		-- it takes the MSB
		I0: Init_block port map	(
								P   => P(N-2),
								U	=> U_temp(M-1)(0)
								);
								
		FF_0 : flip_flop_N_level 
						generic	map	(
									N 		=> M-2
									)
						port map	(
									D   	=> U_temp(M-1)(0),
									clk 	=> clk,
									Q  		=> U_temp(M-1)(M-1 downto 2)
									);

		Iinter0: Inter_block_first port map   	(
									P   	=> P(N-3 downto N-4),
									y		=> U_temp(M-1)(0),
									d_out	=> d(0)(2 downto 0),
									U		=> U_temp(M-2)(0)
									);


		reg_0 : reg_s 
					generic	map	(
								N 		=> 3
								)
					port map	(
								D       => d(0)(2 downto 0),
								clk     => clk,
								Q       => d_out(0)(2 downto 0)
								);
								
		FF_1 : flip_flop_N_level 
								generic	map	(
											N 		=> M-2
											)
								port map	(
											D   	=> U_temp(M-2)(0),
											clk 	=> clk,
											Q  		=> U_temp(M-2)(M-2 downto 1)
											);
								
		-- Generation of correct number of intermediate block
		G:	for i in 2 to M-2 generate
			-- generation of u input for the block
			Gy: for j in 1 to i generate
					y(i-1)(j-1) <= U_temp(M-j)(i-j+1);
			end generate;
			
			y(i-1)(0) <= U_temp(M-1)(i);
			
			Iinter: Inter_block
							generic map (N => i+3)
							port map   (
									P   	=> P_out(N-1-2*i downto N-2-2*i),
									d_in	=> d_out(i-2)(i downto 0),
									y		=> y(i-1)(i-1 downto 0),
									d_out	=> d(i-1)(i+1 downto 0),
									U		=> U_temp(M-1-i)(0)
									);
									
			r	 : reg_s 
						generic	map	(
									N 		=> i+2
									)
						port map	(
									D       => d(i-1)(i+1 downto 0),
									clk     => clk,
									Q       => d_out(i-1)(i+1 downto 0)
									);
									
			FF  : flip_flop_N_level 
									generic	map	(
												N 		=> M-i+1
												)
									port map	(
												D   	=> U_temp(M-1-i)(0),
												clk 	=> clk,
												Q  		=> U_temp(M-1-i)(M-i+1 downto 1)
												);
												
			rr : reg_N_level 
							generic map	(
										N 		=> 2,
										M		=> i-1
										) 
							port map	(	
										D       => P(N-1-2*i downto N-2-2*i),
										clk     => clk,
										Q       => P_out(N-1-2*i downto N-2-2*i)
										);
		end generate;
		
		-- generation of y input for the last line
		Gy2 : for j in 1 to M-1 generate
					y(M-2)(j-1) <= U_temp(M-j)(M-j);
			end generate;
			
		y(M-2)(0) <= U_temp(M-1)(M-1);
		
		-- Last line. It takes the LSB 
		Ifinal : Final_block 
							generic map (N => M+2)
							port map   (
									P   	=> P_out(1 downto 0),
									d_in	=> d_out(M-3)(M-1 downto 0),
									y		=> y(M-2)(M-2 downto 0),
									R		=> R, 
									U		=> U_temp(0)(0)
									);
									
		rl : reg_N_level 
							generic map	(
										N 		=> 2,
										M		=> M-2
										) 
							port map	(	
										D       => P(1 downto 0),
										clk     => clk,
										Q       => P_out(1 downto 0)
										);
									
		-- output complementation
		GU : for i in 0 to M-1 generate
			U_in(i) <= not U_temp(i)(i);
		end generate;
		
		-- the results are not valid if the input is negative
		inv_reg : reg_N_level 
							generic map	(
										N 		=> 1,
										M		=> M-2
										) 
							port map	(	
										D       => P(N-1 downto N-1),
										clk     => clk,
										Q       => inv_temp
										);

		start_temp (0)	<= start;
		-- the results are not valid if the input is negative
		start_reg : reg_N_level 
							generic map	(
										N 		=> 1,
										M		=> M-3
										) 
							port map	(	
										D       => start_temp,
										clk     => clk,
										Q       => ready_temp
										);

		inv <= inv_temp(0);
		ready <= ready_temp(0);
		
		U_in(M) <= '0';
	
		U       <= U_in;

end architecture structuct;
	
