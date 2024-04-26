library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SumNSpinsCU is
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
end entity SumNSpinsCU;

architecture Structure of SumNSpinsCU is

	-- state definition 
    type state_type is (reset_state, J_sampleEven, J_sampleOdd, wait_state, accumulation_state, final_sum_state, 
						final_moltiplication_state, idle, done_state);
    signal state : state_type;
	
	begin
	
		state_evaluation: process(clk, reset)
		begin

			if reset = '0' then
				state <= reset_state;
			elsif rising_edge(clk) then
			
				case state is
					-- start_sample became equal to one when it is possible to load the 
					-- J coefficients
					when reset_state				=>	if start_sample ='1' then
															state	<= J_sampleEven;
														else
															state	<= reset_state;
														end if;
						
					-- The Even J coefficient are sampled in this state 
					-- If the total number of coeffient to load is Even and 
					-- the terminal counter is equal to one, all the coefficent are load
					when J_sampleEven				=>	if tc = '1' and odd_Even_n = '0' then 
															if start = '0' then
																state	<= wait_state;
															else
																if NewIteration = '1' then	
																	state	<= accumulation_state;
																else
																	state	<= idle;
																end if;
															end if;
														else
															state	<= J_sampleOdd;
														end if;
					
					-- The Odd J coefficient are sampled in this state 
					-- If the total number of coeffient to load is Odd and 
					-- the terminal counter is equal to one, all the coefficent are load					
					when J_sampleOdd				=>	if tc = '1' and odd_Even_n = '1' then
															if start = '0' then
																state	<= wait_state;
															else
																if NewIteration = '1' then	
																	state	<= accumulation_state;
																else
																	state	<= idle;
																end if;
															end if;
														else
															state	<= J_sampleEven;
														end if;
												
					-- In this state the system wait untill all the part are ready to start							
					when wait_state					=>	if start = '1' then
															if NewIteration = '1' then	
																state	<= accumulation_state;
															else
																state	<= idle;
															end if;
														else 
															state	<= wait_state;
														end if;
										
					-- In this state, two x are multiplied with the corresponding J coeffiecient
					--and the two partial product are summed togheter and with the previous done sum
					when accumulation_state			=>	if tc = '1' then 
															state	<= final_sum_state;
														else
															state	<= accumulation_state;
														end if;
					
					-- In this state is performed the final sum of carry and sum of the csaB
					when final_sum_state			=> if NewIteration = '1' then
															state	<= accumulation_state;
														else
															if LastIteration = '1' then
																state	<= done_state;
															else
																state	<= idle;
															end if;
														end if;
					
					-- In this state the system wait for a New iteration
					when idle						=>	if NewIteration = '1' then
															state	<= accumulation_state;
														else
															if LastIteration = '1' then
																state	<= done_state;
															else
																state	<= idle;
															end if;
														end if;
														
					-- In this state done signal is up and it is possible wait a new computation									
					when done_state					=>	if start_sample = '1' then
															state	<= J_sampleEven;
														else	
															state	<= done_state;
														end if;
							
					-- In case of unpredicted situation
					when others         			=>  state <= reset_state;
				end case;
			end if;
		end process;
		
		output_evaluation: process(state) 
			begin
				-- default output value
				rst_parameter			<= '1';
				rst						<= '1';
				rst_CSA					<= '1';
				enableCSAB				<= '0';
				enableAdderA			<= '0';
				write_enable			<= '0';
				ce						<= '0';
				selWrite				<= '0';
				SumReady				<= '0';
				done					<= '0';

				
				case state is
					-- start_sample became equal to one when it is possible to load the 
					-- J coefficients
					when reset_state				=>	rst_parameter			<= '0';
														rst						<= '0';
														rst_CSA					<= '0';
														enableCSAB				<= '0';
														enableAdderA			<= '0';
														write_enable			<= '0';
														ce						<= '0';
														selWrite				<= '0';
														SumReady				<= '0';
														done					<= '0';
						
					-- The Even J coefficient are sampled in this state 
					-- If the total number of coeffient to load is Even and 
					-- the terminal counter is equal to one, all the coefficent are load
					when J_sampleEven				=>	rst_parameter			<= '1';
														rst						<= '1';
														rst_CSA					<= '1';
														enableCSAB				<= '0';
														enableAdderA			<= '0';
														write_enable			<= '1';
														ce						<= '0';
														selWrite				<= '0';
														SumReady				<= '0';
														done					<= '0';
					
					-- The Odd J coefficient are sampled in this state 
					-- If the total number of coeffient to load is Odd and 
					-- the terminal counter is equal to one, all the coefficent are load					
					when J_sampleOdd				=>	rst_parameter			<= '1';
														rst						<= '1';
														rst_CSA					<= '1';
														enableCSAB				<= '0';
														enableAdderA			<= '0';
														write_enable			<= '1';
														ce						<= '1';
														selWrite				<= '1';
														SumReady				<= '0';
														done					<= '0';
												
					-- In this state the system wait untill all the part are ready to start							
					when wait_state					=>	rst_parameter			<= '1';
														rst						<= '0';
														rst_CSA					<= '1';
														enableCSAB				<= '0';
														enableAdderA			<= '0';
														write_enable			<= '0';
														ce						<= '0';
														selWrite				<= '0';
														SumReady				<= '0';
														done					<= '0';
										
					-- In this state, two x are multiplied with the corresponding J coeffiecient
					--and the two partial product are summed togheter and with the previous done sum
					when accumulation_state			=>	rst_parameter			<= '1';
														rst						<= '1';
														rst_CSA					<= '1';
														enableCSAB				<= '1';
														enableAdderA			<= '0';
														write_enable			<= '0';
														ce						<= '1';
														selWrite				<= '0';
														SumReady				<= '0';
														done					<= '0';
					
					-- In this state is performed the final sum of carry and sum of the csaB
					when final_sum_state			=>	rst_parameter			<= '1';
														rst						<= '0';
														rst_CSA					<= '1';
														enableCSAB				<= '0';
														enableAdderA			<= '1';
														write_enable			<= '0';
														ce						<= '0';
														selWrite				<= '0';
														SumReady				<= '1';
														done					<= '0';
					
					-- In this state the system wait for a New iteration
					when idle						=>	rst_parameter			<= '1';
														rst						<= '0';
														rst_CSA					<= '0';
														enableCSAB				<= '0';
														enableAdderA			<= '0';
														write_enable			<= '0';
														ce						<= '0';
														selWrite				<= '0';
														SumReady				<= '1';
														done					<= '0';
														
					-- In this state done signal is up and it is possible wait a new computation									
					when done_state					=>	rst_parameter			<= '1';
														rst						<= '1';
														rst_CSA					<= '1';
														enableCSAB				<= '0';
														enableAdderA			<= '0';
														write_enable			<= '0';
														ce						<= '0';
														selWrite				<= '0';
														SumReady				<= '0';
														done					<= '1';
							
					-- In case of unpredicted situation
					when others         			=>  
				end case;
		end process;
		
end architecture Structure;