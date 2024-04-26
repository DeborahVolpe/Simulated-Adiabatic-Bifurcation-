library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Sum2Spins is
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
			done					: 	out std_logic; 
			Sum0 					:	out std_logic_vector(INT+FRAC-1 downto 0);
			Sum1					:	out std_logic_vector(INT+FRAC-1 downto 0)
			);
end entity Sum2Spins;

architecture behaviour of Sum2Spins is

	component Sum2SpinsCPU
		port	(
				clk  					:	in std_logic;
				reset					:	in std_logic; -- External reset low active
				start					: 	in std_logic;
				NewIteration			: 	in std_logic; -- Equal to one when the overall system is ready to start a new iteration
				LastIteration			:	in std_logic; -- Equal to one if the considered iteration is the last one
				rst_parameter			: 	out std_logic;
				enableUpdateJ12			: 	out std_logic;
				enableUpdateJ21			:	out std_logic;
				enableUpdateX0			:	out std_logic;
				enableUpdateX1			:	out std_logic;
				enableUpdateMulA		:	out std_logic;	
				enableUpdateMulB		:	out std_logic;
				SumsReady				:	out std_logic;
				done					:	out std_logic
				);
	end	component Sum2SpinsCPU;
	
	component Sum2SpinsDatapath
		generic(
				INT 	: positive := 3;
				FRAC	: positive := 9
				);
		port	(
				clk  					:	in std_logic;
				rst_parameter			: 	in std_logic;
				enableUpdateJ12			: 	in std_logic;
				enableUpdateJ21			:	in std_logic;
				enableUpdateX0			:	in std_logic;
				enableUpdateX1			:	in std_logic;
				enableUpdateMulA		:	in std_logic;	
				enableUpdateMulB		:	in std_logic;					
				J12_xi					:	in std_logic_vector(INT+FRAC-1 downto 0);
				J21_xi					: 	in std_logic_vector(INT+FRAC-1 downto 0);
				X0						:	in std_logic_vector(INT+FRAC-1 downto 0);
				X1						:	in std_logic_vector(INT+FRAC-1 downto 0);
				Sum0 					:	out std_logic_vector(INT+FRAC-1 downto 0);
				Sum1					:	out std_logic_vector(INT+FRAC-1 downto 0)
				);
	end component Sum2SpinsDatapath;
	
	signal enableUpdateJ12, enableUpdateJ21			: std_logic;
	signal enableUpdateX0, enableUpdateX1			: std_logic;
	signal enableUpdateMulA, enableUpdateMulB		: std_logic;
	signal rst_parameter							: std_logic;
	
	begin
	
	
	DP : Sum2SpinsDatapath
				generic map (
							INT 					=> INT,
							FRAC					=> FRAC
							)
				port map	(
							clk  					=> clk,
							rst_parameter			=> rst_parameter,
							enableUpdateJ12			=> enableUpdateJ12,
							enableUpdateJ21			=> enableUpdateJ21,
							enableUpdateX0			=> enableUpdateX0,
							enableUpdateX1			=> enableUpdateX1,
							enableUpdateMulA		=> enableUpdateMulA,
							enableUpdateMulB		=> enableUpdateMulB,					
							J12_xi					=> J12_xi,
							J21_xi					=> J21_xi,
							X0						=> X0,
							X1						=> X1,
							Sum0 					=> Sum0,
							Sum1					=> Sum1
							);
							
	CU : Sum2SpinsCPU
				port map	(
							clk  					=> clk,
							reset					=> reset,
							start					=> start,
							NewIteration			=> NewIteration,
							LastIteration			=> LastIteration,
							rst_parameter			=> rst_parameter,
							enableUpdateJ12			=> enableUpdateJ12,
							enableUpdateJ21			=> enableUpdateJ21,
							enableUpdateX0			=> enableUpdateX0,
							enableUpdateX1			=> enableUpdateX1,
							enableUpdateMulA		=> enableUpdateMulA,	
							enableUpdateMulB		=> enableUpdateMulB,
							SumsReady				=> SumsReady,
							done					=> done
							);
							
end architecture behaviour;