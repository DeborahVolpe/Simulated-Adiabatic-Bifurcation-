library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pA0updater is
	generic(
			INT 	: positive := 3;
			FRAC	: positive := 9
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
end entity pA0updater;

architecture behaviour of pA0updater is

	component pA0updaterCU
		port	(
				clk  					:	in std_logic;
				reset					:	in std_logic; -- External reset low active
				readySquare				:	in std_logic;
				start					:	in std_logic;
				LastIteration			:	in std_logic;
				NewIteration			: 	in std_logic;
				inv 					:	in std_logic;
				rst_parameter			: 	out std_logic;
				clean 					: 	out std_logic;
				enableUpdateA0_start	: 	out std_logic;
				enableUpdateShapePt		:	out std_logic;
				enableUpdateDelta4K		:	out std_logic;
				enableUpdateK_1			:	out std_logic;
				enableUpdateOffset		:	out std_logic;
				enableUpdateA0			:	out std_logic;
				enableUpdatept			:	out std_logic;
				enableUpdateMulA		:	out std_logic;
				enableUpdateAddA		:	out std_logic;
				enableUpdateSqA			:	out std_logic;
				sub_add_n				:	out std_logic;
				startSquare				:	out std_logic;
				ptReady					:	out std_logic;
				A0Ready					:	out std_logic;
				selA0out				:	out std_logic;
				selAa_mux_A				:	out std_logic_vector(1 downto 0);
				selAa_mux_B				: 	out std_logic_vector(1 downto 0);
				done					:	out std_logic
				);
	end component pA0updaterCU;
	
	component pA0updaterDatapath
		generic(
				INT 	: positive := 3;
				FRAC	: positive := 9
				);
		port	(
				clk  					:	in std_logic;
				rst_parameter			: 	in std_logic;
				clean 					: 	in std_logic;
				enableUpdateA0_start	: 	in std_logic;
				enableUpdateShapePt		:	in std_logic;
				enableUpdateDelta4K		:	in std_logic;
				enableUpdateK_1			:	in std_logic;
				enableUpdateOffset		:	in std_logic;
				enableUpdateA0			:	in std_logic;
				enableUpdatept			:	in std_logic;
				enableUpdateMulA		:	in std_logic;
				enableUpdateAddA		:	in std_logic;
				enableUpdateSqA			:	in std_logic;
				sub_add_n				:	in std_logic;
				startSquare				:	in std_logic;
				selA0out				:	in std_logic;
				selAa_mux_A				:	in std_logic_vector(1 downto 0);
				selAa_mux_B				: 	in std_logic_vector(1 downto 0);
				A0_start				:	in std_logic_vector((INT+FRAC)-1 downto 0);
				ShapePt					: 	in std_logic_vector((INT+FRAC)-1 downto 0);
				Delta4K					: 	in std_logic_vector((INT+FRAC)-1 downto 0);
				K_1						:	in std_logic_vector((INT+FRAC)-1 downto 0);
				Offset					:	in std_logic_vector((INT+FRAC)-1 downto 0);
				readySquare				:	out std_logic;
				inv 					:	out std_logic;
				pt_out					:	out std_logic_vector((INT+FRAC)-1 downto 0);
				A0_out					:	out std_logic_vector((INT+FRAC)-1 downto 0)
				);
	end component pA0updaterDatapath;
	
	signal readySquare					:	std_logic;
	signal rst_parameter				:	std_logic;
	signal clean						:	std_logic;
	signal enableUpdateA0_start			: 	std_logic;
	signal enableUpdateShapePt			: 	std_logic;
	signal enableUpdateDelta4K			: 	std_logic;
	signal enableUpdateK_1				: 	std_logic;
	signal enableUpdateOffset			: 	std_logic;
	signal enableUpdateA0				:	std_logic;
	signal enableUpdatept				:	std_logic;
	signal enableUpdateMulA				: 	std_logic;
	signal enableUpdateAddA				:	std_logic;
	signal enableUpdateSqA				:	std_logic;
	signal sub_add_n					:	std_logic;
	signal startSquare					:	std_logic;
	signal inv							:	std_logic;
	signal selA0out						: 	std_logic;
	signal selAa_mux_A					: 	std_logic_vector(1 downto 0);
	signal selAa_mux_B					:	std_logic_vector(1 downto 0);
	
	
	begin
	
		CU  : pA0updaterCU
					port map	(
								clk  					=> clk,
								reset					=> reset,
								readySquare				=> readySquare, 
								start					=> start,
								LastIteration			=> LastIteration,
								NewIteration			=> NewIteration,
								rst_parameter			=> rst_parameter,
								clean 					=> clean,
								enableUpdateA0_start	=> enableUpdateA0_start,
								enableUpdateShapePt		=> enableUpdateShapePt,
								enableUpdateDelta4K		=> enableUpdateDelta4K,
								enableUpdateK_1			=> enableUpdateK_1,
								enableUpdateOffset		=> enableUpdateOffset,
								enableUpdateA0			=> enableUpdateA0,
								enableUpdatept			=> enableUpdatept,
								enableUpdateMulA		=> enableUpdateMulA,
								enableUpdateAddA		=> enableUpdateAddA,
								enableUpdateSqA			=> enableUpdateSqA,
								sub_add_n				=> sub_add_n,
								startSquare				=> startSquare,
								ptReady					=> ptReady,
								A0Ready					=> A0Ready,
								selAa_mux_A				=> selAa_mux_A,
								selAa_mux_B				=> selAa_mux_B,
								done					=> done,
								inv 					=> inv,
								selA0out				=> selA0out
								);
								
			DP : 	pA0updaterDatapath
					generic map	(
								INT 						=> INT,
								FRAC						=> FRAC
								)
					port map	(
								clk  						=> clk,
								rst_parameter				=> rst_parameter,
								clean 						=> clean,
								enableUpdateA0_start		=> enableUpdateA0_start,
								enableUpdateShapePt			=> enableUpdateShapePt,
								enableUpdateDelta4K			=> enableUpdateDelta4K,
								enableUpdateK_1				=> enableUpdateK_1,
								enableUpdateOffset			=> enableUpdateOffset,
								enableUpdateA0				=> enableUpdateA0,
								enableUpdatept				=> enableUpdatept,
								enableUpdateMulA			=> enableUpdateMulA,
								enableUpdateAddA			=> enableUpdateAddA,
								enableUpdateSqA				=> enableUpdateSqA,
								sub_add_n					=> sub_add_n,
								startSquare					=> startSquare,
								selAa_mux_A					=> selAa_mux_A,
								selAa_mux_B					=> selAa_mux_B,
								A0_start					=> A0_start,
								ShapePt						=> ShapePt,
								Delta4K						=> Delta4K,
								K_1							=> K_1,
								Offset						=> Offset,
								readySquare					=> readySquare,
								pt_out						=> pt_out,
								A0_out						=> A0_out,
								inv 						=> inv,
								selA0out					=> selA0out
								);
	
end architecture behaviour;
