library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pA0updaterCU is
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
end entity pA0updaterCU;

architecture behaviour of pA0updaterCU is

	-- state definition 
    type state_type is (reset_state, idle, sample_state, wait_sample, state1, state2, state3, square_state, square_start_state, square_end_state, state4, state4A0, done_state);
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
													state <= sample_state;
												else
													state <= reset_state;
												end if;
											
					-- Sample_state must only be considered at the beginning to sample 
					-- all necessary parameter
					when sample_state		=>	state	<= state1;
					
					-- wait that PE sample p value
					when wait_sample		=>	state	<= state1;
					
					-- In the first state are computed:
					-- (p + shapeDt)
					when state1				=>	state	<= state2;
					
					-- In the second state are computed:
					-- (p + shapeDt) - (Delta+4K)
					when state2				=>	state	<= state3;
					
					-- In the third state are computed:
					-- ((p + shapeDt) - (Delta+4K))/K
					when state3				=>	state	<= square_start_state;
					
					when square_start_state	=>	state	<= square_state;
					
					-- In the square_state are computed:
					-- sqrt(((p + shapeDt) - (Delta+4K))/K)
					when square_state		=> 	if readySquare = '1' then
													state <= square_end_state;
												else
													state <= square_state;
												end if;
											
					when square_end_state	=>	if inv = '1' then 
													state <= state4;
												else	
													state <= state4A0;
												end if;		
					
					-- In the fourth_state are computed:
					-- sqrt(((p + shapeDt) - (Delta+4K))/K) + offset
					when state4				=>  if LastIteration = '1' then
													state <= done_state;
												else	
													if NewIteration = '1' then	
														state <= state1;
													else	
														state <= idle;
													end if;
												end if;
												
					-- In the fourth_state are computed:
					-- sqrt(((p + shapeDt) - (Delta+4K))/K) + offset
					when state4A0			=>  if LastIteration = '1' then
													state <= done_state;
												else	
													if NewIteration = '1' then	
														state <= state1;
													else	
														state <= idle;
													end if;
												end if;
					
					-- The system is in the idle state between two iteration if the system is not ready to start
					-- the new iteration for same reason
					when idle				=>	if NewIteration = '1' then
													state <= wait_sample;
												else
													if LastIteration = '1' then
														state <= done_state;
													else
														state <= idle;
													end if;
												end if;
											
					-- The LastIteration is perfomed and so the system wait for a new problem to solve
					when done_state			=>	if start = '1' then 
													state <= sample_state;
												else 
													state <= done_state;
												end if;
														
					-- In case of unpredicted situation
					when others         	=>  state <= reset_state;
				end case;
			end if;
				
		end process;
	

		output_evaluation: process(state) 
			begin
				-- default output value
				rst_parameter			<= '1';
				clean 					<= '1';
				enableUpdateA0_start	<= '0';
				enableUpdateShapePt		<= '0';
				enableUpdateDelta4K		<= '0';
				enableUpdateK_1			<= '0';
				enableUpdateOffset		<= '0';
				enableUpdateA0			<= '0';
				enableUpdatept			<= '0';
				enableUpdateMulA		<= '0';
				enableUpdateAddA		<= '0';
				enableUpdateSqA			<= '0';
				sub_add_n				<= '0';
				startSquare				<= '0';
				ptReady					<= '0';
				A0Ready					<= '0';
				selAa_mux_A				<= "00";
				selAa_mux_B				<= "00";
				done					<= '0';
				selA0out				<= '0';
				
				case state is
					when reset_state			=>		rst_parameter	<= '0';
														clean			<= '0';
					
					-- Sample_state must only be considered at the beginning to sample 
					-- all necessary parameter
					when sample_state			=>		clean 					<= '0';
														enableUpdateA0_start	<= '1';
														enableUpdateShapePt		<= '1';
														enableUpdateDelta4K		<= '1';
														enableUpdateK_1			<= '1';
														enableUpdateOffset		<= '1';
					
					-- wait that PE sample p value
					when wait_sample			=>
													
					-- In the first state are computed:
					-- (p + shapeDt)
					when state1					=>		selAa_mux_A				<= "00";
														selAa_mux_B				<= "00";
														sub_add_n				<= '0';
														enableUpdateAddA		<= '1';
														enableUpdatept			<= '1';
																
					-- In the second state are computed:
					-- (p + shapeDt) - (Delta+4K)					
					when state2					=>		selAa_mux_A				<= "01";
														selAa_mux_B				<= "01";
														sub_add_n				<= '1';
														enableUpdateAddA		<= '1';
														ptReady					<= '1';

					-- In the third state are computed:
					-- ((p + shapeDt) - (Delta+4K))/K												
					when state3					=>		enableUpdateMulA		<= '1';
					
					
					when square_start_state		=>		startSquare				<= '1';
					
					-- In the square_state are computed:
					-- sqrt(((p + shapeDt) - (Delta+4K))/K)	
					when square_state			=>		
					
					when square_end_state		=>		enableUpdateSqA			<= '1';
					
					-- In the fourth_state are computed:
					-- sqrt(((p + shapeDt) - (Delta+4K))/K) + offset													
					when state4					=> 		selAa_mux_A				<= "10";
														selAa_mux_B				<= "10";
														sub_add_n				<= '1';
														enableUpdateAddA		<= '1';
														A0Ready					<= '1';	
														selA0out				<= '1';
														
					-- In the fourth_state are computed:
					-- sqrt(((p + shapeDt) - (Delta+4K))/K) + offset													
					when state4A0				=> 		selAa_mux_A				<= "10";
														selAa_mux_B				<= "10";
														sub_add_n				<= '0';
														enableUpdateAddA		<= '1';
														A0Ready					<= '1';	
														selA0out				<= '0';
													
					-- The system is in the idle state between two iteration if the system is not ready to start
					-- the new iteration for same reason													
					when idle					=> 		A0Ready					<= '1';
					
					-- The LastIteration is perfomed and so the system wait for a new problem to solve
					when done_state				=>		done					<= '1';
					
					
					when others					=>		
				end case;

		end process;
	
end architecture behaviour; 