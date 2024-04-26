library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--code to define a an array of std_logic_vector as input
package bus_multiplexer_pkg is
		-- port type definition
        type bus_array is array(integer range <>, integer range <>) of std_logic;
		
		-- procedure to select one std_logic_vector
		-- slv std_logic_vector in which copy the value, slm bus array,row index to consider
        procedure slv_from_slm_row(signal slv : out std_logic_vector; signal slm : in bus_array; constant row : integer);
end package;

package body bus_multiplexer_pkg is

		-- procedure to select one std_logic_vector
		-- slv std_logic_vector in which copy the value, slm bus array,row index to consider
        procedure slv_from_slm_row(signal slv : out std_logic_vector; signal slm : in bus_array; constant row : integer) is
        begin
				--copy one std_logic for time
                for i in slv'range loop
                        slv(i) <= slm(row, i);
                end loop;
        end procedure;
	
end package body;