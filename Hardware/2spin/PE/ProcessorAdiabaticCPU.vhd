library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProcessorAdiabaticCPU is
	port	(
			clk  					:	in std_logic;
			reset					:	in std_logic; -- External reset low active
			start					: 	in std_logic;
			NewIteration			: 	in std_logic; -- Equal to one when the overall system is ready to start a new iteration
			LastIteration			:	in std_logic; -- Equal to one if the considered iteration is the last one
			SumReady				: 	in std_logic;
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
end entity ProcessorAdiabaticCPU;

architecture behaviour of ProcessorAdiabaticCPU is

	-- state definition 
    type state_type is (reset_state, idle, sample_state, state1, state2, state3, state4, state5, state6, state7, state7Sample, waitSum, 
						SumSample, state8, state9, state10, state10Full, done_state, sampleAp);
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
					when reset_state	=>	if start ='1' then
												state <= sample_state;
											else
												state <= reset_state;
											end if;
											
					-- Sample_state must only be considered at the beginning to sample 
					-- all necessary parameter
					when sample_state	=>	state	<= state1;
					
					-- In the first state are computed:
					-- Delta*YVector, Delta-p, HVector*2xi*A0
					when state1			=>	state	<= state2;
					
					-- In the second state are computed:
					-- Delta*YVector*deltaT
					when state2			=>	state	<= state3;
					
					-- In the third state are computed:
					-- xOld	+ Delta*YVector*deltaT
					when state3			=>	state	<= state4;

					-- In the fouth state are computed:
					-- K*xNew, xNew*(Delta-p)
					when state4			=>	state 	<= state5;
					
					-- In the fifth state are computed:
					-- xNew*xNew*K, xNew*Delta-p +HVector*2xi*A0
					when state5			=> 	state	<= state6;
					
					-- In the sixth state are computed:
					-- xNew*xNew*xNew*K 
					when state6			=>	if sumReady = '1' then
												state	<= state7Sample;
											else	
												state	<= state7;
											end if;
																
					-- In the seventh state are computed:
					-- xNew*xNew*xNew*K + xNew*Delta-p + HVector*2xi*A0
					when state7			=>	if sumReady = '1' then
												state	<= SumSample;
											else	
												state	<= waitSum;
											end if;
														
					-- In the seventh state are computed:
					-- xNew*xNew*xNew*K + xNew*Delta-p + HVector*2xi*A0
					when state7Sample	=>	state	<=	state8;
					
					when waitSum		=>	if sumReady = '1' then
												state	<= SumSample;
											else 
												state	<= waitSum;
											end if;
											
					when SumSample 		=>	state	<= state8;
					
					-- In the ninth state are computed
					-- (xNew*xNew*xNew*K + xNew*Delta-p + Sum+HVector*2xi*A0)
					when state8			=>	state	<= state9; 
					
					-- In the ninth state are computed
					-- (xNew*xNew*xNew*K + xNew*Delta-p + Sum+HVector*2xi*A0)*deltaT
					when state9			=>	if NewIteration = '1' then
												state <= state10Full;
											else
												state <= state10;
											end if;
					
					--In the ninth state are computed
					-- yOld - (xNew*xNew*xNew*K + xNew*Delta-p + Sum+HVector*2xi*A0)*deltaT
					when state10Full	=>	state <= state1;
					
					--In the nonth state are computed
					-- yOld - (xNew*xNew*xNew*K + xNew*Delta-p + Sum+HVector*2xi*A0)*deltaT
					when state10		=>	if NewIteration = '1' then
												state <= sampleAp;
											else
												state <= idle;
											end if;
					
					-- The system is in the idle state between two iteration if the system is not ready to start
					-- the new iteration for same reason
					when idle			=>	if NewIteration = '1' then
												state <= sampleAp;
											else
												if LastIteration = '1' then
													state <= done_state;
												else
													state <= idle;
												end if;
											end if;
											
					-- At the beginning of one iteration differente from the first 
					-- To update p and A0 parameter
					when sampleAp		=>	state	<= state1;
					
					-- The LastIteration is perfomed and so the system wait for a new problem to solve
					when done_state		=>	if start = '1' then 
												state <= sample_state;
											else 
												state <= done_state;
											end if;
														
					-- In case of unpredicted situation
					when others         =>  state <= reset_state;
				end case;
			end if;
				
		end process;
	

		output_evaluation: process(state) 
			begin
				-- default output value
				rst_parameter			<= '1'; -- low active reset
				enableUpdateA0			<= '0';
				enableUpdatep			<= '0';
				enableUpdateK			<= '0';
				enableUpdateDelta		<= '0';
				enableUpdateDeltaT		<= '0';
				enableUpdateSum			<= '0';
				enableUpdateHVectori_xi	<= '0';
				enableUpdateMulA		<= '0';
				enableUpdateMulB		<= '0';
				enableUpdateAddA		<= '0';
				enableUpdateAddA2		<= '0';
				enableUpdateX			<= '0';
				enableUpdateY			<= '0';
				enableUpdateXNew		<= '0';
				xReady					<= '0';
				yReady					<= '0';
				sub_add_n				<= '0';
				selMa_mux_A				<= "00";
				selMa_mux_B				<= "00";
				selMb_mux_A				<= '0';
				selMb_mux_B				<= '0';
				selAa_mux_A				<= "000";
				selAa_mux_B				<= "00";
				selX					<= '0';
				selY					<= "00";
				done					<= '0';
				
				case state is
					when reset_state		=>		rst_parameter	<= '0';
					
					-- Sample_state must only be considered at the beginning to sample 
					-- all necessary parameter
					when sample_state		=>		enableUpdateA0			<= '0';
													enableUpdatep			<= '0';
													enableUpdateK			<= '1';
													enableUpdateDelta		<= '1';
													enableUpdateDeltaT		<= '1';
													enableUpdateHVectori_xi	<= '1';
													enableUpdateX			<= '1';
													enableUpdateY			<= '1';
													selX					<= '0';
													selY					<= "00";
													
					-- In the first state are computed:
					-- Delta*YVector, Delta-p, HVector*2xi*A0
					when state1				=>		selMa_mux_A				<= "00";
													selMa_mux_B				<= "00";
													selMb_mux_A				<= '0';
													selMb_mux_B				<= '0';
													selAa_mux_A				<= "000";
													selAa_mux_B				<= "00";
													enableUpdateMulA		<= '1';
													enableUpdateMulB		<= '1';
													enableUpdateAddA		<= '1';
													sub_add_n				<= '1'; -- Necessary perform a subtraction
													
					-- In the second state are computed:
					-- Delta*YVector*deltaT							
					when state2				=>		selMa_mux_A				<= "01";
													selMa_mux_B				<= "01";
													enableUpdateAddA2		<= '1';
													enableUpdateMulA		<= '1';
													xReady					<= '1';

					-- In the third state are computed:
					-- xOld	+ Delta*YVector*deltaT													
					when state3				=>		selAa_mux_A				<= "001";
													selAa_mux_B				<= "01";
													enableUpdateAddA		<= '1';
													enableUpdateXNew		<= '1';
					
					-- In the fouth state are computed:
					-- K*xNew, xNew*Delta-p 					
					when state4				=> 		selMa_mux_A				<= "10";
													selMa_mux_B				<= "10";
													selMb_mux_A				<= '1';
													selMb_mux_B				<= '1';
													sub_add_n				<= '0';
													enableUpdateMulA		<= '1';
													enableUpdateMulB		<= '1';

					-- In the fifth state are computed:
					-- K*xNew*xNew, xNew*Delta-p +HVector*2xi*A0													
					when state5				=> 		selMa_mux_A				<= "11";
													selMa_mux_B				<= "11";
													selAa_mux_A				<= "010";
													selAa_mux_B				<= "10";
													sub_add_n				<= '0';
													enableUpdateMulA		<= '1';
													enableUpdateAddA		<= '1';
													
					-- In the sixth state are computed:
					-- xNew*xNew*xNew*K 
					when state6				=>		selMa_mux_A				<= "11";
													selMa_mux_B				<= "11";
													enableUpdateMulA		<= '1';													
													
													
					-- In the seventh state are computed:
					-- xNew*xNew*xNew*K + xNew*Delta-p + HVector*2xi*A0
					when state7				=>		selAa_mux_A				<= "011";
													selAa_mux_B				<= "01";
													sub_add_n				<= '0';
													enableUpdateAddA		<= '1';
													
					-- In the seventh state are computed:
					-- xNew*xNew*xNew*K + xNew*Delta-p + HVector*2xi*A0
					when state7Sample		=>		selAa_mux_A				<= "011";
													selAa_mux_B				<= "01";
													sub_add_n				<= '0';
													enableUpdateAddA		<= '1';
													enableUpdateSum			<= '1';
													
					when waitSum			=>
					
					when SumSample			=>		enableUpdateSum			<= '1';
													
					-- In the seventh state are computed:
					-- xNew*xNew*xNew*K + xNew*Delta-p + Sum+HVector*2xi*A0
					when state8				=>		selAa_mux_A				<= "100";
													selAa_mux_B				<= "11";
													sub_add_n				<= '0';
													enableUpdateAddA		<= '1';

					-- In the ninith state are computed
					-- (xNew*xNew*xNew*K + xNew*Delta-p + Sum+HVector*2xi*A0)*deltaT						
					when state9				=>		selMa_mux_A				<= "10";
													selMa_mux_B				<= "01";
													enableUpdateMulA		<= '1';
													
					--In the tenth state are computed
					-- yOld - (xNew*xNew*xNew*K + xNew*Delta-p + Sum+HVector*2xi*A0)*deltaT
					when state10			=> 		selAa_mux_A				<= "101";
													selAa_mux_B				<= "01";
													sub_add_n				<= '1';
													enableUpdateAddA		<= '1';
													yReady					<= '1';
													
					--In the tenth state are computed
					-- yOld - (xNew*xNew*xNew*K + xNew*Delta-p + Sum+HVector*2xi*A0)*deltaT
					when state10Full		=> 		selAa_mux_A				<= "101";
													selAa_mux_B				<= "01";
													sub_add_n				<= '1';
													enableUpdateAddA		<= '1';
													yReady					<= '1';
													enableUpdateA0			<= '1';
													enableUpdatep			<= '1';	
													enableUpdateX			<= '1';
													enableUpdateY			<= '1';
													enableUpdateSum			<= '1';
													selX					<= '1';
													selY					<= "01";											
													
					-- The system is in the idle state between two iteration if the system is not ready to start
					-- the new iteration for same reason													
					when idle				=> 		yReady					<= '1';
					
					-- At the beginning of one iteration differente from the first 
					-- To update p and A0 parameter
					when sampleAp			=>		enableUpdateA0			<= '1';
													enableUpdatep			<= '1';	
													enableUpdateX			<= '1';
													enableUpdateY			<= '1';	
													selX					<= '1';
													selY					<= "10";	
												
					
					-- The LastIteration is perfomed and so the system wait for a new problem to solve
					when done_state			=>		done					<= '1';
					
					
					when others				=>		
				end case;

		end process;
    
end architecture behaviour;