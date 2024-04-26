library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProcessorAdiabatic is
	generic(
			INT 	: positive := 3;
			FRAC	: positive := 9
			);
	port	(
			clk  				:	in std_logic;
			reset				: 	in std_logic;
			SumReady			: 	in std_logic;
			start				:	in std_logic;
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
end entity ProcessorAdiabatic;

architecture behaviour of ProcessorAdiabatic is

	component ProcessorAdiabaticCPU
		port	(
				clk  					:	in std_logic;
				reset					:	in std_logic; -- External reset low active
				start					: 	in std_logic;
				SumReady				: 	in std_logic;
				NewIteration			: 	in std_logic; -- Equal to one when the overall system is ready to start a new iteration
				LastIteration			:	in std_logic; -- Equal to one if the considered iteration is the last one
				rst_parameter			: 	out std_logic;
				enableUpdateA0			: 	out std_logic;
				enableUpdatep			: 	out std_logic;
				enableUpdateK			: 	out std_logic;
				enableUpdateDelta		: 	out std_logic;
				enableUpdateDeltaT		:	out std_logic;
				enableUpdateSum			: 	out std_logic;
				enableUpdateHVectori_xi	: 	out std_logic;
				enableUpdateMulA		: 	out std_logic;
				enableUpdateMulB		: 	out std_logic;
				enableUpdateAddA		:	out std_logic;
				enableUpdateAddA2		: 	out std_logic;
				enableUpdateX			:	out std_logic;
				enableUpdateY			:	out std_logic;
				enableUpdateXNew		:	out std_logic;
				xReady					:	out std_logic; -- Equal to one when the new X can be sampled in the next rising edge of the clock
				yReady					: 	out std_logic; -- Equal to one when the new Y can be sampled in the next rising edge of the clock
				sub_add_n				: 	out std_logic;
				selX					: 	out std_logic;
				selY					: 	out std_logic_vector (1 downto 0);
				selMa_mux_A				: 	out std_logic_vector (1 downto 0);
				selMa_mux_B				: 	out std_logic_vector (1 downto 0);
				selMb_mux_A				: 	out std_logic;
				selMb_mux_B				: 	out std_logic;
				selAa_mux_A				:	out std_logic_vector (2 downto 0);
				selAa_mux_B				:	out std_logic_vector (1 downto 0);
				done					:	out std_logic
				);
	end component ProcessorAdiabaticCPU;
	
	component ProcessorAdiabaticDataPath
		generic(
				INT 	: positive := 3;
				FRAC	: positive := 9
				);
		port	(
				clk  					:	in std_logic;
				rst_parameter			: 	in std_logic;
				enableUpdateA0			: 	in std_logic;
				enableUpdatep			: 	in std_logic;
				enableUpdateK			: 	in std_logic;
				enableUpdateDelta		: 	in std_logic;
				enableUpdateDeltaT		:	in std_logic;
				enableUpdateSum			: 	in std_logic;
				enableUpdateHVectori_xi	: 	in std_logic;
				enableUpdateMulA		: 	in std_logic;
				enableUpdateMulB		: 	in std_logic;
				enableUpdateAddA		:	in std_logic;
				enableUpdateAddA2		: 	in std_logic;
				enableUpdateX			:	in std_logic;
				enableUpdateY			:	in std_logic;
				enableUpdateXNew		:	in std_logic;
				sub_add_n				: 	in std_logic;
				selX					: 	in std_logic;
				selY					: 	in std_logic_vector (1 downto 0);
				selMa_mux_A				: 	in std_logic_vector (1 downto 0);
				selMa_mux_B				: 	in std_logic_vector (1 downto 0);
				selMb_mux_A				: 	in std_logic;
				selMb_mux_B				: 	in std_logic;
				selAa_mux_A				:	in std_logic_vector (2 downto 0);
				selAa_mux_B				:	in std_logic_vector (1 downto 0);
				A0 						: 	in std_logic_vector ((INT+FRAC)-1 downto 0);
				p 						: 	in std_logic_vector ((INT+FRAC)-1 downto 0);
				K 						:	in std_logic_vector ((INT+FRAC)-1 downto 0);
				Delta 					:	in std_logic_vector ((INT+FRAC)-1 downto 0);
				deltaT					:	in std_logic_vector ((INT+FRAC)-1 downto 0);
				sum  					:   in std_logic_vector ((INT+FRAC)-1 downto 0);
				hVectori				:	in std_logic_vector ((INT+FRAC)-1 downto 0);
				xOld_in					:	in std_logic_vector ((INT+FRAC)-1 downto 0);
				yOld_in					:	in std_logic_vector	((INT+FRAC)-1 downto 0);
				xNew					:	out std_logic_vector ((INT+FRAC)-1 downto 0);
				yNew					: 	out std_logic_vector ((INT+FRAC)-1 downto 0)
				);
	end component ProcessorAdiabaticDataPath;

	signal rst_parameter				: std_logic;
	signal enableUpdateA0				: std_logic;
	signal enableUpdatep				: std_logic;
	signal enableUpdateK				: std_logic;
	signal enableUpdateDelta			: std_logic;
	signal enableUpdateDeltaT			: std_logic;
	signal enableUpdateSum				: std_logic;
	signal enableUpdateHVectori_xi		: std_logic;
	signal enableUpdateMulA				: std_logic;
	signal enableUpdateMulB				: std_logic;
	signal enableUpdateAddA				: std_logic;
	signal enableUpdateAddA2			: std_logic;
	signal enableUpdateX				: std_logic;
	signal enableUpdateY				: std_logic;
	signal enableUpdateXNew				: std_logic;
	signal sub_add_n					: std_logic;
	signal selX							: std_logic;
	signal selY							: std_logic_vector(1 downto 0);
	signal selMa_mux_A					: std_logic_vector(1 downto 0);
	signal selMa_mux_B					: std_logic_vector(1 downto 0);
	signal selMb_mux_A					: std_logic;
	signal selMb_mux_B					: std_logic;
	signal selAa_mux_A					: std_logic_vector(2 downto 0);
	signal selAa_mux_B					: std_logic_vector(1 downto 0);


	begin
	
		CU : ProcessorAdiabaticCPU
						port map	(
									clk  					=> clk,
									reset					=> reset,
									start					=> start,
									SumReady				=> SumReady,
									NewIteration			=> NewIteration,
									LastIteration			=> LastIteration,
									rst_parameter			=> rst_parameter,
									enableUpdateA0			=> enableUpdateA0,
									enableUpdatep			=> enableUpdatep,
									enableUpdateK			=> enableUpdateK,
									enableUpdateDelta		=> enableUpdateDelta,
									enableUpdateDeltaT		=> enableUpdateDeltaT,
									enableUpdateSum			=> enableUpdateSum,
									enableUpdateHVectori_xi	=> enableUpdateHVectori_xi,
									enableUpdateMulA		=> enableUpdateMulA,
									enableUpdateMulB		=> enableUpdateMulB,
									enableUpdateAddA		=> enableUpdateAddA,
									enableUpdateAddA2		=> enableUpdateAddA2,
									enableUpdateX			=> enableUpdateX,
									enableUpdateY			=> enableUpdateY,
									enableUpdateXNew		=> enableUpdateXNew, 
									xReady					=> xReady,
									yReady					=> yReady,
									sub_add_n				=> sub_add_n,
									selX					=> selX,
									selY					=> selY,
									selMa_mux_A				=> selMa_mux_A,
									selMa_mux_B				=> selMa_mux_B,
									selMb_mux_A				=> selMb_mux_A, 
									selMb_mux_B				=> selMb_mux_B,
									selAa_mux_A				=> selAa_mux_A,
									selAa_mux_B				=> selAa_mux_B,
									done					=> done
									);
									
		DP : ProcessorAdiabaticDataPath
						generic map	(
									INT							=> INT,
									FRAC						=> FRAC
									)
						port map	(
									clk							=> clk,
									rst_parameter				=> rst_parameter,
									enableUpdateA0				=> enableUpdateA0,
									enableUpdatep				=> enableUpdatep,
									enableUpdateK				=> enableUpdateK,
									enableUpdateDelta			=> enableUpdateDelta,
									enableUpdateDeltaT			=> enableUpdateDeltaT,
									enableUpdateSum				=> enableUpdateSum,
									enableUpdateHVectori_xi		=> enableUpdateHVectori_xi,
									enableUpdateMulA			=> enableUpdateMulA,
									enableUpdateMulB			=> enableUpdateMulB,
									enableUpdateAddA			=> enableUpdateAddA,
									enableUpdateAddA2			=> enableUpdateAddA2,
									enableUpdateX				=> enableUpdateX,
									enableUpdateY				=> enableUpdateY,
									enableUpdateXNew			=> enableUpdateXNew,
									sub_add_n					=> sub_add_n,
									selX						=> selX,
									selY						=> selY,
									selMa_mux_A					=> selMa_mux_A,
									selMa_mux_B					=> selMa_mux_B,
									selMb_mux_A					=> selMb_mux_A,
									selMb_mux_B					=> selMb_mux_B,
									selAa_mux_A					=> selAa_mux_A,
									selAa_mux_B					=> selAa_mux_B,
									A0 							=> A0,
									p 							=> p, 
									K 							=> K,
									Delta 						=> Delta,
									deltaT						=> deltaT,
									sum  						=> sum,
									hVectori					=> hVectori, 
									xOld_in						=> xOld_in, 
									yOld_in						=> yOld_in,
									xNew						=> xNew,
									yNew						=> yNew
									);

end architecture behaviour;

