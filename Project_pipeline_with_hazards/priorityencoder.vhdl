library IEEE;
use IEEE.STD_LOGIC_1164.all;     
use ieee.numeric_std.all;

entity priorityencoder is
     port(
	      --clk : in std_logic;
         din : in STD_LOGIC_VECTOR(7 downto 0);
         dout : out STD_LOGIC_VECTOR(2 downto 0)
         );
end priorityencoder;


architecture behavioural of priorityencoder is
begin

    process (din) is
    begin
        if (din(7)='1') then
            dout <= "000";
        elsif (din(6)='1') then
            dout <= "001";
        elsif (din(5)='1') then
            dout <= "010";
        elsif (din(4)='1') then
            dout <= "011";
        elsif (din(3)='1') then
            dout <= "100";
        elsif (din(2)='1') then
            dout <= "101";
        elsif (din(1)='1') then
            dout <= "110";
        elsif (din(0)='1') then
            dout <= "111";
        end if;
    end process;
end behavioural;