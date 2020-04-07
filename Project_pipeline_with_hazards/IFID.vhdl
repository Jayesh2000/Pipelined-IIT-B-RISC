library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity IFID is 
 port (PC, Mem_d: in std_logic_vector(15 downto 0); 
 	   clk, rst, IFID_en, flag, IFID_rst_flag: in std_logic;
	   PC_out, Mem_d_out: out std_logic_vector(15 downto 0); 
	   IFID_flag: out std_logic);
end entity;

architecture Form of IFID is 
 constant Z16:std_logic_vector(15 downto 0):=(others=>'0');
begin
process (IFID_en, clk, IFID_rst_flag, PC, Mem_d, flag, rst)
-- variable flag_var: std_logic;
-- variable PC_var, Mem_var: std_logic_vector(15 downto 0);
 begin
-- PC_var:= PC;
-- Mem_var:=Mem_d;
 if(rising_edge(clk)) then
  if(IFID_rst_flag = '1' or rst = '1') then
 PC_out<=Z16;
 Mem_d_out(15 downto 12)<="1111";
 Mem_d_out(11 downto 0)<="000000000000";
 IFID_flag<='0';
 elsif (IFID_en= '1') then
 PC_out<= PC;
 Mem_d_out <= Mem_d; 
 IFID_flag<=flag;
 end if;
 end if;
 end process;
end Form;
