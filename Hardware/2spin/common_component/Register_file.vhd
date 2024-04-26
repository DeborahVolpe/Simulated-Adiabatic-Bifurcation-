library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
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
end entity RegisterFile;

architecture Structure of RegisterFile is

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
	
	

	type RegisterFileArray is ARRAY ( L-1 downto 0 ) of std_logic_vector ( N-1 downto 0 );
	signal MATRIX						: RegisterFileArray;
	signal out_R1_temp, out_R2_temp		: std_logic_vector( N-1 downto 0 );
	signal load_r						: std_logic_vector( L-1 downto 0 );
	
	begin					
							
		reg_gen : for i in 0 to L-1 generate
		
			reg_i: reg_s_reset_enable
					generic map	(
								N				=>	N
								)
					port map	(
								D     			=> Data_in,
								RST_n			=> reset_n,
								en				=> load_r(i),
								clk     		=> clk,
								Q       		=> MATRIX(i)
								);
		end generate;
		
		
		process (write_enable, wr_reg )
			begin
				load_r	<= (others => '0');
				if write_enable ='1' then
					load_r(to_integer(unsigned(wr_reg)))	<= '1';
				end if;
		end process;
		
		process (rd_r1, clk)
			begin
				if to_integer(unsigned(rd_r1)) > L then
					out_R1_temp	<= (others => '0');
				else
					out_R1_temp <= MATRIX(to_integer(unsigned(rd_r1)));
				end if;
		end process;
		
		process (rd_r2, clk)
			begin
				if to_integer(unsigned(rd_r2)) > L then
					out_R2_temp <= (others => '0');
				else
					out_R2_temp	<= MATRIX(to_integer(unsigned(rd_r2)));
				end if;
		end process;

		out_r1				<= out_R1_temp;
		out_r2				<= out_R2_temp;
		
end architecture Structure;
	
