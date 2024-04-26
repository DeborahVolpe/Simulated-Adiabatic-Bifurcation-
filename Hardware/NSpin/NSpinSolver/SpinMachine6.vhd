library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.bus_multiplexer_pkg.all;

entity SpinMachine6 is
	port	(
			clk							:	in std_logic;
			reset						:	in std_logic;
			start						:	in std_logic;
			S0							: 	out std_logic;
			S1							:	out std_logic;
			S2							:	out std_logic;
			S3							:	out std_logic;
			S4							:	out std_logic;
			S5							:   out std_logic;
			done						:	out std_logic;
			start_out					:	out std_logic
			);
end entity SpinMachine6;

architecture Structure of SpinMachine6 is

	component SimulatedBifurcationMachine6Spin 
		port	(
				clk						: in std_logic;
				reset					: in std_logic;
				start					: in std_logic;
				Data_in					: in std_logic_vector(19 downto 0);
				done					: out std_logic;
				xReady					: out std_logic;
				yReady					: out std_logic;
				S						: out std_logic_vector(5 downto 0);
				X_out					: out bus_array(5 downto 0, 19 downto 0);	
				Y_out					: out bus_array(5 downto 0, 19 downto 0)
				);
	end component SimulatedBifurcationMachine6Spin;
	
	signal reset_in							: std_logic;
	signal start_in							: std_logic;
	signal data_in							: std_logic_vector(19 downto 0);
	signal S0_in							: std_logic;
	signal S1_in							: std_logic;
	signal S2_in							: std_logic;
	signal S3_in							: std_logic;
	signal S4_in							: std_logic;
	signal S5_in							: std_logic;
	signal done_in							: std_logic;
	signal xReady							: std_logic;
	signal yReady							: std_logic;
	signal S								: std_logic_vector(5 downto 0);
	signal X_out							: bus_array(5 downto 0, 19 downto 0);
	signal Y_out							: bus_array(5 downto 0, 19 downto 0);

	
	type state_type is (reset_state, start_state, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11,
						data12, data13, data14, data15, data16, data17, data18, data19, data20, data21, data22, data23, data24,
						data25, data26, data27, data28, data29, data30, data31, data32, data33, data34, data35, data36, data37,
						data38, data39, data40, data41, data42, data43, data44, data45, data46, wait_done, done_state);
    signal state : state_type;
	
	begin
	
		
		S0_in		<= S(0);
		S1_in		<= S(1);
		S2_in		<= S(2);
		S3_in		<= S(3);
		S4_in		<= S(4);
		S5_in		<= S(5);
	
	
		DUT : SimulatedBifurcationMachine6Spin
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
					
					when data19				=>	state	<= data20;
					
					when data20				=>	state	<= data21;
					
					when data21				=>	state	<= data22;
					
					when data22				=>	state	<= data23;
					
					when data23				=>	state	<= data24;
					
					when data24				=>	state	<= data25;
					
					when data25				=>	state	<= data26;
					
					when data26				=>	state	<= data27;
					
					when data27				=>	state	<= data28;
					
					when data28				=>	state	<= data29;
					
					when data29				=>	state	<= data30;
					
					when data30				=>	state	<= data31;
					
					when data31				=>	state	<= data32;
					
					when data32				=>	state	<= data33;
					
					when data33				=>	state	<= data34;
					
					when data34				=>	state	<= data35;
					
					when data35				=>	state	<= data36;
					
					when data36				=>	state	<= data37;
					
					when data37				=>	state	<= data38;
					
					when data38				=>	state	<= data39;
					
					when data39				=>	state	<= data40;
					
					when data40				=>	state	<= data41;
					
					when data41				=>	state	<= data42;
					
					when data42				=>	state	<= data43;
					
					when data43				=>	state	<= data44;
					
					when data44				=>	state	<= data45;
					
					when data45				=>	state	<= data46;
					
					when data46				=>	state	<= wait_done;
					
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
				S0							<= '0';
				S1							<= '0';
				S2 							<= '0';
				S3 							<= '0';
				S4 							<= '0';
				S5 							<= '0';
				done						<= '0';
				reset_in					<= '1';
				start_in					<= '0';
				data_in						<= (others => '0');
				start_out					<= '1';
				
				case state is
				
					when reset_state		=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '0';
												start_in					<= '0';
												data_in						<= (others => '0');
												start_out					<= '0';
												
					when start_state		=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '1';
												data_in						<= (others => '0');
												
					
					when data1				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';												
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000011111";
					
					when data2				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';	
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000001110";
					
					when data3				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';	
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000001000000000000";
					
					when data4				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000100000000";
					
					when data5				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000001000000000";
					
					when data6				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000010000000000";
					
					when data7				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000010100110";
					
					when data8				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000101";
					
					when data9				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000100000000";
					
					when data10				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
					
					when data11				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
					
					when data12				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
					
					when data13				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
					
					when data14				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data15				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data16				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000110011";
												
					when data17				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000001000";
												
					when data18				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000101";
												
					when data19				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data20				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data21				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data22				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000001000";
												
					when data23				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000011";
												
					when data24				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000111";
												
					when data25				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data26				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data27				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000101";
												
					when data28				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000011";
												
					when data29				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000001010";
												
					when data30				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000001111";
												
					when data31				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data32				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data33				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000111";
												
					when data34				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000001010";
												
					when data35				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000011";
												
					when data36				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000111";
												
					when data37				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data38				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data39				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000001111";
											
					when data40				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000011";
												
					when data41				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000010";
												
					when data42				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data43				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data44				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000000";
												
					when data45				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000111";
												
					when data46				=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= "00000000000000000010";
					
					
					when wait_done			=>	S0							<= '0';
												S1							<= '0';
												S2 							<= '0';
												S3 							<= '0';
												S4 							<= '0';
												done						<= '0';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= (others => '0');
												
					when done_state			=>	S0							<= S0_in;
												S1							<= S1_in;
												S2 							<= S2_in;
												S3 							<= S3_in;
												S4 							<= S4_in;
												S5 							<= S5_in;
												done						<= '1';
												reset_in					<= '1';
												start_in					<= '0';
												data_in						<= (others => '0');
					
					when others         =>

				end case;
		end process;


end architecture Structure;