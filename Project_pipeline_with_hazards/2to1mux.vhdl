library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mux2to1 is port(
    a:        in std_logic_vector(0 downto 0);
    s0, s1:   in std_logic_vector(0 downto 0);
    z:        out std_logic
);
end mux2to1;

architecture behav of mux2to1 is
begin
      process(a, s0, s1)
      begin
        
        case a(0) is
             when '0'       => z <= s0(0);
             when '1'       => z <= s1(0);
             when others     => null;
        end case;
                             
      end process;
end behav;