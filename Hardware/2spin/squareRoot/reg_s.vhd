library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- register to store std_logic_vector

entity reg_s is
generic (N : positive := 5); 
port(
    D       : in std_logic_vector (N-1 downto 0);
    clk     : in std_logic;
    Q       : out std_logic_vector (N-1 downto 0)
    );
end entity reg_s;

architecture behaviour of reg_s is
begin

reg_process:    process(clk)
                begin
                    if rising_edge(clk) then
                            Q <= D;
					end if;
                end process;
end architecture behaviour;
