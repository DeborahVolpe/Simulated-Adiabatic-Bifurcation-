library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimulatedBifurcation2Spins is
	generic	(
			INT 	: positive := 3;
			FRAC	: positive := 9;
			N		: positive := 20 -- 2^N number of iteration
			);
	port	(
			clk							:	in std_logic;
			reset						:	in std_logic;
			start						:	in std_logic;
			data_in						:	in std_logic_vector((INT+FRAC)-1 downto 0);
			S0							: 	out std_logic;
			S1							:	out std_logic;
			done						:	out std_logic;
			X0R							:	out std_logic;
			Y0R							:	out std_logic;
			X1R							: 	out std_logic;
			Y1R							:	out std_logic;
			X0							:	out std_logic_vector((INT+FRAC)-1 downto 0);
			Y0							:	out std_logic_vector((INT+FRAC)-1 downto 0);
			X1							: 	out std_logic_vector((INT+FRAC)-1 downto 0);
			Y1							: 	out std_logic_vector((INT+FRAC)-1 downto 0)
			);
end entity SimulatedBifurcation2Spins;

architecture structure of SimulatedBifurcation2Spins is


	--used component
	component SimulatedBifurcation2SpinsDatapath
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
				tc						: 	out std_logic;-- Terminal counter. Equal to one at the end of the iteration
				X0						:	out std_logic_vector((INT+FRAC)-1 downto 0);
				Y0						:	out std_logic_vector((INT+FRAC)-1 downto 0);
				X1						: 	out std_logic_vector((INT+FRAC)-1 downto 0);
				Y1						: 	out std_logic_vector((INT+FRAC)-1 downto 0)
				);
	end component SimulatedBifurcation2SpinsDatapath;
	
	
	component SimulatedBifurcation2SpinsCPU
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
	end component SimulatedBifurcation2SpinsCPU;
	
	signal rst							: std_logic;
	signal enableUpdateA0_start			: std_logic;
	signal enableUpdateK				: std_logic;
	signal enableUpdateDelta			: std_logic;
	signal enableUpdateDeltaT			: std_logic;
	signal enableUpdateHVector0			: std_logic;
	signal enableUpdateHVector1			: std_logic;
	signal enableUpdateShapePt			: std_logic;
	signal enableUpdateDelta4K			: std_logic;
	signal enableUpdateK_1				: std_logic;
	signal enableUpdateOffset			: std_logic;
	signal enableUpdateJ12				: std_logic;
	signal enableUpdateJ21				: std_logic;
	signal enableUpdateXOld0			: std_logic;
	signal enableUpdateXOld1			: std_logic;
	signal enableUpdateYOld0			: std_logic;
	signal enableUpdateYOld1			: std_logic;
	signal enableUpdateXNew				: std_logic;
	signal startPE						: std_logic;
	signal NewIterationPE				: std_logic;
	signal LastIterationPE				: std_logic;
	signal startPA						: std_logic;
	signal NewIterationPA				: std_logic;
	signal LastIterationPA				: std_logic;
	signal startS2S						: std_logic;
	signal NewIterationS2S				: std_logic;
	signal LastIterationS2S				: std_logic;
	signal ce							: std_logic;
	signal x0Ready						: std_logic;
	signal y0Ready						: std_logic;
	signal donePE0						: std_logic;
	signal x1Ready						: std_logic;
	signal y1Ready						: std_logic;
	signal donePE1						: std_logic;
	signal ptReady						: std_logic;
	signal A0Ready						: std_logic;
	signal donepA0						: std_logic;
	signal doneS2S						: std_logic;
	signal tc							: std_logic;
	
	
	begin
	
	
		X0R							<= x0Ready;
		Y0R							<= y0Ready;
		X1R							<= x1Ready;
		Y1R							<= y1Ready;
	
		-- datapath instance
		DP: SimulatedBifurcation2SpinsDatapath
							generic map	(
										INT 					=> INT,
										FRAC					=> FRAC, 
										N						=> N
										)
							port map 	(
										clk  					=> clk,
										rst						=> rst,
										enableUpdateA0_start	=> enableUpdateA0_start,
										enableUpdateK			=> enableUpdateK,
										enableUpdateDelta		=> enableUpdateDelta,	
										enableUpdateDeltaT		=> enableUpdateDeltaT,
										enableUpdateHVector0	=> enableUpdateHVector0,
										enableUpdateHVector1	=> enableUpdateHVector1,
										enableUpdateShapePt		=> enableUpdateShapePt,
										enableUpdateDelta4K		=> enableUpdateDelta4K,
										enableUpdateK_1			=> enableUpdateK_1,
										enableUpdateOffset		=> enableUpdateOffset,
										enableUpdateJ12			=> enableUpdateJ12,
										enableUpdateJ21			=> enableUpdateJ21,
										enableUpdateXOld0		=> enableUpdateXOld0,
										enableUpdateXOld1		=> enableUpdateXOld1,
										enableUpdateYOld0		=> enableUpdateYOld0,
										enableUpdateYOld1		=> enableUpdateYOld1,
										enableUpdateXNew		=> enableUpdateXNew,
										startPE					=> startPE,
										NewIterationPE			=> NewIterationPE,
										LastIterationPE			=> LastIterationPE,
										StartPA					=> startPA,
										NewIterationPA			=> NewIterationPA,
										LastIterationPA			=> LastIterationPA,
										startS2S				=> startS2S,
										NewIterationS2S			=> NewIterationS2S,
										LastIterationS2S		=> LastIterationS2S,
										ce 						=> ce, 
										A0_start				=> data_in,
										K						=> data_in,
										Delta					=> data_in,
										deltaT					=> data_in,
										hVector0				=> data_in,
										hVector1				=> data_in,
										shapePt					=> data_in,
										Delta4K					=> data_in,
										K_1						=> data_in,
										Offset					=> data_in,
										J12						=> data_in,
										J21						=> data_in,
										yOld0 					=> data_in,
										yOld1 					=> data_in,
										x0Ready					=> x0Ready,
										y0Ready					=> y0Ready,
										donePE0					=> donePE0,
										x1Ready					=> x1Ready,
										y1Ready					=> y1Ready,
										donePE1					=> donePE1,
										S0						=> S0,
										S1						=> S1,
										ptReady					=> ptReady,
										A0Ready					=> A0Ready,
										donepA0					=> donepA0,	
										doneS2S					=> doneS2S,
										tc						=> tc,										X0						=> X0,
										Y0						=> Y0,
										X1						=> X1,
										Y1						=> Y1
										);
										
										
		CU: SimulatedBifurcation2SpinsCPU
							port map	(
										clk  					=> clk,
										reset					=> reset,
										start					=> start,
										x0Ready					=> x0Ready,
										y0Ready					=> y0Ready,
										donePE0					=> donePE0,
										x1Ready					=> x1Ready,
										y1Ready					=> y1Ready,
										donePE1					=> donePE1,
										ptReady					=> ptReady,
										A0Ready					=> A0Ready,
										donepA0					=> donepA0,	
										doneS2S					=> doneS2S,
										tc						=> tc,
										rst						=> rst,
										enableUpdateA0_start	=> enableUpdateA0_start,
										enableUpdateK			=> enableUpdateK,
										enableUpdateDelta		=> enableUpdateDelta,	
										enableUpdateDeltaT		=> enableUpdateDeltaT,
										enableUpdateHVector0	=> enableUpdateHVector0,
										enableUpdateHVector1	=> enableUpdateHVector1,
										enableUpdateShapePt		=> enableUpdateShapePt,
										enableUpdateDelta4K		=> enableUpdateDelta4K,
										enableUpdateK_1			=> enableUpdateK_1,
										enableUpdateOffset		=> enableUpdateOffset,
										enableUpdateJ12			=> enableUpdateJ12,
										enableUpdateJ21			=> enableUpdateJ21,
										enableUpdateXOld0		=> enableUpdateXOld0,
										enableUpdateXOld1		=> enableUpdateXOld1,
										enableUpdateYOld0		=> enableUpdateYOld0,
										enableUpdateYOld1		=> enableUpdateYOld1,
										enableUpdateXNew		=> enableUpdateXNew,
										startPE					=> startPE,
										NewIterationPE			=> NewIterationPE,
										LastIterationPE			=> LastIterationPE,
										StartPA					=> startPA,
										NewIterationPA			=> NewIterationPA,
										LastIterationPA			=> LastIterationPA,
										startS2S				=> startS2S,
										NewIterationS2S			=> NewIterationS2S,
										LastIterationS2S		=> LastIterationS2S,
										ce 						=> ce,
										done					=> done
										);

end architecture structure;