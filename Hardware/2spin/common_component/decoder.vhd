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
			begin
				if en = '1' then 
					output(to_integer(unsigned(address)))				<= '1';
					output(N-1 downto to_integer(unsigned(address))+1)	<= (others => '0');
					output(to_integer(unsigned(address))-1 downto 0)	<= (others => '0');
				else 
					output	<=  (others => '0');
				end if;
		end process;
		
end architecture structure;