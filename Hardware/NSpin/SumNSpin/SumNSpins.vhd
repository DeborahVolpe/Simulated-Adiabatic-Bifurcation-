library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SumNSpins is
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
			xSel					:	out std_logic_vector(M-2 downto 0)
			);
end entity SumNSpins;

architecture Structure of SumNSpins is

	--used component
	--datapath
	component SumNSpinsDatapath
		generic	(
				INT 	: positive := 3;
				FRAC	: positive := 9;
				M		: positive := 2; -- Address lenght
				NSPIN	: positive := 3 -- Number of Spin
				);
		port	(
				clk  					:	in std_logic;
				rst_parameter			: 	in std_logic;
				rst						: 	in std_logic;
				rst_CSA					:	in std_logic;
				enableCSAB				:	in std_logic;
				enableAdderA			:	in std_logic;
				write_enable			: 	in std_logic; -- To enable writing in RF
				ce						:	in std_logic; -- counter enable
				selWrite				: 	in std_logic;
				J_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
				x1_in					: 	in std_logic_vector(INT+FRAC-1 downto 0);
				x2_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
				tc						: 	out std_logic;
				odd_Even_n				: 	out std_logic;
				SumFinal				: 	out std_logic_vector(INT+FRAC-1 downto 0);
				xSel					:	out std_logic_vector(M-2 downto 0)
				);
	end component SumNSpinsDatapath;
	
	--control unit
	component SumNSpinsCU
		port	(
				clk  					:	in std_logic;
				reset					:	in std_logic;
				start_sample			: 	in std_logic;
				start					: 	in std_logic;
				NewIteration			: 	in std_logic;
				LastIteration			: 	in std_logic;
				tc						: 	in std_logic;
				odd_Even_n				: 	in std_logic;
				rst_parameter			: 	out std_logic;
				rst						: 	out std_logic;
				rst_CSA					:	out std_logic;
				enableCSAB				:	out std_logic;
				enableAdderA			:	out std_logic;
				write_enable			: 	out std_logic; -- To enable writing in RF
				ce						:	out std_logic; -- counter enable
				selWrite				: 	out std_logic;
				SumReady				: 	out std_logic;
				done					: 	out std_logic
				);
	end component SumNSpinsCU;
	
	--used signal
	signal rst_parameter				: std_logic;
	signal rst							: std_logic;
	signal rst_CSA						: std_logic;
	signal enableCSAB					: std_logic;
	signal enableAdderA					: std_logic;
	signal write_enable					: std_logic;
	signal ce							: std_logic;
	signal selWrite						: std_logic;
	signal tc							: std_logic;
	signal odd_Even_n					: std_logic;
	
	
	
	begin
	
		DP: SumNSpinsDatapath
					generic map	(
								INT					=> INT,
								FRAC				=> FRAC,
								M					=> M,
								NSPIN				=> NSPIN
								)
					port map	(
								clk  				=> clk,
								rst_parameter		=> rst_parameter,
								rst					=> rst, 
								rst_CSA				=> rst_CSA,
								enableCSAB			=> enableCSAB,
								enableAdderA		=> enableAdderA,
								write_enable		=> write_enable,
								ce					=> ce, 
								selWrite			=> selWrite,
								J_in				=> J_in,
								x1_in				=> x1_in,
								x2_in				=> x2_in,
								tc					=> tc,
								odd_Even_n			=> odd_Even_n,
								SumFinal			=> SumFinal,
								xSel				=> xSel
								);
								
								
		CU: SumNSpinsCU
					port map	(
								clk  				=> clk,
								reset				=> reset,
								start_sample		=> start_sample,
								start				=> start, 
								NewIteration		=> NewIteration,
								LastIteration		=> LastIteration,
								tc					=> tc,
								odd_Even_n			=> odd_Even_n,
								rst_parameter		=> rst_parameter,
								rst					=> rst,
								rst_CSA				=> rst_CSA,
								enableCSAB			=> enableCSAB,
								enableAdderA	 	=> enableAdderA,
								write_enable		=> write_enable,
								ce					=> ce,
								selWrite			=> selWrite,
								SumReady			=> SumReady,
								done				=> done
								);
end architecture Structure;
