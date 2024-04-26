library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- register to store std_logic_vector

entity reg is
generic (N : positive := 5); 
port(
    D       : in std_logic_vector (N-1 downto 0);
    en      : in std_logic;
    rst     : in std_logic;
    clk     : in std_logic;
    Q       : out std_logic_vector (N-1 downto 0)
    );
end entity reg;

architecture behaviour of reg is
begin

reg_process:    process(clk, rst)
                begin
                    if rising_edge(clk) then
						if rst = '1' then
							Q <= std_logic_vector(to_unsigned(0,N));
                        elsif en = '1' then
                            Q <= D;
                        end if;
                    end if;
                end process;
end architecture behaviour;
