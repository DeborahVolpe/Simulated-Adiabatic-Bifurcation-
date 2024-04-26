library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sum2SpinsCPU is
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
end entity Sum2SpinsCPU;

architecture behaviour of Sum2SpinsCPU is

	-- state definition 
    type state_type is (reset_state, idle, sample_state, stateMul1, stateXUpdate, done_state);
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
					-- the two coefficients 
					when sample_state		=>	state	<= idle;
					
					
					-- The two multiplication (J12*xi)*X1 and (J21*xi)*X0 are evaluated
					when stateMul1			=>	if NewIteration = '1' then
													state <= stateXUpdate;
												else
													if LastIteration = '1' then
														state <= done_state;
													else
														state <= idle;
													end if;
												end if; 
					
					-- The system is in the idle state between two iteration if the system is not ready to start
					-- the new iteration for same reason
					when idle				=>	if NewIteration = '1' then
													state <= stateXUpdate;
												else
													if LastIteration = '1' then
														state <= done_state;
													else
														state <= idle;
													end if;
												end if;
					
					-- Samples X variable
					when stateXUpdate		=> state	<= stateMul1;
					
					
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
				rst_parameter					<= '1';
				enableUpdateJ12					<= '0';
				enableUpdateJ21					<= '0';
				enableUpdateX0					<= '0';
				enableUpdateX1					<= '0';
				enableUpdateMulA				<= '0';
				enableUpdateMulB				<= '0';
				SumsReady						<= '0';
				done							<= '0';
				
				case state is
					when reset_state			=>		rst_parameter	<= '0';
					
					-- Sample_state must only be considered at the beginning to sample 
					-- all necessary parameter
					when sample_state			=>		enableUpdateJ12					<= '1';
														enableUpdateJ21					<= '1';
														enableUpdateX0					<= '1';
														enableUpdateX1					<= '1';
													
					-- In the first state are computed:
					-- J*X
					when stateMul1				=>		enableUpdateMulA				<= '1';
														enableUpdateMulB				<= '1';	
														SumsReady						<= '1';
													
					-- The system is in the idle state between two iteration if the system is not ready to start
					-- the new iteration for same reason													
					when idle					=>		SumsReady						<= '1';
					
					when stateXUpdate			=> 		enableUpdateX0					<= '1';
														enableUpdateX1					<= '1';
					
					-- The LastIteration is perfomed and so the system wait for a new problem to solve
					when done_state				=>		done							<= '1';
					
					
					when others					=>		
				end case;

		end process;
		
end architecture behaviour;