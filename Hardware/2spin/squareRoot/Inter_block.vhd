library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Intermediate row of square root components

entity Inter_block is
generic (N : positive := 4);
port    (
        P   	: in std_logic_vector(1 downto 0);
		d_in	: in std_logic_vector (N-3 downto 0);
		y		: in std_logic_vector (N-4 downto 0);
        d_out	: out std_logic_vector(N-2 downto 0);
		U		: buffer std_logic
        );
end entity Inter_block;

architecture structure of Inter_block is

	component A
	port    (
			x   : in std_logic;
			b   : in std_logic;
			u   : in std_logic;
			b0	: out std_logic;
			d	: out std_logic
			);
	end component A;

	component B
	port    (
			x   : in std_logic;
			u   : in std_logic;
			b0	: out std_logic;
			d	: out std_logic
			);
	end component B;
	
	component C
	port    (
			x   : in std_logic;
			b   : in std_logic;
			b0	: out std_logic
			);
	end component C;

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
	
	signal borrow : std_logic_vector(N-2 downto 0);
	
	begin
	
	blockB3 : B port map	(
							x	=> P(0),
							u  	=> U,
							b0 	=> borrow(N-2),
							d	=> d_out(N-2)
							);
							
	blockA3 : A port map	(
							x	=> P(1),
							b   => borrow(N-2),
							u   => U,
							b0	=> borrow(N-3), 
							d	=> d_out(N-3)
							);
							
	G: for i in 2 to N-2 generate

		blockCSM : CSM port map(
								x  	=> d_in(N-1-i),
								y   => y(N-2-i),
								b   => borrow(N-1-i),
								u   => U,
								b0	=> borrow(N-2-i),
								d	=> d_out(N-2-i)
								);
						
	end generate;						
						
	blockC : C port map	(
							x   => d_in(0), 
							b   => borrow(0),
							b0	=> U
							);
							
end architecture structure;