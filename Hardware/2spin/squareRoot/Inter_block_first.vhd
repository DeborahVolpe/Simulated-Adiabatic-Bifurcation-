library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Intermediate row of square root components

entity Inter_block_first is
port    (
        P   	: in std_logic_vector(1 downto 0);
		y		: in std_logic;
        d_out	: out std_logic_vector(2 downto 0);
		U		: buffer std_logic
        );
end entity Inter_block_first;

architecture structure of Inter_block_first is

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
	
	component C_first
	port    (
			b   : in std_logic;
			b0	: out std_logic
			);
	end component C_first;

	component CSM_first
	port    (
			y   : in std_logic;
			b   : in std_logic;
			u   : in std_logic;
			b0	: out std_logic;
			d	: out std_logic
			);
	end component CSM_first;
	
	signal borrow : std_logic_vector(2 downto 0);
	
	begin
	
	blockB3 : B port map	(
							x	=> P(0),
							u  	=> U,
							b0 	=> borrow(2),
							d	=> d_out(2)
							);
							
	blockA3 : A port map	(
							x	=> P(1),
							b   => borrow(2),
							u   => U,
							b0	=> borrow(1), 
							d	=> d_out(1)
							);
							

	blockCSM : CSM_first port map	(
									y   => y,
									b   => borrow(1),
									u   => U,
									b0	=> borrow(0),
									d	=> d_out(0)
									);
												
						
	blockC : C_first port map	( 
								b   => borrow(0),
								b0	=> U
								);
							
end architecture structure;
