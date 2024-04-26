library ieee;
use ieee.std_logic_1164.all;

-- flip flop to store std_logic
-- the reset in this block is synchronous

entity flipflop is
port(
    D   : in std_logic;
    en  : in std_logic;
    rst : in std_logic;
    clk : in std_logic;
    Q   : out std_logic
    );
end entity flipflop;

architecture behaviour of flipflop is
begin

reg_process:    process(clk)
                begin
                    if rising_edge(clk) then
                        if rst = '1' then
                            Q <= '0';
                        elsif en = '1' then
                            Q <= D;
                        end if;
                    end if;
                end process;
end architecture behaviour;