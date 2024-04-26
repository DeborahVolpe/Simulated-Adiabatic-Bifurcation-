library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_textio.all;
use work.bus_multiplexer_pkg.all;

entity NSpinSolverCU is
	generic	(
			NSPIN					: integer := 3; -- Number of Spin,
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
			enableUpdateK			: out std_logic;
			enableUpdateDelta		: out std_logic;
			enableUpdateDeltaT		: out std_logic;
			enableUpdateA0_start	: out std_logic;
			enableUpdateShapePt		: out std_logic;
			enableUpdateDelta4K		: out std_logic;
			enableUpdateK_1			: out std_logic;
			enableUpdateOffset		: out std_logic;
			enableUpdateHSample		: out std_logic;
			enableUpdateYSample		: out std_logic;
			enable_row				: out std_logic;
			enableUpdateXNew		: out std_logic;
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
end entity NSpinSolverCU;

architecture behaviour of NSpinSolverCU is 
	-- state definition 
    type state_type is (reset_state, A0_start_sample, ShapePt_sample, Delta4K_sample, K_1_sample, Offset_sample, K_sample, Delta_sample, deltaT_sample,
						hVectorsSample, JColumnFirst, JColumn, LastJColumn, LastRowJColumn, LastRowLastJColumn, YOld_sample, startAll, wait_x, xNew_sample, 
						wait_all, NewIterations, NewIterations_sum, LastIterations, waitEnds, done_state);
    signal state : state_type;
	
	begin


		state_evaluation: process(clk, reset)
		begin

			if reset = '0' then
				state <= reset_state;
			elsif rising_edge(clk) then
			
				case state is
					-- Start became equal to one when the  overall system is ready to start
					-- So parameter can be sampled in the next clock period
					when reset_state		=>	if start ='1' then
													state <= A0_start_sample;
												else
													state <= reset_state;
												end if;
					-- A0_start_sample must only considered at the beginnig to sample
					-- A0_start
					when A0_start_sample	=>	state	<= ShapePt_sample;
											
					-- ShapePt_sample must only be considered at the beginning to sample 
					-- ShapePt
					when ShapePt_sample		=>	state	<= Delta4K_sample;
					
					-- Delta4K_sample must only be considered at the beginning to sample 
					-- Delta4K
					when Delta4K_sample		=>	state	<= K_1_sample;
					
					-- K_1_sample must only be considered at the beginning to sample 
					-- K_1
					when K_1_sample			=>	state	<= Offset_sample;
					
					-- Offset_sample must only be considered at the beginning to sample 
					-- Offset
					when Offset_sample		=>	state	<= K_sample;
					
					-- K_sample must only be considered at the beginning to sample 
					-- K
					when K_sample			=>	state	<= Delta_sample;
					
					-- Delta_sample must only be considered at the beginning to sample 
					-- Delta
					when Delta_sample		=>	state	<= hVectorsSample;
					
					-- hVectors_sample must only be considered at the beginning 
					when hVectorsSample		=>	if tc_row = '1' then
													state	<= YOld_sample;
												else 
													state	<= hVectorsSample;
												end if;
												
					-- YOld_sample must only be considered at the beginning to sample 
					-- yOld
					when YOld_sample		=>	if tc_row = '1' then
													state	<= deltaT_sample;
												else 
													state	<= YOld_sample;
												end if;
										
					-- deltaT_sample must only be considered at the beginning to sample 
					-- deltaT
					when deltaT_sample		=>	state	<= JColumnFirst;
					
					-- JColumn must only be considered at the beginning 
					when JColumnFirst		=>	if tc_column = '1' then
													state	<= LastJColumn;
												else
													state	<= JColumn;
												end if;
												
					
					-- JColumn must only be considered at the beginning 
					when JColumn			=>	if tc_column = '1' then
													state	<= LastJColumn;
												else
													state	<= JColumn;
												end if;
					
					-- LastColumn must only be considered at the beginning, clean columnCounter and
					-- update row counter
					when LastJColumn		=>	if tc_row = '1' then
													state	<= LastRowJColumn;
												else 
													state	<= JColumnFirst;
												end if;
												
					when LastRowJColumn		=>	if tc_column = '1' then 
													state	<= LastRowLastJColumn;
												else
													state	<= LastRowJColumn;
												end if;
												
					when LastRowLastJColumn	=>	state	<= startAll;
					
					-- StartAll gives start signal to all block to start computation
					when startAll			=>	state 	<= wait_x;

					-- wait_all wait the end of computation of all blocks to start the new computation
					when wait_x			=>	if xReady_out = '1' then
												if SumReady_out = '1' then 
													state	<= xNew_sample;
												else 
													state 	<= wait_x;
												end if;
											else	
												state	<= wait_x;
											end if;
												
					-- xNew_sample sample the xNew data
					when xNew_sample		=>	state	<= NewIterations_sum;
					
					--Start the new sumIteration
					when NewIterations_sum	=>  state	<= wait_all;
												
					
					-- wait_all wait untill complection of all blocks
					when wait_all			=>	if (yReady_out = '1') and (A0Ready = '1') then
													if tc_iteration = '1' then
														state	<= LastIterations;
													else
														state	<= NewIterations;
													end if;
												else 
													state	<= wait_all;
												end if;
					
					-- All blocks have to start a new iteration
					when NewIterations		=>	state	<= wait_x;
					
					--All blocks have to start the last iteration
					when LastIterations		=>	state	<= waitEnds;
					
					when waitEnds			=>	if (doneA0p = '1') and (done_PEs = '1') and (done_sum_out = '1') then
													state	<= done_state;
												else 
													state	<= waitEnds;
												end if;
												
					when done_state 		=>	if start = '1' then
													state	<= A0_start_sample;
												else	
													state 	<= done_state;
												end if;
		
					-- In case of unpredicted situation
					when others         =>  state <= reset_state;
				end case;
			end if;
				
		end process;


		output_evaluation: process(state) 
			begin
				-- default output value
				rst						<= '1'; 
				rst_count_iteration		<= '1';
				rst_count_row			<= '1';
				rst_count_column		<= '1';
				enableUpdateA0_start	<= '0';
				enableUpdateK			<= '0';
				enableUpdateDelta		<= '0';
				enableUpdateDeltaT		<= '0';
				enableUpdateShapePt		<= '0';
				enableUpdateDelta4K		<= '0';
				enableUpdateK_1			<= '0';
				enableUpdateOffset		<= '0';
				enableUpdateHSample		<= '0';
				enableUpdateYSample		<= '0';
				enableUpdateXNew		<= '0';
				startPes				<= '0';
				NewIterationPes			<= '0';
				LastIterationPes		<= '0';
				startPA					<= '0';
				NewIterationPA			<= '0';
				LastIterationPA			<= '0';
				ce_count_iteration		<= '0';
				ce_count_row			<= '0';
				ce_count_column			<= '0';
				start_sum				<= '0';
				NewIteration_sum		<= '0';
				LastIteration_sum		<= '0';
				enable_start_sum		<= '0';
				enable_row				<= '0';
				done 					<= '0';
				
				case state is
					-- Start became equal to one when the  overall system is ready to start
					-- So parameter can be sampled in the next clock period
					when reset_state		=>	rst						<= '0'; 
												rst_count_iteration		<= '0';
												rst_count_row			<= '0';
												rst_count_column		<= '0';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
												
					-- A0_start_sample must only be considered at the beginning to sample 
					-- A0_start
					when A0_start_sample	=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '1';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
											
					-- ShapePt_sample must only be considered at the beginning to sample 
					-- ShapePt
					when ShapePt_sample		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '1';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
												
					-- Delta4K_sample must only be considered at the beginning to sample 
					-- Delta4K
					when Delta4K_sample		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '1';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
					
					-- K_1_sample must only be considered at the beginning to sample 
					-- K_1
					when K_1_sample			=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '1';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
					
					-- Offset_sample must only be considered at the beginning to sample 
					-- Offset
					when Offset_sample		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '1';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
					
					-- K_sample must only be considered at the beginning to sample 
					-- K
					when K_sample			=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '1';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
					
					-- Delta_sample must only be considered at the beginning to sample 
					-- Delta
					when Delta_sample		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '1';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
					
					
					-- hVectorsSample must only be considered at the beginning
					when hVectorsSample		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '1';
												enable_row				<= '1';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '1';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
												
					-- YOld_sample must only be considered at the beginning to sample 
					-- yOld1
					when YOld_sample		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '1';
												enable_row				<= '1';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '1';
												ce_count_column			<= '0';
												start_sum				<= '0';
												enable_start_sum		<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												done 					<= '0';
												
					-- deltaT_sample must only be considered at the beginning to sample 
					-- deltaT
					when deltaT_sample		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '1';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '1';
												enable_row				<= '1';
												done 					<= '0';
												
					when JColumnFirst		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '1';
												ce_count_column			<= '1';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
												enable_row				<= '1';
					
					when JColumn			=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '1';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
												enable_row				<= '0';
												
					when LastJColumn			=>	rst					<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '0';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '1';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '1';
												enable_row				<= '1';
												done 				    <= '0';
												
					when LastRowJColumn		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '0';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '1';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '1';
												done 					<= '0';
												enable_row				<= '1';
												
					when LastRowLastJColumn	=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '0';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '1';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '1';
												done 				    <= '0';
												enable_row				<= '1';
												
					-- StartAll gives start signal to all block to start computation
					when startAll			=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '1';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '1';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '1';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '1';
												NewIteration_sum		<= '1';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';

					-- wait_x wait x value
					when wait_x				=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
												
					-- xNew_sample sample the xNew data
					when xNew_sample		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '1';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
												
					when NewIterations_sum	=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '1';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
												

					
					-- wait_all wait untill complection of all blocks
					when wait_all			=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
					
					-- All blocks have to start a new iteration
					when NewIterations		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '1';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '1';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '1';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '0';
												
					--All blocks have to start the last iteration
					when LastIterations		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '1';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '1';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '1';
												enable_start_sum		<= '0';
												done 					<= '0';
					
					--Wait the end 
					when waitEnds			=>	rst						<= '1'; 
												rst_count_iteration		<= '0';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '1';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '1';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '1';
												enable_start_sum		<= '0';
												done 					<= '0';
												
						when done_state		=>	rst						<= '1'; 
												rst_count_iteration		<= '1';
												rst_count_row			<= '1';
												rst_count_column		<= '1';
												enableUpdateA0_start	<= '0';
												enableUpdateK			<= '0';
												enableUpdateDelta		<= '0';
												enableUpdateDeltaT		<= '0';
												enableUpdateShapePt		<= '0';
												enableUpdateDelta4K		<= '0';
												enableUpdateK_1			<= '0';
												enableUpdateOffset		<= '0';
												enableUpdateHSample		<= '0';
												enableUpdateYSample		<= '0';
												enableUpdateXNew		<= '0';
												startPes				<= '0';
												NewIterationPes			<= '0';
												LastIterationPes		<= '0';
												startPA					<= '0';
												NewIterationPA			<= '0';
												LastIterationPA			<= '0';
												ce_count_iteration		<= '0';
												ce_count_row			<= '0';
												ce_count_column			<= '0';
												start_sum				<= '0';
												NewIteration_sum		<= '0';
												LastIteration_sum		<= '0';
												enable_start_sum		<= '0';
												done 					<= '1';
		
					-- In case of unpredicted situation
					when others         => 
				end case;

		end process;		
	

end architecture behaviour;
