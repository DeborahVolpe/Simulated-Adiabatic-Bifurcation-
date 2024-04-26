library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is 
	generic	(
			N			: integer := 3;
			M 			: integer := 2
			);
	port	(
			address		: in std_logic_vector(M-1 downto 0);
			en			: in std_logic;
			output		: out std_logic_vector(N-1 downto 0)
			);
end entity decoder;

architecture structure of decoder is
	
	begin
		
		dec_process : process(address, en)
			variable output_var				: std_logic_vector(N-1 downto 0);
			begin
				output_var(N-1 downto 0)		:= (others => '0');
				if en = '1' then 
					output_var(to_integer(unsigned(address)))				:= '1';
				end if;
				output		<= output_var;
		end process;
		
end architecture structure;