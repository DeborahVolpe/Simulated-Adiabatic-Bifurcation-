library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- behavioural counter, generic for number of bits
-- synchronous reset and terminal counter available

entity counterNStop is
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
end entity counterNStop;

architecture behaviour of counterNStop is

	-- used signal 
	signal counter_val_unsigned				: unsigned (N-1 downto 0);
	signal onesUnsigned						: unsigned (N-1 downto 0);
	signal ones								: std_logic_vector(N-1 downto 0);
	signal ZerosUnsigned					: unsigned (N-1 downto 0);
	signal Zeros							: std_logic_vector(N-1 downto 0);
	signal Ands								: std_logic_vector(N-1 downto 0);
	signal tc_in							: std_logic;

	begin
	
		ones(0)						<= '1';
		ones(N-1 downto 1)			<= (others => '0');
		onesUnsigned				<= unsigned(ones);
		
		
		Zeros 						<= (others => '0');
		ZerosUnsigned				<= unsigned(Zeros);
		
		
		counter_val 				<= std_logic_vector(counter_val_unsigned);
			
		-- increment counter every clock period
		counter_process:    
			process(clk)
			begin			
				if rising_edge(clk) then
					if rst = '0' then
						counter_val_unsigned	<= ZerosUnsigned;
					elsif ce = '1' then 
						if tc_in = '1' then
							counter_val_unsigned	<= to_unsigned(0,N);
						else
							counter_val_unsigned 	<= counter_val_unsigned + onesUnsigned;
						end if;
					end if;
				end if;
			end process;



		Ands(0) 					<= counter_val_unsigned(0) xnor last_val(0);
		-- terminal count is the end of all bits
		g1 : for i in 1 to N-1 generate
			Ands(i) 	<=	Ands(i-1) and (counter_val_unsigned(i) xnor last_val(i));
		end generate;
		
		tc							<= Ands(N-1);
		tc_in						<= Ands(N-1);
			
end  architecture behaviour;