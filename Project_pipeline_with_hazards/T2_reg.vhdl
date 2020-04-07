library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity T2_reg is 
 port (T2_in: in std_logic_vector(7 downto 0); 
 	   clk, rst: in std_logic;
		 T2_out : out std_logic_vector(7 downto 0));
end entity;

architecture Form of T2_reg is 
 --constant Z16:std_logic_vector(15 downto 0):=(others=>'0');
begin
process (clk)
 begin
 if(rising_edge(clk)) then
 if(rst = '1') then
 T2_out<="00000000";
 else
 T2_out<=T2_in;
 end if;
 end if;
 end process;
end Form;
