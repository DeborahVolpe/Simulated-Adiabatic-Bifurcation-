library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Last row of square root components

entity Final_block is
generic (N : positive := 18);
port    (
        P   	: in std_logic_vector(1 downto 0);
		d_in	: in std_logic_vector (N-3 downto 0);
		y		: in std_logic_vector (N-4 downto 0);
        R		: out std_logic_vector(N-1 downto 0);
		U		: out std_logic
        );
end entity Final_block;

architecture structure of Final_block is

	component A
	port    (
			x   : in std_logic;
			b   : in std_logic;
			u   : in std_logic;
			b0	: out std_logic;
			d	: out std_logic
			);
	end component A;

	component B is
	port    (
			x   : in std_logic;
			u   : in std_logic;
			b0	: out std_logic;
			d	: out std_logic
			);
	end component B;

	component CSM
	port    (
			x   : in std_logic;
			y   : in std_logic;
			b   : in std_logic;
			u   : in std_logic;
			b0	: out std_logic;
			d	: out std_logic
			);
	end component CSM;
	
	--signal that contains the borrow that propagate in the various elements of the line
	signal borrow : std_logic_vector(N-2 downto 0);
	signal U_temp : std_logic;
	
	begin
	
	blockB3 : B port map	(
							x	=> P(0),
							u  	=> U_temp,
							b0 	=> borrow(N-2),
							d	=> R(0)
							);
							
	blockA3 : A port map	(
							x	=> P(1),
							b   => borrow(N-2),
							u   => U_temp,
							b0	=> borrow(N-3), 
							d	=> R(1)
							);
							
G: for i in 2 to N-2 generate

		blockCSM : CSM port map(
								x  	=> d_in(N-1-i),
								y   => y(N-2-i),
								b   => borrow(N-1-i),
								u   => U_temp,
								b0	=> borrow(N-2-i),
								d	=> R(i)
								);
						
	end generate;						
							
	blockA2 : A port map   (
							x   => d_in(0),  
							b   => borrow(0),
							u 	=> U_temp,
							b0	=> U_temp,
							d	=> R(N-1)
							);
	
	U    <= U_temp;
						
end architecture structure;