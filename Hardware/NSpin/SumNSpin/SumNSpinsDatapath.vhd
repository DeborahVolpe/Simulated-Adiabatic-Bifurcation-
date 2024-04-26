library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SumNSpinsDatapath is
	generic	(
			INT 	: integer := 3;
			FRAC	: integer := 9;
			M		: integer := 2; -- Address lenght
			NSPIN	: integer := 3 -- Number of Spin
			);
	port	(
			clk  					:	in std_logic;
			rst_parameter			: 	in std_logic;
			rst_CSA					:	in std_logic;
			rst						: 	in std_logic;
			enableCSAB				:	in std_logic;
			enableAdderA			:	in std_logic;
			write_enable			: 	in std_logic; -- To enable writing in RF
			ce						:	in std_logic; -- counter enable
			selWrite				: 	in std_logic;
			J_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
			x1_in					: 	in std_logic_vector(INT+FRAC-1 downto 0);
			x2_in					:	in std_logic_vector(INT+FRAC-1 downto 0);
			tc						: 	out std_logic;
			odd_Even_n				: 	out std_logic;
			SumFinal				: 	out std_logic_vector(INT+FRAC-1 downto 0);
			xSel					:	out std_logic_vector(M-2 downto 0)
			);
end entity SumNSpinsDatapath;

architecture Structure of SumNSpinsDatapath is

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
	
	component RegisterFile
		generic ( 
				N 			: positive := 32; -- register file data length
				M 			: positive := 5; -- register file address length
				L			: positive := 30 -- number of element in the register file
				);
		port	(
				Data_in			: in std_logic_vector ( N-1 downto 0 );
				write_enable 	: in std_logic ;
				rd_r1			: in std_logic_vector ( M-1 downto 0 );
				rd_r2			: in std_logic_vector ( M-1 downto 0 );
				wr_reg			: in std_logic_vector ( M-1 downto 0 );
				reset_n			: in std_logic;
				clk				: in std_logic;
				out_r1			: out std_logic_vector( N-1 downto 0);
				out_r2			: out std_logic_vector( N-1 downto 0)
				);
	end component RegisterFile;
	
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
	
	component CSA
		generic	(
				 N				:  integer
				);
		port	(
				a				: in std_logic_vector(N-1 downto 0);
				b				: in std_logic_vector(N-1 downto 0);
				c				: in std_logic_vector(N-1 downto 0);
				sum				: out std_logic_vector(N-1 downto 0);
				carry			: out std_logic_vector(N-1 downto 0)
				);
	end component CSA;
	
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
		port(
			a			: in std_logic_vector(N-1 downto 0);
			b 			: in std_logic_vector(N-1 downto 0);
			carry_in 	: in std_logic;
			sum 		: out std_logic_vector(N-1 downto 0)
			);
	end component adder;

	
	--used signal	
	--register file
	signal rd_r1, rd_r2												: std_logic_vector(M-1 downto 0);
	signal wr_reg													: std_logic_vector(M-1 downto 0);
	signal out_r1, out_r2											: std_logic_vector(INT+FRAC-1 downto 0);
	
	--counter 
	signal counter_val												: std_logic_vector(M-2 downto 0);
	
	-- Multiplier A
	signal MulAOut													: std_logic_vector(2*(INT+FRAC)-1 downto 0);	
	-- Multiplier B
	signal MulBOut													: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	
	--CSA A
	signal SumA														: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	signal CarryA													: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	signal CarryAToSum												: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	
	-- CSA B
	signal SumB														: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	signal CarryB													: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	signal SumSample												: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	signal CarrySample												: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	signal CarrySampleToSum											: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	
	
	--Final Adder
	signal AOut														: std_logic_vector(2*(INT+FRAC)-1 downto 0);
	signal AOutSample												: std_logic_vector(INT+FRAC-1 downto 0);
	
	signal odd_Even_n_temp											: std_logic_vector(0 downto 0);
	
	begin
		-------------------------REGISTER FILE-------------------------------------
			-- Register file that contains the necessary matrix coefficient
			-- This is fulled at the beginning and then only read to perform operation
			mux2 : bN_2to1mux 
					generic map	(
								N				=> M
								)
					port map	( 
								x				=> rd_r1,
								y				=> rd_r2,
								s				=> selWrite,
								output			=> wr_reg
								);
			
			RF:  RegisterFile
					generic map ( 
								N 				=> INT+FRAC,
								M 				=> M,
								L				=> NSPIN-1 -- There is in any column a null element
								)				-- This is not considered
					port map	(
								Data_in			=> J_in,
								write_enable 	=> write_enable,
								rd_r1			=> rd_r1,
								rd_r2			=> rd_r2,
								wr_reg			=> wr_reg,
								reset_n			=> rst_parameter,
								clk				=> clk,
								out_r1			=> out_r1,
								out_r2			=> out_r2
								);
								
		------------------------COUNTER------------------------------------------------------
			
			Case1: if M /= 1 generate
				C: counterNStop
						generic map	(
									N		 		=> M-1
									)
						port map	( 
									clk        		=> clk,
									rst        		=> rst,
									ce         		=> ce,
									last_val		=> std_logic_vector(to_unsigned((NSPIN-1)/2-1+((NSPIN-1) mod 2), M-1)),
									counter_val		=> counter_val,
									tc         		=> tc
									);
									
				xSel			<= counter_val;
				rd_r1			<= counter_val & '0';
				rd_r2			<= counter_val & '1';
			end generate;
			
			Case2: if M = 1 generate
				xSel			<= "0";
				rd_r1			<= "0";
				rd_r2			<= "1";
				tc				<= '1';
			end generate;
			
			odd_Even_n_temp	<= std_logic_vector(to_unsigned(((NSPIN) mod 2),1)); -- Said if the number of spin to record is odd or even
			odd_Even_n		<= odd_Even_n_temp(0);
								
		--------------------------MULTIPLIER A----------------------------------------------------
		-- This multiplier is used to perform partial product of matrix-vector operation 
		
			-- multiplier A
			Ma : multiplier_n
					generic map (
								N			=> INT+FRAC
								)
					port map	( 
								A			=> out_r1,
								B 			=> x1_in,
								P    		=> MulAOut
								);
							
			
		--------------------------MULTIPLIER B----------------------------------------------------
		-- This multiplier is used to perform partial product of matrix-vector operation 
		
			-- multiplier B
			Mb : multiplier_n
					generic map (
								N			=> INT+FRAC
								)
					port map	( 
								A			=> out_r2,
								B 			=> x2_in,
								P    		=> MulBOut
								);
			
		--------------------------CSAA----------------------------------------------------------------
			-- This CSA sum the output of the first multiplier and carry and sum of the previous turn in
			-- the register
			CSAA : CSA
					generic	map	(
								N			=> 2*(INT+FRAC)
								)
					port map	(
								a				=> MulAOut,
								b				=> SumSample,
								c				=> CarrySampleToSum,
								sum				=> SumA,
								carry			=> CarryA
								);
								
			CarryAToSum				<= CarryA(2*(INT+FRAC)-2 downto 0) & '0';
		
		--------------------------CSAB----------------------------------------------------------------------
			-- This CSA sum the output of the second multiplier and carry and sum of CSA A
			CSAB : CSA 
					generic	map	(
								N			=> 2*(INT+FRAC)
								)
					port map	(
								a				=> MulBOut,
								b				=> SumA,
								c				=> CarryAToSum,
								sum				=> SumB,
								carry			=> CarryB
								);		

			SumBRegister :reg_s_reset_enable
					generic map	(
								N 		=> 2*(INT+FRAC)
								) 
					port map	(
								D		=> SumB,
								RST_n	=> rst_CSA, 
								en		=> enableCSAB,
								clk		=> clk,
								Q		=> SumSample      
								);
								
			CarryBRegister :reg_s_reset_enable
					generic map	(
								N 		=> 2*(INT+FRAC)
								) 
					port map	(
								D		=> CarryB,
								RST_n	=> rst_CSA, 
								en		=> enableCSAB,
								clk		=> clk,
								Q		=> CarrySample      
								);
			
			CarrySampleToSum		<= CarrySample(2*(INT+FRAC)-2 downto 0) & '0';
								
		--------------------------FINAL ADDER---------------------------------------------------------------
			-- Final sum of Sum and CarrySample, to multiply with xi
			AdderA : adder
					generic map (
								N			=> 2*(INT+FRAC)
								)
					port map	(
								a			=> SumSample,
								b 			=> CarrySampleToSum,
								carry_in 	=> '0',
								sum 		=> AOut
								);
								
			AdderARegister :reg_s_reset_enable
					generic map	(
								N 		=> INT+FRAC
								) 
					port map	(
								D		=> AOut((2*(INT+FRAC)-(1+INT)) downto FRAC),
								RST_n	=> rst_parameter, 
								en		=> enableAdderA,
								clk		=> clk,
								Q		=> AOutSample      
								);
					
					
			SumFinal		<=  AOutSample;
				

end architecture Structure;