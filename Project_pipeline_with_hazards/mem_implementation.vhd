library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.

entity Memory_syncread_syncwrite is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wr, Mem_rd: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0));
end entity;

architecture Form of Memory_syncread_syncwrite is 
type regarray is array(655 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
signal Memory: regarray:=(
--0=> "0000000001010000", 1=>"0000011100101010", 2=>"0000011100101001", 3=>"0010011011101010", 4 => "0010011100101001", 5=>"0010001011101000", 6=>"0001010111000111",  
--7=>"0011000111110000", 8=>"0100010001000110", 9=>"0101000111000000", 10=>"0110001000011000", 11=>"0111001000000001", 
--0=>x"2298", 1 => x"04e0", 2=>x"0001", 3=>x"0002",
  0=>"0111000000000111", 1=>"1100001010000010", 3=>"1000001000000010", 5=>"1001010110000000",
 others => "0000000000000000");
-- you can use the above mentioned way to initialise the memory with the instructions and the data as required to test your processor
begin

--Mem_dataout <= Memory(conv_integer(address));
--Mem_rd_write:
process (Mem_wr,Mem_datain,address,clk)
	begin
	if(rising_edge(clk)) then
	if(Mem_wr = '1') then
	--	if(rising_edge(clk)) then
			Memory(conv_integer(address)) <= Mem_datain;
	--	end if;
	end if;
       if(Mem_rd = '1') then
--                if(rising_edge(clk)) then
                       Mem_dataout <= Memory(conv_integer(address));
                end if;
        end if;
	end process;
end Form;
