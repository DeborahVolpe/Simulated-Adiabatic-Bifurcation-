library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pA0updaterDatapath is
	generic(
			INT 	: positive := 3;
			FRAC	: positive := 9
			);
	port	(
			clk  					:	in std_logic;
			rst_parameter			: 	in std_logic;
			clean 					: 	in std_logic;
			enableUpdateA0_start	: 	in std_logic;
			enableUpdateShapePt		:	in std_logic;
			enableUpdateDelta4K		:	in std_logic;
			enableUpdateK_1			:	in std_logic;
			enableUpdateOffset		:	in std_logic;
			enableUpdateA0			:	in std_logic;
			enableUpdatept			:	in std_logic;
			enableUpdateMulA		:	in std_logic;
			enableUpdateAddA		:	in std_logic;
			enableUpdateSqA			:	in std_logic;
			sub_add_n				:	in std_logic;
			startSquare				:	in std_logic;
			selA0out				:	in std_logic;
			selAa_mux_A				:	in std_logic_vector(1 downto 0);
			selAa_mux_B				: 	in std_logic_vector(1 downto 0);
			A0_start				:	in std_logic_vector((INT+FRAC)-1 downto 0);
			ShapePt					: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			Delta4K					: 	in std_logic_vector((INT+FRAC)-1 downto 0);
			K_1						:	in std_logic_vector((INT+FRAC)-1 downto 0);
			Offset					:	in std_logic_vector((INT+FRAC)-1 downto 0);
			readySquare				:	out std_logic;
			inv 					:	out std_logic;
			pt_out					:	out std_logic_vector((INT+FRAC)-1 downto 0);
			A0_out					:	out std_logic_vector((INT+FRAC)-1 downto 0)
			);
end entity pA0updaterDatapath;

architecture behaviour of pA0updaterDatapath is

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
		generic	( N : positive:=8);
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
	
	component bN_2to1mux 
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
	
	component square_generic
		generic(N 	: positive := 32; --input bit number
				M 	: positive := 16 --number of output
				);
		port    (
				P   	: in std_logic_vector(N-1 downto 0);
				clk		: in std_logic;
				start	: in std_logic;
				R		: out std_logic_vector(M+1 downto 0); -- M+2 length of remainder
				inv		: out std_logic; -- it said if the results is valid ( in case of negative input the results are not valid ) 
				ready	: out std_logic;
				U		: buffer std_logic_vector(M downto 0)
				);
	end component square_generic;
	
	--used signal
	--parameter's registers output
	signal A0_start_out												: std_logic_vector((INT+FRAC)-1 downto 0);
	signal ShapePt_out, Delta4K_out									: std_logic_vector((INT+FRAC)-1 downto 0);
	signal K_1_out, Offset_out										: std_logic_vector((INT+FRAC)-1 downto 0);
	
	-- Multiplier A signal
	signal MulAOutSample											: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal MulAOut													: std_logic_vector (2*(INT+FRAC)-1 downto 0);
	
	--Adder A signal
	signal AdderASample												: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal Aa_mux_A_out, Aa_mux_B_out, Aa_mux_B_out_c				: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal AdderA													: std_logic_vector ((INT+FRAC)-1 downto 0);
	
	-- Square A signal 
	signal SquareAInput												: std_logic_vector ((INT+FRAC + (INT mod 2) + (FRAC mod 2) -1) downto 0); -- sign extension and add zeros at the end
	signal SquareA													: std_logic_vector (((INT+FRAC+(INT mod 2)+(FRAC mod 2))/2) downto 0);
	signal SquareASample, SquareASampleIn							: std_logic_vector ((INT+FRAC)-1 downto 0);
	signal Remainder												: std_logic_vector (((INT+FRAC+(INT mod 2)+(FRAC mod 2))/2)+1 downto 0);
	
	--pt and A0 signal
	signal ptOld, A0Old												: std_logic_vector ((INT+FRAC)-1 downto 0);
	
	
	begin
	
		----pt and A0 registers
		-- pt : To update every iteration
		ptRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> AdderA,
								RST_n	=> clean, 
								en		=> enableUpdatept,
								clk		=> clk,
								Q		=> ptOld       
								);
								
		-- A0 : To update every iteration
		A0Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> AdderA,
								RST_n	=> clean, 
								en		=> enableUpdateA0,
								clk		=> clk,
								Q		=> A0Old       
								);
								
	
		---- Set of parameters registers
		-- First parameter A0_start: To update only at the beginning
		A0_startRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> A0_start,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateA0_start,
								clk		=> clk,
								Q		=> A0_start_out       
								);
								
		-- Second parameter ShapePt: To update only at the beginning
		ShapePtRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> ShapePt,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateShapePt,
								clk		=> clk,
								Q		=> ShapePt_out       
								);
								
		-- Third parameter Delta+4K: To update only at the beginning
		Delta4KRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Delta4K,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateDelta4K,
								clk		=> clk,
								Q		=> Delta4K_out       
								);
								
		-- Fourth parameter 1/K: To update only at the beginning
		K_1Register :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> K_1, -- 1/K
								RST_n	=> rst_parameter, 
								en		=> enableUpdateK_1,
								clk		=> clk,
								Q		=> K_1_out       
								);
								
		-- Fifth parameter offset: To update only at the beginning
		OffsetRegister :reg_s_reset_enable
					generic map	(
								N 		=> (INT+FRAC)
								) 
					port map	(
								D		=> Offset,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateOffset,
								clk		=> clk,
								Q		=> Offset_out       
								);
								
	---------------------------------------------MULTIPLIER A--------------------------------------------------
	---- First multiplier and sample register 
		-- This perform:
		-- nothing in the first state
		-- nothing in the second state
		-- (p-(Delta+4K) --> Frome AdderA)*K_1 in the third state
		
		-- multiplier A
		Ma :		multiplier_n
					generic map (
								N			=> (INT+FRAC)
								)
					port map	( 
								A			=> K_1_out,
								B 			=> AdderASample,
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
								
	---------------------------------------------ADDER A--------------------------------------------------
	---- First multiplier and his multiplexers and sample register 
		-- This perform:
		-- p+ShapePt in the first state
		-- (p+ShapePt--> From AdderA)-Delta4K in the second state
		-- at the end + offeset

		
		-- multiplexer a
		Aa_mux_A:	 bN_3to1mux
					generic	map (
								N 			=> (INT+FRAC)
								)
					port map 	(  
								x			=> ptOld,
								y			=> AdderASample,
								z			=> SquareASample,
								s			=> selAa_mux_A,
								output		=> Aa_mux_A_out
								);
		
		-- multiplexer b		
		Aa_mux_B:	 bN_3to1mux
					generic	map (
								N 			=> (INT+FRAC)
								)
					port map 	(  
								x			=> ShapePt,
								y			=> Delta4K_out,
								z			=> Offset_out,
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
								
	---------------------------------------------SQUARE A--------------------------------------------------
		
		-- In case 1 both INT and FRAC are even
		Case1: if ((INT mod 2) = 0 and (FRAC mod 2) = 0) generate
			SquareAInput	<= MulAOutSample;
			SquareASampleIn		<= ((INT+FRAC-1) downto (INT+FRAC-(INT-1-(INT)/2)) =>SquareA((INT+FRAC+(INT mod 2)+(FRAC mod 2))/2)) & SquareA & ((FRAC-(FRAC)/2) -1 downto 0  => '0');
		end generate;
		
		-- In case 2, INT is odd then FRAC is even
		Case2: if ((INT mod 2) = 1 and (FRAC mod 2) = 0) generate
			SquareAInput		<= MulAOutSample(INT+FRAC-1) & MulAOutSample;
			SquareASampleIn		<= ((INT+FRAC-1) downto (INT+FRAC-(INT-1-(INT+1)/2)) =>SquareA((INT+FRAC+(INT mod 2)+(FRAC mod 2))/2)) & SquareA & ((FRAC-(FRAC)/2) -1 downto 0  => '0');
		end generate;
		
		-- In case 4, both INT and FRAC are odd
		Case3: if ((INT mod 2)= 0 and (FRAC mod 2)=1) generate
			SquareAInput		<= MulAOutSample & '0';
			SquareASampleIn		<= ((INT+FRAC-1) downto (INT+FRAC-(INT-1-(INT)/2)) =>SquareA((INT+FRAC+(INT mod 2)+(FRAC mod 2))/2)) & SquareA & ((FRAC-(FRAC+1)/2) -1 downto 0  => '0');
		end generate;
		
		-- In case 4, both INT and FRAC are odd
		Case4: if ((INT mod 2)= 1 and (FRAC mod 2)=1) generate
			SquareAInput																<= MulAOutSample(INT+FRAC-1) & MulAOutSample & '0';
			SquareASampleIn ((INT+FRAC-1) downto (INT+FRAC-(INT-1-(INT+1)/2))) 		<= (others => SquareA((INT+FRAC+(INT mod 2)+(FRAC mod 2))/2));
			SquareASampleIn ((INT+FRAC-(INT-1-(INT+1)/2))-1 downto (FRAC-(FRAC+1)/2)) <= SquareA;
			SquareASampleIn ((FRAC-(FRAC+1)/2) -1 downto 0) 							<= (others => '0');
		end generate;
		
		SQA	: square_generic
					generic map(
								N 			=> (INT+FRAC + (INT mod 2) + (FRAC mod 2)),
								M 			=> ((INT+FRAC + (INT mod 2) + (FRAC mod 2))/2)
								)
					port map 	(
								P   		=> SquareAInput, 
								clk			=> clk,
								start		=> startSquare,
								R			=> Remainder,
								inv			=> inv,
								ready		=> readySquare,
								U			=> SquareA
								);
							
								
		-- Square A sample register
		SQAOutReg :reg_s_reset_enable
					generic map	(
								N 		=> INT+FRAC
								) 
					port map	(
								D		=> SquareASampleIn,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateSqA,
								clk		=> clk,
								Q		=> SquareASample 
								);	
								
	--------------------------------------------------Outputs-----------------------------------------------------------------------------------------
	
	pt_out 		<=	ptOld;
	
	A0Mux : bN_2to1mux 
				generic map	(
							N			=> (INT+FRAC)
							)
				port map 	( 
							x			=> AdderA,
							y			=> A0_start_out,
							s			=> selA0out,
							output		=> A0_out
							);

end architecture behaviour;

