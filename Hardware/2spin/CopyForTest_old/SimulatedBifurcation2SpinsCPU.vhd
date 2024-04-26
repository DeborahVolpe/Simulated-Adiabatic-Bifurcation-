library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimulatedBifurcation2SpinsCPU is
	port	(
			clk  					:	in std_logic;
			reset					: 	in std_logic;
			start					:	in std_logic;
			x0Ready					: 	in std_logic;
			y0Ready					:	in std_logic;
			donePE0					:	in std_logic;
			x1Ready					: 	in std_logic;
			y1Ready					:	in std_logic;
			donePE1					:	in std_logic;
			ptReady					: 	in std_logic;
			A0Ready					: 	in std_logic;
			donepA0					: 	in std_logic;	
			doneS2S					:   in std_logic;
			tc						: 	in std_logic; -- Terminal counter. Equal to one at the end of the iteration
			rst						: 	out std_logic;
			enableUpdateA0_start	:	out std_logic;
			enableUpdateK			:   out std_logic;
			enableUpdateDelta		:	out std_logic;	
			enableUpdateEpsilon		: 	out std_logic;
			enableUpdateDeltaT		:	out std_logic;
			enableUpdateHVector0	:	out std_logic;
			enableUpdateHVector1	: 	out std_logic;
			enableUpdateShapePt		:	out std_logic;
			enableUpdateDelta4K		: 	out std_logic;
			enableUpdateK_1			: 	out std_logic;
			enableUpdateOffset		: 	out std_logic;
			enableUpdateJ12			: 	out std_logic;
			enableUpdateJ21			:	out std_logic;
			enableUpdateXOld0		:	out std_logic;
			enableUpdateXOld1		:	out std_logic;
			enableUpdateYOld0		:	out std_logic;
			enableUpdateYOld1		: 	out std_logic;
			enableUpdateXNew		:	out std_logic;
			startPE					:   out std_logic; -- PE can start when is equal to one
			NewIterationPE			: 	out std_logic; -- PE can start a new iteration when all data are ready
			LastIterationPE			:	out std_logic; -- PE's last iteration
			StartPA					:	out std_logic; -- PA can start when is equal to one
			NewIterationPA			:	out std_logic; -- PA can start a new iteration when all data are ready
			LastIterationPA			:	out std_logic; -- PA's last iteration
			startS2S				: 	out std_logic; -- Sum2Spin can start when is equal to one
			NewIterationS2S			: 	out std_logic; -- Sum2Spin can start a new iteration when all data are ready
			LastIterationS2S		:	out std_logic; -- Sum2Spin's last iterartion
			ce 						: 	out std_logic; -- counter enable every complete iteration
			done					: 	out std_logic
			);
end entity SimulatedBifurcation2SpinsCPU;

architecture behaviour of SimulatedBifurcation2SpinsCPU is

	-- state definition 
    type state_type is (reset_state, A0_start_sample, ShapePt_sample, Delta4K_sample, K_1_sample, Offset_sample, K_sample, Delta_sample, epsilon_sample, deltaT_sample,
						hVector0_sample, hVector1_sample, J12_sample, J21_sample, YOld_sample, startAll, wait_x, xNew_sample, wait_all, NewIterations, 
						NewIterations_sum, LastIterations, waitEnds, done_state);
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
												
					-- A0_start_sample must only be considered at the beginning to sample 
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
					when Delta_sample		=>	state	<= epsilon_sample;
					
					-- epsilon_sample must only be considered at the beginning to sample 
					-- epsilon
					when epsilon_sample		=>	state	<= deltaT_sample;
					
					-- deltaT_sample must only be considered at the beginning to sample 
					-- deltaT
					when deltaT_sample		=>	state	<= hVector0_sample;
					
					-- hVector0_sample must only be considered at the beginning to sample 
					-- hVector0
					when hVector0_sample	=>	state	<= hVector1_sample;
					
					-- hVector1_sample must only be considered at the beginning to sample 
					-- hVector1
					when hVector1_sample	=>	state	<= J12_sample;
					
					-- J12_sample must only be considered at the beginning to sample 
					-- J12
					when J12_sample			=>	state	<= J21_sample;
					
					-- J21_sample must only be considered at the beginning to sample 
					-- J21
					when J21_sample			=>	state	<= YOld_sample;
					
					-- YOld_sample must only be considered at the beginning to sample 
					-- yOld1
					when YOld_sample		=>	state	<= startAll;
					
					-- StartAll gives start signal to all block to start computation
					when startAll			=>	state 	<= wait_x;

					-- wait_all wait the end of computation of all blocks to start the new computation
					when wait_x			=>	if (x0Ready = '1') and (x1Ready = '1') then
													state	<= xNew_sample;
												else	
													state	<= wait_x;
												end if;
												
					-- xNew_sample sample the xNew data
					when xNew_sample		=>	state	<= NewIterations_sum;
					
					--Start the new sumIteration
					when NewIterations_sum	=> 	state	<= wait_all;
					
					-- wait_all wait untill complection of all blocks
					when wait_all			=>	if (y0Ready = '1') and (y1Ready = '1') and (A0Ready = '1') then
													if tc = '1' then
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
					
					when waitEnds			=>	if (donePE0 = '1') and (donePE1 = '1') and (donepA0 = '1') and (doneS2S = '1') then
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
				rst							<= '1';
				enableUpdateA0_start		<= '0';
				enableUpdateK				<= '0';
				enableUpdateDelta			<= '0';	
				enableUpdateEpsilon			<= '0';
				enableUpdateDeltaT			<= '0';
				enableUpdateHVector0		<= '0';
				enableUpdateHVector1		<= '0';
				enableUpdateShapePt			<= '0';
				enableUpdateDelta4K			<= '0';
				enableUpdateK_1				<= '0';
				enableUpdateOffset			<= '0';
				enableUpdateJ12				<= '0';
				enableUpdateJ21				<= '0';
				enableUpdateXOld0			<= '0';
				enableUpdateXOld1			<= '0';
				enableUpdateYOld0			<= '0';
				enableUpdateYOld1			<= '0';
				enableUpdateXNew			<= '0';
				startPE						<= '0';
				NewIterationPE				<= '0';
				LastIterationPE				<= '0';
				StartPA						<= '0';
				NewIterationPA				<= '0';
				LastIterationPA				<= '0';
				startS2S					<= '0';
				NewIterationS2S				<= '0';
				LastIterationS2S			<= '0';
				ce 							<= '0';
				done						<= '0';
				
				case state is
-- Start became equal to one when the  overall system is ready to start
					-- So parameter can be sampled in the next clock period
					when reset_state		=>	rst							<= '0';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
												
					-- A0_start_sample must only be considered at the beginning to sample 
					-- A0_start
					when A0_start_sample	=>	rst							<= '1';
												enableUpdateA0_start		<= '1';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
											
					-- ShapePt_sample must only be considered at the beginning to sample 
					-- ShapePt
					when ShapePt_sample		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '1';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
												
					-- Delta4K_sample must only be considered at the beginning to sample 
					-- Delta4K
					when Delta4K_sample		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '1';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- K_1_sample must only be considered at the beginning to sample 
					-- K_1
					when K_1_sample			=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '1';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- Offset_sample must only be considered at the beginning to sample 
					-- Offset
					when Offset_sample		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '1';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- K_sample must only be considered at the beginning to sample 
					-- K
					when K_sample			=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '1';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- Delta_sample must only be considered at the beginning to sample 
					-- Delta
					when Delta_sample		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '1';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- epsilon_sample must only be considered at the beginning to sample 
					-- epsilon
					when epsilon_sample		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '1';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
												
					-- deltaT_sample must only be considered at the beginning to sample 
					-- deltaT
					when deltaT_sample		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '1';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- hVector0_sample must only be considered at the beginning to sample 
					-- hVector0
					when hVector0_sample	=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '1';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					-- hVector1_sample must only be considered at the beginning to sample 
					-- hVector1
					when hVector1_sample	=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '1';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- J12_sample must only be considered at the beginning to sample 
					-- J12
					when J12_sample			=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '1';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- J21_sample must only be considered at the beginning to sample 
					-- J21
					when J21_sample			=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '1';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- YOld_sample must only be considered at the beginning to sample 
					-- yOld1
					when YOld_sample		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '1';
												enableUpdateXOld1			<= '1';
												enableUpdateYOld0			<= '1';
												enableUpdateYOld1			<= '1';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';

					-- StartAll gives start signal to all block to start computation
					when startAll			=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '1';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '1';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '1';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '1';
												done						<= '0';

					-- wait_x wait x value
					when wait_x				=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
												
					-- xNew_sample sample the xNew data
					when xNew_sample		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '1';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
												
					when NewIterations_sum	=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '1';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0'; 
					
					-- wait_all wait untill complection of all blocks
					when wait_all			=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
					
					-- All blocks have to start a new iteration
					when NewIterations		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '1';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '1';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '1';
												done						<= '0';
												
					--All blocks have to start the last iteration
					when LastIterations		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '1';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '1';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '1';
												ce 							<= '0';
												done						<= '0';
					
					--Wait the end 
					when waitEnds			=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '0';
												
						when done_state		=>	rst							<= '1';
												enableUpdateA0_start		<= '0';
												enableUpdateK				<= '0';
												enableUpdateDelta			<= '0';	
												enableUpdateEpsilon			<= '0';
												enableUpdateDeltaT			<= '0';
												enableUpdateHVector0		<= '0';
												enableUpdateHVector1		<= '0';
												enableUpdateShapePt			<= '0';
												enableUpdateDelta4K			<= '0';
												enableUpdateK_1				<= '0';
												enableUpdateOffset			<= '0';
												enableUpdateJ12				<= '0';
												enableUpdateJ21				<= '0';
												enableUpdateXOld0			<= '0';
												enableUpdateXOld1			<= '0';
												enableUpdateYOld0			<= '0';
												enableUpdateYOld1			<= '0';
												enableUpdateXNew			<= '0';
												startPE						<= '0';
												NewIterationPE				<= '0';
												LastIterationPE				<= '0';
												StartPA						<= '0';
												NewIterationPA				<= '0';
												LastIterationPA				<= '0';
												startS2S					<= '0';
												NewIterationS2S				<= '0';
												LastIterationS2S			<= '0';
												ce 							<= '0';
												done						<= '1';
		
					-- In case of unpredicted situation
					when others         => 
				end case;

		end process;		

end architecture behaviour;