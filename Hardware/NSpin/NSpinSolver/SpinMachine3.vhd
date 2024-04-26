library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.bus_multiplexer_pkg.all;

entity SpinMachine3 is
	port	(
			clk							:	in std_logic;
			reset						:	in std_logic;
			start						:	in std_logic;
			S0							: 	out std_logic;
			S1							:	out std_logic;
			S2							:	out std_logic;
			done						:	out std_logic;
			start_out					:	out std_logic
			);
end entity SpinMachine3;

architecture Structure of SpinMachine3 is

	component SimulatedBifurcationMachine3Spin
		port(
			clk				: in std_logic;
			reset			: in std_logic;
			start			: in std_logic;
			Data_in			: in std_logic_vector(21 downto 0);
			done			: out std_logic;
			xReady			: out std_logic;
			yReady			: out std_logic;
			S				: out std_logic_vector(2 downto 0);
			X_out			: out bus_array(2 downto 0, 21 downto 0);	
			Y_out			: out bus_array(2 downto 0, 21 downto 0)
			);
	end component SimulatedBifurcationMachine3Spin;
	
	signal reset_in							: std_logic;
	signal start_in							: std_logic;
	signal data_in							: std_logic_vector(21 downto 0);
	signal S0_in							: std_logic;
	signal S1_in							: std_logic;
	signal S2_in							: std_logic;
	signal done_in							: std_logic;
	signal xReady							: std_logic;
	signal yReady							: std_logic;
	signal S								: std_logic_vector(2 downto 0);
	signal X_out							: bus_array(2 downto 0, 21 downto 0);
	signal Y_out							: bus_array(2 downto 0, 21 downto 0);

	
	type state_type is (reset_state, start_state, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11,
						data12, data13, data14, data15, data16, data17, data18, data19, wait_done, done_state);
    signal state : state_type;
	
	begin
	
		S0_in		<= S(0);
		S1_in		<= S(1);
		S2_in		<= S(2);
		S0			<= S0_in;
		S1			<= S1_in;
		S2			<= S2_in;
		
	
		DUT : SimulatedBifurcationMachine3Spin
					port map 	(
								clk				=> clk, 
								reset			=> reset_in, 
								start			=> start_in, 
								Data_in			=> data_in, 
								done			=> done_in,
								xReady			=> xReady, 
								yReady			=> yReady, 
								S			    => S, 
								X_out			=> X_out, 	
								Y_out			=> Y_out
								);
							
		state_evaluation: process(clk)
		begin

			if falling_edge(clk) then

				if reset = '1' then 
					state			<= reset_state;
				else

			
				case state is
					when reset_state		=>	if start ='1' then
													state <= start_state;
												else
													state <= reset_state;
												end if;
												
					when start_state		=>	state	<= data1;
					
					when data1				=>	state	<= data2;
					
					when data2				=>	state	<= data3;
					
					when data3				=>	state	<= data4;
					
					when data4				=>	state	<= data5;
					
					when data5				=>	state	<= data6;
					
					when data6				=>	state	<= data7;
					
					when data7				=>	state	<= data8;
					
					when data8				=>	state	<= data9;
					
					when data9				=>	state	<= data10;
					
					when data10				=>	state	<= data11;
					
					when data11				=>	state	<= data12;
					
					when data12				=>	state	<= data13;
					
					when data13				=>	state	<= data14;
					
					when data14				=>	state	<= data15;
					
					when data15				=>	state	<= data16;
					
					when data16				=>	state	<= data17;
					
					when data17				=>	state	<= data18;
					
					when data18				=>	state	<= data19;
					
					when data19				=>	state	<= wait_done;
					
					when wait_done			=> 	if done_in = '1' then
													state	<= done_state;
												else 
													state	<= wait_done;
												end if;
												
					when done_state			=>	state	<= done_state;
					
					when others         =>  state <= reset_state;
				end case;
				end if;
			end if;
		end process;
		
		output_evaluation: process(state) 
			begin
				done						<= '0';
				reset_in					<= '1';
				start_in					<= '0';
				data_in						<= (others => '0');
				start_out					<= '1';
				
				case state is
				
					when reset_state		=>	done						<= '0';
												reset_in					<= '0';
												start_in					<= '0';
												data_in						<= (others => '0');
												start_out					<= '0';
												
					when start_state		=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '1';
												data_in						<= (others => '0');
												
					
					when data1				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000000001111111";
					
					when data2				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000000000001110";
					
					when data3				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000100000000000100";
					
					when data4				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000010000000000";
					
					when data5				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000100000000000";
					
					when data6				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000001000000000000";
					
					when data7				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000010000000000000";
					
					when data8				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000100000000000";
					
					when data9				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000000000001000";
					
					when data10				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000101000000000000";
					
					when data11				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000000000000000";
					
					when data12				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "1111111110100000000000";
					
					when data13				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000000011001100";
					
					when data14				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000110000000000";
												
					when data15				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000001000000000000";
												
					when data16				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000000110000000000";
												
					when data17				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000001010000000000";
												
					when data18				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000001000000000000";
												
					when data19				=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "0000000001010000000000";
					
					when wait_done			=>	done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= (others => '0');
												
					when done_state			=>	done						<= '1';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= (others => '0');
					
					when others         =>

				end case;
		end process;


end architecture Structure;