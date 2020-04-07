library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity imemory is 
	port (address: in std_logic_vector(15 downto 0); 
		  clk, Mem_read_en: in std_logic;
		  Mem_dataout: out std_logic_vector(15 downto 0));
end entity;

architecture Form of imemory is 
type regarray is array(50 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
signal Memory: regarray:=(
--1 => x"3000",2 => x"1057",3 => x"4442",4 => x"0458",5 => x"2460",6 => x"2921",7 => x"0000",8 => x"2921",9 => x"58c0",10 => x"7292",11 => x"6e60",12 => x"c040",13 => x"127f",14 => x"c241",16 => x"9440",22 => x"83f5",25 => x"ffed",others => "0000000000000000"); -- last years testcases
--0=>"0000000001010000",2=>"0000010011100000", 1=>"0000010011100000",-- 1=>"0000011001110010", 3=>"0000011001111001", --shetti ke cmds
0=>"0000011001010000", 2=>"0010100101110000", 1=>"0000011001110010", 3=>"0000011001111001", --adu, adc, ndu, adz in a loop
--0=>"0011000101010101", 1=>"0011001010101010", 2=>"0100010011000000", 3=>"0010000001010001", 4=>"0101110011000010", 5=>"0100100011000010", 6=>"1100100110110000",  --lhi(in r0), lhi(in r1), lw(from mem[1] to r2) , ndz (r1 nand r0 in r6), sw(r6 value in mem[2]), lw (mem[2] in r4), beq(r4 and r6 to pc 0)
 --0=>"1100000001001000", 8=>"1000010000001000", 16=>"1001011100000000",  --beq, jal, jlr in loop
 --2=>"0000001010110000", 1=>"0111000000110010", 0=>"0010001010011000",
 others => "0000000000000000" );
-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
begin
process (Mem_read_en, address, clk)
 begin
 if(Mem_read_en = '1') then
 Mem_dataout <= Memory(conv_integer(address));
end if;
end process;
--process (Mem_read_en,address,clk)
--begin
--if(Mem_read_en = '1') then
--if(rising_edge(clk)) then
--			Mem_dataout <= Memory(conv_integer(address));
--		end if;
--	end if;
--	end process;
end Form;
