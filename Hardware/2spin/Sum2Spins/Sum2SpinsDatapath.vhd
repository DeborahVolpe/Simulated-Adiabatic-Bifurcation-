library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Sum2SpinsDatapath is
	generic(
			INT 	: positive := 3;
			FRAC	: positive := 9
			);
	port	(
			clk  					:	in std_logic;
			rst_parameter			: 	in std_logic;
			enableUpdateJ12			: 	in std_logic;
			enableUpdateJ21			:	in std_logic;
			enableUpdateX0			:	in std_logic;
			enableUpdateX1			:	in std_logic;
			enableUpdateMulA		:	in std_logic;	
			enableUpdateMulB		:	in std_logic;
			J12_xi					:	in std_logic_vector(INT+FRAC-1 downto 0);
			J21_xi					: 	in std_logic_vector(INT+FRAC-1 downto 0);
			X0						:	in std_logic_vector(INT+FRAC-1 downto 0);
			X1						:	in std_logic_vector(INT+FRAC-1 downto 0);
			Sum0 					:	out std_logic_vector(INT+FRAC-1 downto 0);
			Sum1					:	out std_logic_vector(INT+FRAC-1 downto 0)
			);
end entity Sum2SpinsDatapath;

architecture behaviour of Sum2SpinsDatapath is

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
	signal J12_xi_out, J21_xi_out									: std_logic_vector(INT+FRAC-1 downto 0);
	signal X0_out, X1_out											: std_logic_vector(INT+FRAC-1 downto 0);
	
	
	-- Multiplier A signal
	signal MulAOutSample											: std_logic_vector (INT+FRAC-1 downto 0);
	signal MulAOut													: std_logic_vector (2*(INT+FRAC)-1 downto 0);	

	-- Multiplier B signal
	signal MulBOutSample											: std_logic_vector (INT+FRAC-1 downto 0);
	signal MulBOut													: std_logic_vector (2*(INT+FRAC)-1 downto 0);		
	
	
	begin
	
	---- Matrix J component elements registers
	
		-- J12 matrix element register. To update at the beginning
		J12Register :reg_s_reset_enable
					generic map	(
								N 		=> INT+FRAC
								) 
					port map	(
								D		=> J12_xi,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateJ12,
								clk		=> clk,
								Q		=> J12_xi_out      
								);
								
		-- J21 matrix element register. To update at the beginning
		J21Register :reg_s_reset_enable
					generic map	(
								N 		=> INT+FRAC
								) 
					port map	(
								D		=> J21_xi,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateJ21,
								clk		=> clk,
								Q		=> J21_xi_out      
								);
								
								
								
		-- X0 matrix element register. To update every iteration
		X0Register :reg_s_reset_enable
					generic map	(
								N 		=> INT+FRAC
								) 
					port map	(
								D		=> X0,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateX0,
								clk		=> clk,
								Q		=> X0_out      
								);
								
		-- X1 matrix element register. To update every iteration
		X1Register :reg_s_reset_enable
					generic map	(
								N 		=> INT+FRAC
								) 
					port map	(
								D		=> X1,
								RST_n	=> rst_parameter, 
								en		=> enableUpdateX1,
								clk		=> clk,
								Q		=> X1_out      
								);
								
								
	---------------------------------------------MULTIPLIER A--------------------------------------------------	
	-- The first multiplier perform X1*J12xi
							
		-- multiplier A
		Ma :		multiplier_n
					generic map (
								N			=> INT+FRAC
								)
					port map	( 
								A			=> J12_xi_out,
								B 			=> X1_out,
								P    		=> MulAOut
								);

		-- multiplier A sample register
		MaOutReg :reg_s_reset_enable
					generic map	(
								N 		=> INT+FRAC
								) 
					port map	(
								D		=> MulAOut((2*(INT+FRAC)-(1+INT)) downto FRAC),
								RST_n	=> rst_parameter, 
								en		=> enableUpdateMulA,
								clk		=> clk,
								Q		=> MulAOutSample    
								);	

		Sum0		<= MulAOutSample;
	
	
	---------------------------------------------MULTIPLIER B--------------------------------------------------
	-- The first multiplier perform X0*J21xi
							
		-- multiplier B
		Mb :		multiplier_n
					generic map (
								N			=> INT+FRAC
								)
					port map	( 
								A			=> J21_xi_out,
								B 			=>  X0_out,
								P    		=> MulBOut
								);

		-- multiplier A sample register
		MbOutReg :reg_s_reset_enable
					generic map	(
								N 		=> INT+FRAC
								) 
					port map	(
								D		=> MulBOut((2*(INT+FRAC)-(1+INT)) downto FRAC),
								RST_n	=> rst_parameter, 
								en		=> enableUpdateMulB,
								clk		=> clk,
								Q		=> MulBOutSample    
								);	

		Sum1		<= MulBOutSample;
												
end architecture behaviour;