library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_textio.all;
use work.bus_multiplexer_pkg.all;

entity NSpinSolverDatapath is
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
			enableUpdateK			: in std_logic;
			enableUpdateDelta		: in std_logic;
			enableUpdateDeltaT		: in std_logic;
			enableUpdateA0_start	: in std_logic;
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
end entity NSpinSolverDatapath;

architecture Structure of NSpinSolverDatapath is

	--used component
	component ProcessorAdiabatic
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
	end component ProcessorAdiabatic;
	
	component pA0updater
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
	end component pA0updater;
	
	
	component SumNSpins
		generic	(
				INT 	: positive := 3;
				FRAC	: positive := 9;
				M		: positive := 2; -- Address lenght
				NSPIN	: positive := 3 -- Number of Spin
				);
		port	(
				clk  					:	in std_logic;
				reset					:	in std_logic;
				start_sample			:	in std_logic;
				start					:	in std_logic;
				NewIteration			:	in std_logic;
				LastIteration			:	in std_logic;
				J_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
				x1_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
				x2_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
				done					: 	out std_logic;
				SumReady				:	out std_logic;
				SumFinal				:	out std_logic_vector(INT+FRAC-1 downto 0);
				xSel					:	out std_logic_vector(M-2 downto 0)
				);
	end component SumNSpins;
	
	component bN_Mto1mux
		generic (
				N 			: integer := 8;
				M			: integer := 3;
				SEL			: integer := 1
				);
		port	( 
				x			: in bus_array(M-1 downto 0, N-1 downto 0);	
				s			: in std_logic_vector(SEL-1 downto 0);
				output		: out std_logic_vector(N-1 downto 0)
				);
	end component bN_Mto1mux;
	
	component reg_s_reset_enable
		generic (N : positive := 5); 
		port(
			D       : in std_logic_vector (N-1 downto 0);
			RST_n	: in std_logic; --reset low active
			en		: in std_logic; --enable
			clk     : in std_logic; --clock signal
			Q       : out std_logic_vector (N-1 downto 0)
			);
	end component reg_s_reset_enable;
	
	component counterNStop
		generic (
				N		 	: integer:= 7
				);
		port	( 
				clk        	: in std_logic;
				rst        	: in std_logic; --low active
				ce         	: in std_logic; -- counter enable
				last_val	: in std_logic_vector(N-1 downto 0); 
				counter_val	: out std_logic_vector(N-1 downto 0);
				tc         	: out std_logic
			);
	end component counterNStop;
	
	component decoder 
		generic	(
				N			: integer := 3;
				M 			: integer := 2
				);
		port	(
				address		: in std_logic_vector(M-1 downto 0);
				en			: in std_logic;
				output		: out std_logic_vector(N-1 downto 0)
				);
	end component decoder;

	-- used signal
	---- parameters signal 
	type matrix_param is array (NSPIN-1 downto 0) of std_logic_vector(INT+FRAC-1 downto 0);
	signal K_out					: std_logic_vector(INT+FRAC-1 downto 0);
	signal Delta_out				: std_logic_vector(INT+FRAC-1 downto 0);
	signal deltaT_out				: std_logic_vector(INT+FRAC-1 downto 0);
	signal ShapePt_out				: std_logic_vector(INT+FRAC-1 downto 0);
	signal Delta4K_out				: std_logic_vector(INT+FRAC-1 downto 0);
	signal K_1_out					: std_logic_vector(INT+FRAC-1 downto 0);
	signal Offset_out				: std_logic_vector(INT+FRAC-1 downto 0);
	signal A0_start_out				: std_logic_vector(INT+FRAC-1 downto 0);
	signal hVector_out				: matrix_param;
	signal xOld_in					: matrix_param;
	signal yOld_in					: matrix_param;
	signal enableUpdateH			: std_logic_vector(NSPIN-1 downto 0);
	signal enableUpdateY			: std_logic_vector(NSPIN-1 downto 0);
	signal start_sample_sum			: std_logic_vector(NSPIN-1 downto 0);	
	signal enable_dec_row			: std_logic_vector(NSPIN-1 downto 0);
	
	---- PEs
	type matrix_xy is array (NSPIN-1 downto 0) of std_logic_vector(INT+FRAC-1 downto 0);
	signal xNew						: matrix_xy;
	signal yNew						: matrix_xy;
	signal xNew_out					: matrix_xy;
	signal xReady					: std_logic_vector(NSPIN-1 downto 0);
	signal yReady					: std_logic_vector(NSPIN-1 downto 0);
	signal done						: std_logic_vector(NSPIN-1 downto 0);
	signal AndsXReady				: std_logic_vector(NSPIN-1 downto 0);
	signal AndsYReady				: std_logic_vector(NSPIN-1 downto 0);
	signal AndsDone					: std_logic_vector(NSPIN-1 downto 0);
		
	---- pA0updater
	signal A0						: std_logic_vector(INT+FRAC-1 downto 0);
	signal pt						: std_logic_vector(INT+FRAC-1 downto 0);
	
	---- SumNSpins
	--multiplexers
	type matrix_Sum is array (NSPIN-1 downto 0) of std_logic_vector (INT+FRAC-1 downto 0);
	type matrix_sel is array (NSPIN-1 downto 0) of std_logic_vector (M-2 downto 0);
	type matrix_buffer1 is array (NSPIN-1 downto 0) of bus_array(((NSPIN-1)/2-1 +(NSPIN-1) mod 2) downto 0, INT+FRAC-1 downto 0);
	type matrix_buffer2 is array (NSPIN-1 downto 0) of bus_array(((NSPIN-1)/2-1) downto 0, INT+FRAC-1 downto 0);
	signal x1_in					: matrix_Sum;
	signal x2_in					: matrix_Sum;
	signal x1_mux_inputs			: matrix_buffer1;
	signal x2_mux_inputs			: matrix_buffer2;
	signal sel						: matrix_sel;
	signal output_mux_1				: matrix_Sum;
	signal output_mux_2 			: matrix_Sum;
	-- sum blocks
	signal Sums 					: matrix_Sum;
	signal done_sum					: std_logic_vector(NSPIN-1 downto 0);
	signal SumReady					: std_logic_vector(NSPIN-1 downto 0);
	signal AndsSumReady				: std_logic_vector(NSPIN-1 downto 0);
	signal AndsDoneSum				: std_logic_vector(NSPIN-1 downto 0);
	
	---- counters instance
	-- counter iteration
	signal counter_val_iteration	: std_logic_vector(N-1 downto 0);
	-- counter column
	signal counter_val_column		: std_logic_vector(M-1 downto 0);
	-- counter row
	signal counter_val_row			: std_logic_vector(M-1 downto 0);

	signal SumReady_in				: std_logic;
	
	begin
	---- Parameter's register
		-- parameter K: To update at the beginning
		KRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Data_in,
								RST_n	=> rst, 
								en		=> enableUpdateK,
								clk		=> clk,
								Q		=> K_out       
								);
								
		-- parameter Delta: To update at the beginning
		DeltaRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Data_in,
								RST_n	=> rst, 
								en		=> enableUpdateDelta,
								clk		=> clk,
								Q		=> Delta_out       
								);
								
								
		-- parameter deltaT: To update at the the beginning
		deltaTRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Data_in,
								RST_n	=> rst, 
								en		=> enableUpdateDeltaT,
								clk		=> clk,
								Q		=> deltaT_out       
								);
								
		-- parameter shapePt: To update at the beginning
		A0_startRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Data_in,
								RST_n	=> rst, 
								en		=> enableUpdateA0_start,
								clk		=> clk,
								Q		=> A0_start_out    
								);
								
		-- parameter shapePt: To update at the beginning
		ShapePtRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Data_in,
								RST_n	=> rst, 
								en		=> enableUpdateShapePt,
								clk		=> clk,
								Q		=> shapePt_out    
								);
								
		-- parameter Delta4K: To update at the beginning
		Delta4KRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Data_in,
								RST_n	=> rst, 
								en		=> enableUpdateDelta4K,
								clk		=> clk,
								Q		=> Delta4K_out    
								);
								
		-- parameter K_1: To update at the beginning
		K_1Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Data_in,
								RST_n	=> rst, 
								en		=> enableUpdateK_1,
								clk		=> clk,
								Q		=> K_1_out    
								);
								
		-- parameter Offset: To update at the beginning
		OffsetRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Data_in,
								RST_n	=> rst, 
								en		=> enableUpdateOffset,
								clk		=> clk,
								Q		=> Offset_out    
								);
								
		--HVectors register generation
		H_g : for i in 0 to NSPIN-1 generate
			HRegisteri :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Data_in,
								RST_n	=> rst, 
								en		=> enableUpdateH(i),
								clk		=> clk,
								Q		=> hVector_out(i)    
								);

		end generate;
	
	
	
	---- PEs generation 
		-- PEs
		PE_g : for i in 0 to NSPIN-1 generate
			PEs : ProcessorAdiabatic
						generic map	(
									INT					=> INT,
									FRAC				=> FRAC
									)
						port map	(
									clk  				=> clk,
									reset				=> rst,
									SumReady			=> SumReady_in,
									start				=> startPes,
									NewIteration		=> NewIterationPes,
									LastIteration		=> LastIterationPes,
									A0					=> A0,
									p					=> pt,
									K					=> K_out, 
									Delta				=> Delta_out,
									deltaT				=> deltaT_out,
									sum					=> Sums(i),
									hVectori			=> hVector_out(i),
									xOld_in				=> xOld_in(i),
									yOld_in				=> yOld_in(i),
									xNew				=> xNew(i),
									yNew				=> yNew(i),
									xReady				=> xReady(i),
									yReady				=> yReady(i),
									done				=> done(i)
									);
									
			xOld_in(i)				<= (others => '0');
			
			-- parameter yOldNSPIN: To update at the beginning
			YOldNSPINRegister :reg_s_reset_enable
						generic map	(
									N 		=> (INT+FRAC)
									) 
						port map	(
									D		=> data_in,
									RST_n	=> rst, 
									en		=> enableUpdateY(i),
									clk		=> clk,
									Q		=> yOld_in(i)    
									);
		end generate;
		
		

								
		-- Create outputs signal as and of signal of each single PE
		AndsXReady(0)				<= xReady(0);
		AndsYReady(0)				<= yReady(0);
		AndsDone(0)					<= done(0);
		
		out_sig_gen : for i in 1 to NSPIN-1 generate
			AndsXReady(i)			<= AndsXReady(i-1) and xReady(i);
			AndsYReady(i)			<= AndsYReady(i-1) and yReady(i);
			AndsDone(i)				<= AndsDone(i-1) and done(i);
		end generate;
		
		xReady_out					<= AndsXReady(NSPIN-1);
		yReady_out					<= AndsYReady(NSPIN-1);
		done_PEs					<= AndsDone(NSPIN-1);
		
		-- xSample
		-- parameters xNew: To update at the end of each iteration
		xNew_g : for i in 0 to NSPIN-1 generate
			xNewRegister :reg_s_reset_enable
						generic map	(
									N 		=> (INT+FRAC)
									) 
						port map	(
									D		=> xNew(i),
									RST_n	=> rst, 
									en		=> enableUpdateXNew,
									clk		=> clk,
									Q		=> xNew_out(i)    
									);
		end generate;
	
	---- PAUpdate
		PA: pA0updater
					generic map	(
								INT 				=> INT,
								FRAC				=> FRAC
								)
					port map	(
								clk					=> clk,
								reset				=> rst,
								NewIteration		=> NewIterationPA,
								LastIteration		=> LastIterationPA,
								start				=> startPA,
								A0_start			=> A0_start_out,
								ShapePt				=> ShapePt_out,
								Delta4K				=> Delta4K_out,
								K_1					=> K_1_out,
								Offset				=> Offset_out,
								ptReady				=> ptReady,
								A0Ready				=> A0Ready,
								done				=> doneA0p,
								pt_out				=> pt,
								A0_out				=> A0
								);
	
	----Counters instance
		-- Counter for Number of iteration
		IT_counter: counterNStop
					generic map	(
								N		 			=> N
								)
					port map	( 
								clk        			=> clk,
								rst        			=> rst_count_iteration,
								ce         			=> ce_count_iteration,
								last_val			=> std_logic_vector(to_unsigned((N_ITERATION-1),N)),
								counter_val			=> counter_val_iteration,
								tc         			=> tc_iteration
								);
								
		-- Counter Row
		Row_counter : counterNStop
					generic map	(
								N		 			=> M
								)
					port map	( 
								clk        			=> clk,
								rst        			=> rst_count_row,
								ce         			=> ce_count_row,
								last_val			=> std_logic_vector(to_unsigned((NSPIN-1), M)),
								counter_val			=> counter_val_row,
								tc         			=> tc_row
								);
								
		-- Counter Column
		Column_counter : counterNStop
					generic map	(
								N		 			=> M
								)
					port map	( 
								clk        			=> clk,
								rst        			=> rst_count_column,
								ce         			=> ce_count_column,
								last_val			=> std_logic_vector(to_unsigned((NSPIN-3), M)),
								counter_val			=> counter_val_column,
								tc         			=> tc_column
								);
								
	---- SumNSpins
	  -- Multiplexers inputs generation
		g_mux_inputs : for i in 0 to NSPIN-1 generate
			gi_mux : for j in 0 to ((NSPIN-1)/2-1) generate
				g_prev_even : if 2*j < i generate
					g_evenp : for k in 0 to INT+FRAC-1 generate
						x1_mux_inputs(i)(j,k)	<= xNew_out(2*j)(k);
					end generate;
				end generate;
				
				g_post_even : if 2*j >= i generate
					g_even : for k in 0 to INT+FRAC-1 generate
						x1_mux_inputs(i)(j,k)	<= xNew_out(2*j+1)(k);
					end generate;
				end generate;
				
				g_prev_odd : if (2*j+1) < i generate
					g_oddp : for k in 0 to INT+FRAC-1 generate
						x2_mux_inputs(i)(j,k)	<= xNew_out(2*j+1)(k);
					end generate;
				end generate;
				
				g_post_odd : if (2*j+1) >= i generate
					g_odd : for k in 0 to INT+FRAC-1 generate
						x2_mux_inputs(i)(j,k)	<= xNew_out(2*j+2)(k);
					end generate;
				end generate;
			end generate;
			
			case1 : if ((NSPIN-1) mod 2) = 1 and i /= (NSPIN-1) generate
				g_odd_end1 : for k in 0 to INT+FRAC-1 generate
						x1_mux_inputs(i)(((NSPIN-1)/2-1 +(NSPIN-1) mod 2 ),k)	<= xNew_out(NSPIN-1)(k);
				end generate;
			end generate;
			
			case2 :  if ((NSPIN-1) mod 2) = 1 and i = (NSPIN-1) generate
				g_odd_end2 : for k in 0 to INT+FRAC-1 generate
						x1_mux_inputs(i)(((NSPIN-1)/2-1 +(NSPIN-1) mod 2 ),k)	<= xNew_out(NSPIN-2)(k);
				end generate;
			end generate;
		end generate;
		
		-- Multiplexers generation
		g_mux : for i in 0 to NSPIN-1 generate
			muxs_1 : bN_Mto1mux
					generic map	(
								N 				=> INT+FRAC, 
								M				=> (NSPIN-1)/2 + (NSPIN-1) mod 2,
								SEL				=> M-1
								)
					port map	( 
								x				=> x1_mux_inputs(i),
								s				=> sel(i),
								output			=> output_mux_1(i)
								);
			
			muxs_2 : bN_Mto1mux
					generic map	(
								N 				=> INT+FRAC, 
								M				=> (NSPIN-1)/2,
								SEL				=> M-1
								)
					port map	( 
								x				=> x2_mux_inputs(i),
								s				=> sel(i),
								output			=> output_mux_2(i)
								);
		end generate;
		
		-- Sums blocks generation
		g_Sum : for i in 0 to NSPIN-1 generate
			Summers : SumNSpins
					generic map	(
								INT 					=> INT,
								FRAC					=> FRAC,
								M						=> M,
								NSPIN					=> NSPIN
								)
					port map	(
								clk  					=> clk,
								reset					=> rst,
								start_sample			=> start_sample_sum(i),
								start					=> start_sum,
								NewIteration			=> NewIteration_sum,
								LastIteration			=> LastIteration_sum,
								J_in					=> data_in,
								x1_in					=> output_mux_1(i),
								x2_in					=> output_mux_2(i),
								done					=> done_sum(i),
								SumReady				=> SumReady(i),
								SumFinal				=> Sums(i),
								xSel					=> sel(i)
								);
		end generate;	
		
		-- common signals generation
		AndsSumReady(0)			<= SumReady(0);
		AndsDoneSum(0)			<= done_sum(0);
		
		g_common_signal_sum : for i in 1 to NSPIN-1 generate
			AndsSumReady(i)		<= AndsSumReady(i-1) and SumReady(i);
			AndsDoneSum(i) 		<= AndsDoneSum(i-1) and done_sum(i);
		end generate;
		
		done_sum_out			<= AndsDoneSum(NSPIN-1);
		SumReady_out			<= SumReady_in;
		SumReady_in				<= AndsSumReady(NSPIN-1);
		
		
	---- Solution generation
		-- S
		g_solution : for i in 0 to NSPIN-1 generate
			S(i) 				<= xNew_out(i)(INT+FRAC-1);
		end generate;
		
		-- X, Y
		X_Y_solution : for i in 0 to NSPIN-1 generate
			full : for k in 0 to INT+FRAC-1 generate
				X_out(i,k)	<= xNew(i)(k);
				Y_out(i,k)	<= yNew(i)(k);
			end generate;
		end generate;
		
							
		enablesGen: for i in 0 to NSPIN-1 generate
			enableUpdateH(i) 		<= enableUpdateHSample and enable_dec_row(i);
			enableUpdateY(i) 		<= enableUpdateYSample and enable_dec_row(i);
			start_sample_sum(i)		<= enable_start_sum and enable_dec_row(i);
		end generate;
		
		-- Sum start decoder
		RowDec : decoder 
				generic	map (
							N			=> NSPIN,
							M 			=> M
							)
				port map	(
							address		=> counter_val_row,
							en			=> enable_row,
							output		=> enable_dec_row
							);
		
end architecture Structure; 