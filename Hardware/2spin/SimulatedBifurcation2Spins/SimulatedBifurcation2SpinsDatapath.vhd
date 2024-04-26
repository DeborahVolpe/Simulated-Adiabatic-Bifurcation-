library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimulatedBifurcation2SpinsDatapath is
	generic(
			INT 	: positive := 3;
			FRAC	: positive := 9;
			N		: positive := 20 -- 2^N number of iteration
			);
	port	(
			clk  					:	in std_logic;
			rst						: 	in std_logic;
			enableUpdateK			:   in std_logic;
			enableUpdateDelta		:	in std_logic;	
			enableUpdateDeltaT		:	in std_logic;
			enableUpdateHVector0	:	in std_logic;
			enableUpdateHVector1	: 	in std_logic;
			enableUpdateShapePt		:	in std_logic;
			enableUpdateDelta4K		: 	in std_logic;
			enableUpdateK_1			: 	in std_logic;
			enableUpdateOffset		: 	in std_logic;
			enableUpdateJ12			: 	in std_logic;
			enableUpdateJ21			:	in std_logic;
			enableUpdateXOld0		:	in std_logic;
			enableUpdateXOld1		:	in std_logic;
			enableUpdateYOld0		:	in std_logic;
			enableUpdateYOld1		: 	in std_logic;
			enableUpdateXNew		:	in std_logic;
			enableUpdateA0_start	:	in std_logic;
			startPE					:   in std_logic; -- PE can start when is equal to one
			NewIterationPE			: 	in std_logic; -- PE can start a new iteration when all data are ready
			LastIterationPE			:	in std_logic; -- PE's last iteration
			StartPA					:	in std_logic; -- PA can start when is equal to one
			NewIterationPA			:	in std_logic; -- PA can start a new iteration when all data are ready
			LastIterationPA			:	in std_logic; -- PA's last iteration
			startS2S				: 	in std_logic; -- Sum2Spin can start when is equal to one
			NewIterationS2S			: 	in std_logic; -- Sum2Spin can start a new iteration when all data are ready
			LastIterationS2S		:	in std_logic; -- Sum2Spin's last iterartion
			ce 						: 	in std_logic; -- counter enable every complete iteration
			A0_start				:	in std_logic_vector((INT+FRAC)-1 downto 0);
			K						:	in std_logic_vector((INT+FRAC)-1 downto 0);
			Delta					:	in std_logic_vector((INT+FRAC)-1 downto 0);
			deltaT					: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			hVector0				: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			hVector1				:	in std_logic_vector((INT+FRAC)-1 downto 0);
			shapePt					:	in std_logic_vector((INT+FRAC)-1 downto 0);
			Delta4K					:	in std_logic_vector((INT+FRAC)-1 downto 0);
			K_1						: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			Offset					: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			J12						:	in std_logic_vector((INT+FRAC)-1 downto 0);
			J21						: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			yOld0 					: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			yOld1 					: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			x0Ready					: 	out std_logic;
			y0Ready					:	out std_logic;
			donePE0					:	out std_logic;
			x1Ready					: 	out std_logic;
			y1Ready					:	out std_logic;
			donePE1					:	out std_logic;
			S0						: 	out std_logic;
			S1						: 	out std_logic;
			ptReady					: 	out std_logic;
			A0Ready					: 	out std_logic;
			donepA0					: 	out std_logic;	
			doneS2S					:   out std_logic;
			tc						: 	out std_logic -- Terminal counter. Equal to one at the end of the iteration
			);
end entity SimulatedBifurcation2SpinsDatapath;

architecture structure of SimulatedBifurcation2SpinsDatapath is

	--used component
	component ProcessorAdiabatic
		generic(
				INT 	: positive := 3;
				FRAC	: positive := 9
				);
		port	(
				clk  				:	in std_logic;
				reset				: 	in std_logic;
				start				:	in std_logic;
				NewIteration		:	in std_logic;
				LastIteration		:	in std_logic;
				sumReady			:	in std_logic;
				A0					:	in std_logic_vector((INT+FRAC)-1 downto 0);
				p					:	in std_logic_vector((INT+FRAC)-1 downto 0);
				K					:	in std_logic_vector((INT+FRAC)-1 downto 0);
				Delta				: 	in std_logic_vector((INT+FRAC)-1 downto 0);
				deltaT				:	in std_logic_vector((INT+FRAC)-1 downto 0);
				sum					:	in std_logic_vector((INT+FRAC)-1 downto 0);
				hVectori_xi			:	in std_logic_vector((INT+FRAC)-1 downto 0);
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
	
	component Sum2Spins
		generic(
				INT 	: positive := 3;
				FRAC	: positive := 9
				);
		port	(
				clk  					:	in std_logic;
				reset					: 	in std_logic;		
				start					: 	in std_logic;
				NewIteration			: 	in std_logic; -- Equal to one when the overall system is ready to start a new iteration
				LastIteration			:	in std_logic; -- Equal to one if the considered iteration is the last one			
				J12_xi					:	in std_logic_vector(INT+FRAC-1 downto 0);
				J21_xi					: 	in std_logic_vector(INT+FRAC-1 downto 0);
				X0						:	in std_logic_vector(INT+FRAC-1 downto 0);
				X1						:	in std_logic_vector(INT+FRAC-1 downto 0);
				SumsReady				:	out std_logic;
				done					: 	out std_logic; 
				Sum0 					:	out std_logic_vector(INT+FRAC-1 downto 0);
				Sum1					:	out std_logic_vector(INT+FRAC-1 downto 0)
				);
	end component Sum2Spins;
	
	component reg_s_reset_enable
		generic (N : positive := 5); 
		port	(
				D       : in std_logic_vector (N-1 downto 0);
				RST_n	: in std_logic; --reset low active
				en		: in std_logic; --enable
				clk     : in std_logic; --clock signal
				Q       : out std_logic_vector (N-1 downto 0)
				);
	end component reg_s_reset_enable;
	
	component counter
		generic (
				N		 	: integer:= 7
				);
		port	( 
				clk        	: in std_logic;
				rst        	: in std_logic;
				ce         	: in std_logic; -- counter enable
				counter_val	: out std_logic_vector(N-1 downto 0);
				tc         	: out std_logic
			);
	end component counter;
	
	component bN_2to1mux
		generic (N : positive := 8);
		port	( 
				x		: in std_logic_vector (N-1 downto 0); --0
				y		: in std_logic_vector (N-1 downto 0); --1
				s		: in std_logic;
				output	: out std_logic_vector(N-1 downto 0)
				);
	end component bN_2to1mux;
	
	
	-- used signal
	----parameter's registers output
	signal A0_start_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	signal K_out						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal Delta_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	signal deltaT_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	signal hVector0_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	signal hVector1_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	signal shapePt_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	signal Delta4K_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	signal K_1_out						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal Offset_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	signal J12_out						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal J21_out						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal xOld1						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal xOld0						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal xNew0_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	signal xNew1_out					: std_logic_vector((INT+FRAC)-1 downto 0);
	
	--Processors
	signal xOld0_in						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal yOld0_in						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal xOld1_in						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal yOld1_in						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal xNew0						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal yNew0						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal xNew1						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal yNew1						: std_logic_vector((INT+FRAC)-1 downto 0);
	
	
	--pA0updater
	signal A0_out						: std_logic_vector((INT+FRAC)-1 downto 0);
	signal pt_out						: std_logic_vector((INT+FRAC)-1 downto 0);
	
	--Sum2Spins
	signal Sum0							: std_logic_vector((INT+FRAC)-1 downto 0);
	signal Sum1							: std_logic_vector((INT+FRAC)-1 downto 0);
	
	--counter
	signal counter_val					: std_logic_vector(N-1 downto 0);
	
	signal SumsReady					: std_logic;
	
	begin
	
	---- Parameter's register
		-- parameter A0_start: To update at the beginning
		A0_startRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> A0_start,
								RST_n	=> rst, 
								en		=> enableUpdateA0_start,
								clk		=> clk,
								Q		=> A0_start_out      
								);
								
		-- parameter K: To update at the beginning
		KRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> K,
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
								D		=> Delta,
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
								D		=> deltaT,
								RST_n	=> rst, 
								en		=> enableUpdateDeltaT,
								clk		=> clk,
								Q		=> deltaT_out       
								);
								
		-- parameter hVector0: To update at the beginning
		HVector0Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> hVector0,
								RST_n	=> rst, 
								en		=> enableUpdateHVector0,
								clk		=> clk,
								Q		=> hVector0_out    
								);		
								
		-- parameter hVector1: To update at the beginning
		HVector1Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> hVector1,
								RST_n	=> rst, 
								en		=> enableUpdateHVector1,
								clk		=> clk,
								Q		=> hVector1_out    
								);
								
		-- parameter shapePt: To update at the beginning
		ShapePtRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> shapePt,
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
								D		=> Delta4K,
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
								D		=> K_1,
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
								D		=> Offset,
								RST_n	=> rst, 
								en		=> enableUpdateOffset,
								clk		=> clk,
								Q		=> Offset_out    
								);
								
		-- parameter J12: To update at the beginning
		J12Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> J12,
								RST_n	=> rst, 
								en		=> enableUpdateJ12,
								clk		=> clk,
								Q		=> J12_out   
								);		
								
		-- parameter J21: To update at the beginning
		J21Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> J21,
								RST_n	=> rst, 
								en		=> enableUpdateJ21,
								clk		=> clk,
								Q		=> J21_out    
								);
								
		-- parameter xOld0: To update at the beginning
		XOld0Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> xOld0,
								RST_n	=> rst, 
								en		=> enableUpdateXOld0,
								clk		=> clk,
								Q		=> xOld0_in    
								);
								
		-- parameter xOld1: To update at the beginning
		XOld1Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> xOld1,
								RST_n	=> rst, 
								en		=> enableUpdateXOld1,
								clk		=> clk,
								Q		=> xOld1_in    
								);
								
		-- parameter yOld0: To update at the beginning
		YOld0Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> yOld0,
								RST_n	=> rst, 
								en		=> enableUpdateYOld0,
								clk		=> clk,
								Q		=> yOld0_in    
								);
								
		-- parameter yOld1: To update at the beginning
		YOld1Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> yOld1,
								RST_n	=> rst, 
								en		=> enableUpdateYOld1,
								clk		=> clk,
								Q		=> yOld1_in    
								);
	
		xOld0					<= (others => '0');
		xOld1					<= (others => '0');


		-- parameter xNew0: To update at the end of each iteration
		xNew0Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> xNew0,
								RST_n	=> rst, 
								en		=> enableUpdateXNew,
								clk		=> clk,
								Q		=> xNew0_out    
								);
								
		-- parameter xNew1: To update at the end of each iteration
		xNew1Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> xNew1,
								RST_n	=> rst, 
								en		=> enableUpdateXNew,
								clk		=> clk,
								Q		=> xNew1_out    
								);
	
		
		
	---- PE spin 0 
		--Processor instance
		PE0 : ProcessorAdiabatic
					generic map (
								INT 				=> INT,
								FRAC				=> FRAC
								)
					port map	(
								clk  				=> clk,
								reset				=> rst,	
								start				=> startPE,
								NewIteration		=> NewIterationPE,
								LastIteration		=> LastIterationPE,
								sumReady			=> SumsReady,
								A0					=> A0_out,
								p					=> pt_out,
								K					=> K_out,
								Delta				=> Delta_out,
								deltaT				=> deltaT_out,
								sum					=> Sum0,
								hVectori_xi			=> hVector0_out,
								xOld_in				=> xOld0_in,
								yOld_in				=> yOld0_in,
								xNew				=> xNew0,
								yNew				=> yNew0,
								xReady				=> x0Ready,
								yReady				=> y0Ready,
								done				=> donePE0
								);
	
	-- Spin  final value: if 0 means +1 if 1 means -1
	S0							<=	xNew0_out((INT+FRAC)-1); -- Sign bit to know the final value of the spin 
	
	
								
	---- PE spin 1 
		--Processor instance
		PE1 : ProcessorAdiabatic
					generic map (
								INT 				=> INT,
								FRAC				=> FRAC
								)
					port map	(
								clk  				=> clk,
								reset				=> rst,	
								start				=> startPE,
								NewIteration		=> NewIterationPE,
								LastIteration		=> LastIterationPE,
								sumReady			=> SumsReady,
								A0					=> A0_out,
								p					=> pt_out,
								K					=> K_out,
								Delta				=> Delta_out,
								deltaT				=> deltaT_out,
								sum					=> Sum1,
								hVectori_xi			=> hVector1_out,
								xOld_in				=> xOld1_in,
								yOld_in				=> yOld1_in,
								xNew				=> xNew1,
								yNew				=> yNew1,
								xReady				=> x1Ready,
								yReady				=> y1Ready,
								done				=> donePE1
								);
								
	-- Spin  final value: if 0 means +1 if 1 means -1
	S1							<=	xNew1_out((INT+FRAC)-1); -- Sign bit to know the final value of the spin 
	
	
	---- pA0updater
		-- Updater instance
		pA0 : pA0updater
					generic map (
								INT 				=> INT,
								FRAC				=> FRAC
								)
					port map	(
								clk					=> clk,
								reset				=> rst,
								NewIteration		=> NewIterationPA,
								LastIteration		=> LastIterationPA,	
								start				=> startPA,
								ShapePt				=> ShapePt_out,
								Delta4K				=> Delta4K_out,
								A0_start			=> A0_start,
								K_1					=> K_1_out,
								Offset				=> Offset_out,
								ptReady				=> ptReady,
								A0Ready				=> A0Ready,
								done				=> donepA0,
								pt_out				=> pt_out,
								A0_out				=> A0_out
								);
	
	---- Sum2Spins			
		-- Sum instance
		S2S: Sum2Spins
					generic map(
								INT 				=> INT,
								FRAC				=> FRAC
								)
					port map	(
								clk  				=> clk,
								reset				=> rst,		
								start				=> startS2S,
								NewIteration		=> NewIterationS2S,
								LastIteration		=> LastIterationS2S,			
								J12_xi				=> J12_out,
								J21_xi				=> J21_out,
								X0					=> xNew0_out,
								X1					=> xNew1_out,
								SumsReady			=> SumsReady,
								done				=> doneS2S,
								Sum0 				=> Sum0,
								Sum1				=> Sum1
								);
								
								
	---- Counter
		-- Counter instance
		C: counter
			generic map (
						N		 					=> N
						)	
			port map	( 
						clk        					=> clk,
						rst							=> rst,
						ce         					=> ce,
						counter_val					=> counter_val,
						tc        					=> tc
						);
				
end architecture structure;
