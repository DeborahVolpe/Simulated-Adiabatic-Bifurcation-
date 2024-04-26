library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProcessorAdiabaticDataPath is
	generic(
			INT 	: positive := 3;
			FRAC	: positive := 9
			);
	port	(
			clk  					:	in std_logic;
			rst_parameter			: 	in std_logic;
			enableUpdateA0			: 	in std_logic;
			enableUpdatep			: 	in std_logic;
			enableUpdateK			: 	in std_logic;
			enableUpdateDelta		: 	in std_logic;
			enableUpdateDeltaT		:	in std_logic;
			enableUpdateSum			: 	in std_logic;
			enableUpdateHVectori_xi	: 	in std_logic;
			enableUpdateMulA		: 	in std_logic;
			enableUpdateMulB		: 	in std_logic;
			enableUpdateAddA		:	in std_logic;
			enableUpdateAddA2		: 	in std_logic;
			enableUpdateX			:	in std_logic;
			enableUpdateY			:	in std_logic;
			enableUpdateXNew		:	in std_logic;
			sub_add_n				: 	in std_logic;
			selX					: 	in std_logic;
			selY					: 	in std_logic_vector (1 downto 0);
			selMa_mux_A				: 	in std_logic_vector (1 downto 0);
			selMa_mux_B				: 	in std_logic_vector (1 downto 0);
			selMb_mux_A				: 	in std_logic;
			selMb_mux_B				: 	in std_logic;
			selAa_mux_A				:	in std_logic_vector (2 downto 0);
			selAa_mux_B				:	in std_logic_vector (1 downto 0);
			A0 						: 	in std_logic_vector ((INT+FRAC)-1 downto 0);
			p 						: 	in std_logic_vector ((INT+FRAC)-1 downto 0);
			K 						:	in std_logic_vector ((INT+FRAC)-1 downto 0);
			Delta 					:	in std_logic_vector ((INT+FRAC)-1 downto 0);
			deltaT					:	in std_logic_vector ((INT+FRAC)-1 downto 0);
			sum  					:   in std_logic_vector ((INT+FRAC)-1 downto 0);
			hVectori				:	in std_logic_vector ((INT+FRAC)-1 downto 0);
			xOld_in					:	in std_logic_vector ((INT+FRAC)-1 downto 0);
			yOld_in					:	in std_logic_vector	((INT+FRAC)-1 downto 0);
			xNew					:	out std_logic_vector ((INT+FRAC)-1 downto 0);
			yNew					: 	out std_logic_vector ((INT+FRAC)-1 downto 0)
			);
end entity ProcessorAdiabaticDataPath;

architecture behaviour of ProcessorAdiabaticDataPath is

	-- used component

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
	
	component complement_1
		generic	( N : POSITIVE:=8);
		port 	( 
				B			: in std_logic_vector (N-1 downto 0);
				sub_add_n 	: in std_logic;
				B_c 		: out std_logic_vector (N-1 downto 0)
				);
	end component complement_1;
	
	component bN_6to1mux
		generic	(N : integer := 8);
		port 	(  
				x		: in std_logic_vector (N-1 downto 0); --000
				y		: in std_logic_vector (N-1 downto 0); --001
				z		: in std_logic_vector (N-1 downto 0); --010
				k		: in std_logic_vector (N-1 downto 0); --011
				h		: in std_logic_vector (N-1 downto 0); --100
				g		: in std_logic_vector (N-1 downto 0); --101
				s		: in std_logic_vector (2 downto 0);
				output	: out std_logic_vector (N-1 downto 0)
				);
	end component bN_6to1mux;

	
	component bN_5to1mux
		generic	(N : integer := 8);
		port 	(  
				x		: in std_logic_vector (N-1 downto 0); --000
				y		: in std_logic_vector (N-1 downto 0); --001
				z		: in std_logic_vector (N-1 downto 0); --010
				k		: in std_logic_vector (N-1 downto 0); --011
				h		: in std_logic_vector (N-1 downto 0); --100
				s		: in std_logic_vector (2 downto 0);
				output	: out std_logic_vector (N-1 downto 0)
				);
	end component bN_5to1mux;
	
	component bN_4to1mux
		generic	(N : integer := 8);
		port 	(  
				x		: in std_logic_vector (N-1 downto 0); --00
				y		: in std_logic_vector (N-1 downto 0); --01
				z		: in std_logic_vector (N-1 downto 0); --10
				k		: in std_logic_vector (N-1 downto 0); --11
				s		: in std_logic_vector (1 downto 0);
				output	: out std_logic_vector (N-1 downto 0)
				);
	end component bN_4to1mux;
	
	component bN_3to1mux
		generic	(N : integer := 8);
		port 	(  
				x		: in std_logic_vector (N-1 downto 0); --00
				y		: in std_logic_vector (N-1 downto 0); --01
				z		: in std_logic_vector (N-1 downto 0); --10
				s		: in std_logic_vector (1 downto 0);
				output	: out std_logic_vector (N-1 downto 0)
				);
	end component bN_3to1mux;
	
	component bN_2to1mux is
		generic (N : positive := 8);
		port	( 
				x		: in std_logic_vector (N-1 downto 0); --0
				y		: in std_logic_vector (N-1 downto 0); --1
				s		: in std_logic;
				output	: out std_logic_vector(N-1 downto 0)
			  );
	end component bN_2to1mux;
	
	component adder
		generic ( N : positive := 8);
		port	(
				a			: in std_logic_vector(N-1 downto 0);
				b 			: in std_logic_vector(N-1 downto 0);
				carry_in 	: in std_logic;
				sum 		: out std_logic_vector(N-1 downto 0)
				);
	end component adder;
	
	component multiplier_n
		generic ( N : positive:=4);
		port 	( 
				A		: in std_logic_vector (N-1 downto 0 );
				B 		: in std_logic_vector (N-1 downto 0 );
				P    	: out std_logic_vector (2*N-1 downto 0)
				);
	end component multiplier_n;
	
	
	--used signal
	--parameter's registers output 
	signal A0_out, p_out, Delta_out, hVectori_out				: std_logic_vector((INT+FRAC)-1 downto 0);
	signal deltaT_out, sum_out										: std_logic_vector((INT+FRAC)-1 downto 0);
	signal K_out													: std_logic_vector((INT+FRAC)-1 downto 0);
	
	--oscillators trajectory old
	signal xOld, yOld												: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal xOldTemp, yOldTemp										: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal xNew_out													: std_logic_vector ((INT+FRAC)-1 downto 0);
	
	-- Multiplier A signal
	signal MulAOutSample											: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal MulAOut													: std_logic_vector (2*(INT+FRAC)-1 downto 0);
	signal Ma_mux_A_out												: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal Ma_mux_B_out												: std_logic_vector ((INT+FRAC)-1 downto 0);	

	-- Multiplier B signal
	signal MulBOutSample											: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal MulBOut													: std_logic_vector (2*(INT+FRAC)-1 downto 0);
	signal Mb_mux_A_out												: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal Mb_mux_B_out												: std_logic_vector ((INT+FRAC)-1 downto 0);		
	
	--Adder A signal
	signal AdderASample, AdderASample2D								: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal Aa_mux_A_out, Aa_mux_B_out, Aa_mux_B_out_c				: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal AdderA													: std_logic_vector ((INT+FRAC)-1 downto 0);
	
	begin
	
	---- X and Y Old registers
	
		-- X input selector: 0 at the beginning of the algorithm
		-- 1 in the other iteration
		xOldSelector: bN_2to1mux 
					generic map	(
								N		=> (INT+FRAC)
								)
					port map	( 
								x		=> xOld_in,
								y		=> xNew_out,
								s		=> selX,
								output	=> xOldTemp
								);
				  
		-- X : To update every iteration
		XRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> xOldTemp,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateX,
								clk		=> clk,
								Q		=> xOld       
								);
								
		-- Y input selector: 0 at the beginning of the algorithm
		-- 1 in the other iteration
		yOldSelector: bN_3to1mux 
					generic map	(
								N		=> (INT+FRAC)
								)
					port map	( 
								x		=> YOld_in,
								y		=> AdderA,
								z		=> AdderASample, 
								s		=> sely,
								output	=> yOldTemp
								);
								
		-- Y : To update every iteration
		YRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> yOldTemp,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateY,
								clk		=> clk,
								Q		=> yOld       
								);
	
	---- X new register
		-- Xnew : Sample when the value is ready
		XNewRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> AdderA,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateXNew,
								clk		=> clk,
								Q		=> xNew_out       
								);
		
		
	
	---- Set of parameters registers
		-- First parameter A0: To update every iteration
		A0Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> A0,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateA0,
								clk		=> clk,
								Q		=> A0_out       
								);
								
		-- Second parameter p: To update every iteration
		pRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> p,
								RST_n	=> rst_parameter, 
								en		=> enableUpdatep,
								clk		=> clk,
								Q		=> p_out       
								);
								
		-- Third parameter K: To update at the beginning
		KRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> K,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateK,
								clk		=> clk,
								Q		=> K_out       
								);
								
		-- Fouth parameter Delta: To update at the beginning
		DeltaRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Delta,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateDelta,
								clk		=> clk,
								Q		=> Delta_out       
								);
								
		-- sixth parameter deltaT: To update at the the beginning
		deltaTRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> deltaT,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateDeltaT,
								clk		=> clk,
								Q		=> deltaT_out       
								);
								
								
		-- sum (xi*X(j)*JMatrix[i,j]): To update at the beginning
		sumRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> sum,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateSum,
								clk		=> clk,
								Q		=> sum_out       
								);
								
		-- HVector : To update at the beginning
		HVectorReg :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> hVectori,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateHVectori_xi,
								clk		=> clk,
								Q		=> hVectori_out       
								);
							
	---------------------------------------------MULTIPLIER A--------------------------------------------------
	---- First multiplier and his multiplexers and sample register 
		-- This perform:
		-- Delta*Y[i] in the first state
		-- (Delta*Y[i]-->From MultiplierA)*deltaT in the second state
		-- nothing in the third state
		-- K*xNew in the fourth state
		-- (K*xNew-->From MultiplierA)*xNew in the fifth state
		-- ((K*xNew-->From MultiplierA)*xNew --> From MultiplierA)*xNew the sixth state
		-- Nothing in the seventh state
		-- ([K*xNew^3+(Delta-p)* xi-epsilon*sum(xi*X(j)*JMatrix[i,j]) +2xi*A0*HVector]--> From AdderA)*deltaT in the eigth state 
		-- Nothing in the ninth state 
		
		-- multiplexer a
		Ma_mux_A:	 bN_4to1mux
					generic	map (
								N 			=> (INT+FRAC)
								)
					port map 	(  
								x			=> Delta_out, --00
								y			=> MulAOutSample, --01
								z			=> K_out, --10
								k			=> AdderASample, --11
								s			=> selMa_mux_A,
								output		=> Ma_mux_A_out
								);
		
		-- multiplexer b		
		Ma_mux_B:	 bN_4to1mux
					generic	map (
								N 			=> (INT+FRAC)
								)
					port map 	(  
								x			=> yOld, --00
								y			=> deltaT_out, --01
								z			=> xNew_out, --10
								k			=> MulAOutSample, --11
								s			=> selMa_mux_B,
								output		=> Ma_mux_B_out
								);
	
		-- multiplier A
		Ma :		multiplier_n
					generic map (
								N			=> (INT+FRAC)
								)
					port map	( 
								A			=> Ma_mux_A_out,
								B 			=> Ma_mux_B_out,
								P    		=> MulAOut
								);
		
		-- multiplier A sample register
		MaOutReg :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> MulAOut((2*(INT+FRAC)-(1+INT)) downto FRAC),
								RST_n	=> rst_parameter, 
								en		=> enableUpdateMulA,
								clk		=> clk,
								Q		=> MulAOutSample    
								);

	---------------------------------------------MULTIPLIER B--------------------------------------------------
	---- Second multiplier and his multiplexers and sample register 
		-- This perform:
		-- HVector_xi*A0 in the first state
		-- nothing in the third state
		-- xNew*(Delta-p-->From Adder2Delay) in the fourth state
		-- nothing in the fifth state
		-- nothing in the sixth state
		-- nothing in the eigth state
		-- nothing in the ninth state
		
		-- multiplexer a 
		Mb_mux_A:	 bN_2to1mux
					generic	map (
								N 			=> (INT+FRAC)
								)
					port map 	(  
								x			=> hVectori_out, --0
								y			=> AdderASample, --1
								s			=> selMb_mux_A,
								output		=> Mb_mux_A_out
								);
		
		
		-- multiplexer b		
		Mb_mux_B:	 bN_2to1mux
					generic	map (
								N 			=> (INT+FRAC)
								)
					port map 	(  
								x			=> A0_out, --0
								y			=> AdderASample2D, --1
								s			=> selMb_mux_B,
								output		=> Mb_mux_B_out
								);
								
		-- multiplier B
		Mb :		multiplier_n
					generic map (
								N			=> (INT+FRAC)
								)
					port map	( 
								A			=> Mb_mux_A_out,
								B 			=> Mb_mux_B_out,
								P    		=> MulBOut
								);
		
		-- multiplier B sample register
		MbOutReg :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> MulBOut((2*(INT+FRAC)-(1+INT)) downto FRAC),
								RST_n	=> rst_parameter, 
								en		=> enableUpdateMulB,
								clk		=> clk,
								Q		=> MulBOutSample    
								);

	---------------------------------------------ADDER A--------------------------------------------------
	---- First multiplier and his multiplexers and sample register 
		-- This perform:
		-- Delta-p in the first state
		-- nothing in the second state
		-- xOld - (Delta*Y*deltaT --> From Multiplier A)-in the third state
		-- Sum+(HVector*2*xi*A0 --> From MultiplierB) in the fourth state
		-- ((Delta-p)*xNew --> From MultiplierB)+(Sum+(HVector*2*xi*A0)--> From Adder A)  in the fifth state
		-- nothing in the sixth
		-- (((Delta-p)*xNew)+(Sum+(HVector*2*xi*A0))) --> From Adder A + (xNew*xNew*xNew*K)--> From Multiplier A in the seventh state
		-- nothing in the eight state 
		-- yOld-((K*xNew^3+(Delta-p)* xi-epsilon*sum(xi*X(j)*JMatrix[i,j]) +2xi*A0*HVector)*deltaT)--> From Multiplier A in the ninth state	
		
		-- multiplexer a
		Aa_mux_A:	 bN_5to1mux
					generic	map (
								N 			=> (INT+FRAC)
								)
					port map 	(  
								x			=> Delta_out, --000
								y			=> xOld, --001
								z			=> AdderASample, --010
								k 			=> Sum_out, -- 011
								h			=> yOld, -- 100
								s			=> selAa_mux_A,
								output		=> Aa_mux_A_out
								);
		
		-- multiplexer b		
		Aa_mux_B:	 bN_3to1mux
					generic	map (
								N 			=> (INT+FRAC)
								)
					port map 	(  
								x			=> p,--00
								y			=> MulAOutSample, --01
								z			=> MulBOutSample, --10
								s			=> selAa_mux_B,
								output		=> Aa_mux_B_out
								);
								
		-- 1's complementer
		Adder1sComp :complement_1
					generic map	(
								N			=> (INT+FRAC)
								)
					port map 	( 
								B			=> Aa_mux_B_out,
								sub_add_n 	=> sub_add_n,
								B_c 		=> Aa_mux_B_out_c
								);
		-- Adder A						
		Aadder:	adder
					generic map ( 
								N			=> (INT+FRAC)
								)
					port map	(
								a			=> Aa_mux_A_out,
								b 			=> Aa_mux_B_out_c,
								carry_in 	=> sub_add_n,
								sum 		=> AdderA
								);
								
		-- Adder A sample register
		AaOutReg :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> AdderA,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateAddA,
								clk		=> clk,
								Q		=> AdderASample   
								);	

		-- Adder A sample register
		AaOutReg2D :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> AdderASample,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateAddA2,
								clk		=> clk,
								Q		=> AdderASample2D 
								);			
		
	----xNew and yNew outputs
		
		-- xNew, ready from the fouth state
		xNew	<=	xNew_out;
		
		-- yNew , ready from the end of the eigth state
		yNew	<= 	AdderA;
		
		

end architecture behaviour;