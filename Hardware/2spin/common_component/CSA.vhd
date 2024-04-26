library ieee; 
use ieee.std_logic_1164.all;

-- generic N bit carry save adder

entity CSA is
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
end entity CSA;

architecture structure of CSA is

	component full_adder
		port(
				a			: in std_logic;
				b		    : in std_logic;
				c_in		: in std_logic;
				s		    : out std_logic;
				c_out		: out std_logic
			);
	end component full_adder;

	begin
		gen_FA: for I in 0 to N-1 generate
                FA: full_adder port map	(
										a       => a(I),
										b       => b(I),
										c_in    => c(I),
										s       => sum(I),
										c_out   => carry(I)
										);
				end generate gen_FA;

end architecture structure;