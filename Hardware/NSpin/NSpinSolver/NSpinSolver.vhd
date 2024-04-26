library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.bus_multiplexer_pkg.all;

entity NSpinSolver is
	generic	(
			INT 					: integer := 3;
			FRAC					: integer := 9;
			M						: integer := 2; -- Address lenght
			NSPIN					: integer := 3; -- Number of Spin
			N						: integer := 20; --Bits for iteration
			N_ITERATION				: integer := 1000 -- Number of iteration
			);
	port	(
			clk						: in std_logic;
			reset					: in std_logic;
			start					: in std_logic;
			Data_in					: in std_logic_vector(INT+FRAC-1 downto 0);
			done					: out std_logic;
			xReady					: out std_logic;
			yReady					: out std_logic;
			S						: out std_logic_vector(NSPIN-1 downto 0);
			X_out					: out bus_array(NSPIN-1 downto 0, INT+FRAC-1 downto 0);	
			Y_out					: out bus_array(NSPIN-1 downto 0, INT+FRAC-1 downto 0)
			);
end entity NSpinSolver;

architecture structure of NSpinSolver is
	--used component
	component NSpinSolverDatapath
		generic	(
				INT 					: integer := 3;
				FRAC					: integer := 9;
				M						: integer := 2; -- Address lenght
				NSPIN					: integer := 3; -- Number of Spin
				N						: integer := 20; --Bits for iteration
				N_ITERATION				: integer := 1000 -- Number of iteration
				);
		port	(
				clk						: in std_logic;
				rst						: in std_logic; 
				rst_count_iteration		: in std_logic;	
				rst_count_row			: in std_logic;
				rst_count_column		: in std_logic;
				enableUpdateA0_start	: in std_logic;
				enableUpdateK			: in std_logic;
				enableUpdateDelta		: in std_logic;
				enableUpdateDeltaT		: in std_logic;
				enableUpdateShapePt		: in std_logic;
				enableUpdateDelta4K		: in std_logic;
				enableUpdateK_1			: in std_logic;
				enableUpdateOffset		: in std_logic;
				enableUpdateHSample		: in std_logic;
				enableUpdateYSample		: in std_logic;
				enableUpdateXNew		: in std_logic;
				enable_row				: in std_logic;
				startPes				: in std_logic; -- A single start for all PEs unit
				NewIterationPes			: in std_logic; -- A single NewIteration signal for all PEs
				LastIterationPes		: in std_logic;
				startPA					: in std_logic;
				NewIterationPA			: in std_logic;
				LastIterationPA			: in std_logic;
				ce_count_iteration		: in std_logic;
				ce_count_row			: in std_logic;
				ce_count_column			: in std_logic;
				start_sum				: in std_logic;
				NewIteration_sum		: in std_logic;
				LastIteration_sum		: in std_logic;
				enable_start_sum		: in std_logic;
				Data_in					: in std_logic_vector(INT+FRAC-1 downto 0);
				xReady_out				: out std_logic;
				yReady_out				: out std_logic;
				done_PEs				: out std_logic;
				ptReady					: out std_logic;
				A0Ready					: out std_logic;
				doneA0p					: out std_logic;
				tc_iteration			: out std_logic;
				tc_row					: out std_logic;
				tc_column				: out std_logic;
				SumReady_out			: out std_logic;
				done_sum_out			: out std_logic;
				S						: out std_logic_vector(NSPIN-1 downto 0);
				X_out					: out bus_array(NSPIN-1 downto 0, INT+FRAC-1 downto 0);	
				Y_out					: out bus_array(NSPIN-1 downto 0, INT+FRAC-1 downto 0)
				);
	end component NSpinSolverDatapath;
	
	component NSpinSolverCU 
		generic	(
				NSPIN					: integer := 3; -- Number of Spin
				M						: integer := 2
				);
		port	(
				clk						: in std_logic;
				reset					: in std_logic;
				start					: in std_logic;
				xReady_out				: in std_logic;
				yReady_out				: in std_logic;
				done_PEs				: in std_logic;
				ptReady					: in std_logic;
				A0Ready					: in std_logic;
				doneA0p					: in std_logic;
				tc_iteration			: in std_logic;
				tc_row					: in std_logic;
				tc_column				: in std_logic;
				SumReady_out			: in std_logic;
				done_sum_out			: in std_logic;				
				rst						: out std_logic; 
				rst_count_iteration		: out std_logic;	
				rst_count_row			: out std_logic;
				rst_count_column		: out std_logic;
				enableUpdateA0_start	: out std_logic;
				enableUpdateK			: out std_logic;
				enableUpdateDelta		: out std_logic;
				enableUpdateDeltaT		: out std_logic;
				enableUpdateShapePt		: out std_logic;
				enableUpdateDelta4K		: out std_logic;
				enableUpdateK_1			: out std_logic;
				enableUpdateOffset		: out std_logic;
				enableUpdateHSample		: out std_logic;
				enableUpdateYSample		: out std_logic;
				enableUpdateXNew		: out std_logic;
				enable_row				: out std_logic;
				startPes				: out std_logic; -- A single start for all PEs unit
				NewIterationPes			: out std_logic; -- A single NewIteration signal for all PEs
				LastIterationPes		: out std_logic;
				startPA					: out std_logic;
				NewIterationPA			: out std_logic;
				LastIterationPA			: out std_logic;
				ce_count_iteration		: out std_logic;
				ce_count_row			: out std_logic;
				ce_count_column			: out std_logic;
				start_sum				: out std_logic;
				NewIteration_sum		: out std_logic;
				LastIteration_sum		: out std_logic;
				enable_start_sum		: out std_logic;
				done 					: out std_logic
				);
	end component NSpinSolverCU;
	
	--used signal
	signal rst							: std_logic;
	signal rst_count_iteration			: std_logic;
	signal rst_count_row				: std_logic;
	signal rst_count_column				: std_logic;
	signal enableUpdateK				: std_logic;
	signal enableUpdateA0_start			: std_logic;
	signal enableUpdateDelta			: std_logic;
	signal enableUpdateDeltaT			: std_logic;
	signal enableUpdateShapePt			: std_logic;
	signal enableUpdateDelta4K			: std_logic;
	signal enableUpdateK_1				: std_logic;
	signal enableUpdateOffset			: std_logic;
	signal enableUpdateHSample			: std_logic;
	signal enableUpdateYSample			: std_logic;
	signal enable_row					: std_logic;
	signal enableUpdateXNew				: std_logic;
	signal startPes						: std_logic;
	signal NewIterationPes				: std_logic;
	signal LastIterationPes				: std_logic;
	signal startPA						: std_logic;
	signal NewIterationPA				: std_logic;
	signal LastIterationPA				: std_logic;
	signal ce_count_iteration			: std_logic;
	signal ce_count_row					: std_logic;
	signal ce_count_column				: std_logic;
	signal start_sum					: std_logic;
	signal NewIteration_sum				: std_logic;
	signal LastIteration_sum			: std_logic;
	signal enable_start_sum				: std_logic;
	signal xReady_out					: std_logic;
	signal yReady_out					: std_logic;
	signal done_PEs						: std_logic;
	signal ptReady						: std_logic;
	signal A0Ready						: std_logic;
	signal doneA0p						: std_logic;
	signal tc_iteration					: std_logic;
	signal tc_row						: std_logic;
	signal tc_column					: std_logic;
	signal SumReady_out					: std_logic;
	signal done_sum_out					: std_logic;
	
	begin
	
		DP : NSpinSolverDatapath
				generic map	(
							INT 					=> INT,
							FRAC					=> FRAC,
							M						=> M,
							NSPIN					=> NSPIN,
							N						=> N,
							N_ITERATION				=> N_ITERATION
							)
				port map	(
							clk						=> clk,
							rst						=> rst,
							rst_count_iteration		=> rst_count_iteration,
							rst_count_row			=> rst_count_row,
							rst_count_column		=> rst_count_column,
							enableUpdateA0_start	=> enableUpdateA0_start,
							enableUpdateK			=> enableUpdateK,
							enableUpdateDelta		=> enableUpdateDelta,
							enableUpdateDeltaT		=> enableUpdateDeltaT,
							enableUpdateShapePt		=> enableUpdateShapePt,
							enableUpdateDelta4K		=> enableUpdateDelta4K,
							enableUpdateK_1			=> enableUpdateK_1,
							enableUpdateOffset		=> enableUpdateOffset,
							enable_row				=> enable_row,
							enableUpdateHSample		=> enableUpdateHSample,
							enableUpdateYSample		=> enableUpdateYSample,
							enableUpdateXNew		=> enableUpdateXNew,
							startPes				=> startPes,
							NewIterationPes			=> NewIterationPes,
							LastIterationPes		=> LastIterationPes,
							startPA					=> startPA,
							NewIterationPA			=> NewIterationPA,
							LastIterationPA			=> LastIterationPA,
							ce_count_iteration		=> ce_count_iteration,
							ce_count_row			=> ce_count_row,
							ce_count_column			=> ce_count_column,
							start_sum				=> start_sum,
							NewIteration_sum		=> NewIteration_sum,
							LastIteration_sum		=> LastIteration_sum,
							enable_start_sum		=> enable_start_sum,
							Data_in					=> Data_in,
							xReady_out				=> xReady_out,
							yReady_out				=> yReady_out,
							done_PEs				=> done_PEs,
							ptReady					=> ptReady,
							A0Ready					=> A0Ready,
							doneA0p					=> doneA0p,
							tc_iteration			=> tc_iteration,
							tc_row					=> tc_row,
							tc_column				=> tc_column,
							SumReady_out			=> SumReady_out,
							done_sum_out			=> done_sum_out,
							S						=> S,
							X_out					=> X_out,
							Y_out					=> Y_out
							);
							
		CU:  NSpinSolverCU 
				generic	map	(	
							NSPIN					=> NSPIN,
							M 						=> M
							)
				port map	(
							clk						=> clk,
							reset					=> reset,
							start					=> start,
							xReady_out				=> xReady_out,
							yReady_out				=> yReady_out,
							done_PEs				=> done_PEs,
							ptReady					=> ptReady,
							A0Ready					=> A0Ready,
							doneA0p					=> doneA0p,
							tc_iteration			=> tc_iteration,
							tc_row					=> tc_row,
							tc_column				=> tc_column,
							SumReady_out			=> SumReady_out,
							done_sum_out			=> done_sum_out,			
							rst						=> rst,
							rst_count_iteration		=> rst_count_iteration,	
							rst_count_row			=> rst_count_row,
							rst_count_column		=> rst_count_column,
							enableUpdateA0_start	=> enableUpdateA0_start,
							enableUpdateK			=> enableUpdateK,
							enableUpdateDelta		=> enableUpdateDelta,
							enableUpdateDeltaT		=> enableUpdateDeltaT,
							enableUpdateShapePt		=> enableUpdateShapePt,
							enableUpdateDelta4K		=> enableUpdateDelta4K,
							enableUpdateK_1			=> enableUpdateK_1,
							enableUpdateOffset		=> enableUpdateOffset,
							enableUpdateHSample		=> enableUpdateHSample,
							enableUpdateYSample		=> enableUpdateYSample,
							enableUpdateXNew		=> enableUpdateXNew,
							enable_row				=> enable_row,
							startPes				=> startPes,
							NewIterationPes			=> NewIterationPes,
							LastIterationPes		=> LastIterationPes,
							startPA					=> startPA,
							NewIterationPA			=> NewIterationPA,
							LastIterationPA			=> LastIterationPA,
							ce_count_iteration		=> ce_count_iteration,
							ce_count_row			=> ce_count_row,
							ce_count_column			=> ce_count_column,
							start_sum				=> start_sum,
							NewIteration_sum		=> NewIteration_sum,
							LastIteration_sum		=> LastIteration_sum,
							enable_start_sum		=> enable_start_sum,
							done 					=> done
							);
							
	xReady			<= xReady_out;
	yReady			<= yReady_out;

end architecture structure;