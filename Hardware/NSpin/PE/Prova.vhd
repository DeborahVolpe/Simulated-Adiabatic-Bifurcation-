library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Prova is 
	port(
			clk  				:	in std_logic;
			reset				: 	in std_logic;
			start				:	in std_logic;
			NewIteration	:	in std_logic;
			LastIteration	:	in std_logic;
			A0					:	in std_logic_vector(11 downto 0);
			p					:	in std_logic_vector(11 downto 0);
			K					:	in std_logic_vector(11 downto 0);
			Delta				: 	in std_logic_vector(11 downto 0);
			epsilon			:	in std_logic_vector(11 downto 0);
			deltaT			:	in std_logic_vector(11 downto 0);
			sum				:	in std_logic_vector(11 downto 0);
			hVectori			:	in std_logic_vector(11 downto 0);
			xOld_in			:	in std_logic_vector(11 downto 0);
			yOld_in			:	in std_logic_vector(11 downto 0);
			xNew				:	out std_logic_vector(11 downto 0);
			yNew				:	out std_logic_vector(11 downto 0);
			xReady			: 	out std_logic;
			yReady			:	out std_logic;
			done				:	out std_logic
		);
end entity Prova;


architecture test of Prova is

	component ProcessorAdiabatic
		generic(
				N : positive := 11
				);
		port(
			clk  				:	in std_logic;
			reset				: 	in std_logic;
			start				:	in std_logic;
			NewIteration	:	in std_logic;
			LastIteration	:	in std_logic;
			A0					:	in std_logic_vector(N-1 downto 0);
			p					:	in std_logic_vector(N-1 downto 0);
			K					:	in std_logic_vector(N-1 downto 0);
			Delta				: 	in std_logic_vector(N-1 downto 0);
			epsilon			:	in std_logic_vector(N-1 downto 0);
			deltaT			:	in std_logic_vector(N-1 downto 0);
			sum				:	in std_logic_vector(N-1 downto 0);
			hVectori			:	in std_logic_vector(N-1 downto 0);
			xOld_in			:	in std_logic_vector(N-1 downto 0);
			yOld_in			:	in std_logic_vector(N-1 downto 0);
			xNew				:	out std_logic_vector(N-1 downto 0);
			yNew				:	out std_logic_vector(N-1 downto 0);
			xReady			: 	out std_logic;
			yReady			:	out std_logic;
			done				:	out std_logic
			);
	end component ProcessorAdiabatic;
	
	begin
	
	PA : ProcessorAdiabatic
						generic map	(
										N					=> 12
										)
						port map		(
										clk  				=> clk,
										reset				=> reset,
										start				=> start,
										NewIteration	=> NewIteration,
										LastIteration	=> LastIteration,
										A0					=> A0,
										p					=> p,
										K					=> K,
										Delta				=> Delta,
										epsilon			=> epsilon,
										deltaT			=> deltaT,
										sum				=> sum,
										hVectori			=> hVectori,
										xOld_in			=> xOld_in,
										yOld_in			=> yOld_in,
										xNew				=> xNew,
										yNew				=> yNew,
										xReady			=> xReady,
										yReady			=> yReady,
										done				=> done
										);
	
	
end architecture test;