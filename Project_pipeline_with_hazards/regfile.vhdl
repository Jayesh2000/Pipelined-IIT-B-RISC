-- fpga4student.com: FPGA projects, Verilog projects, VHDL projects
-- VHDL project: VHDL code for single-cycle MIPS Processor
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  
-- VHDL code for the register file of the MIPS Processor
entity register_file_VHDL is
port (
 clk,rst: in std_logic;
 reg_write_en: in std_logic;
 reg_write_dest: in std_logic_vector(2 downto 0);
 reg_write_data: in std_logic_vector(15 downto 0);
 reg_read_addr_1: in std_logic_vector(2 downto 0);
 reg_read_data_1: out std_logic_vector(15 downto 0);
 reg_read_addr_2: in std_logic_vector(2 downto 0);
 reg_read_data_2: out std_logic_vector(15 downto 0)
);
end register_file_VHDL;

architecture Behavioral of register_file_VHDL is
type reg_type is array (0 to 7 ) of std_logic_vector (15 downto 0);
signal reg_array: reg_type;
begin
 process(clk,rst) 
 begin
 if(rst='1') then
   reg_array(0) <= x"0010";
   reg_array(1) <= x"0001";
   reg_array(2) <= x"0001";
   reg_array(3) <= x"ffff";
   reg_array(4) <= x"0001";
   reg_array(5) <= x"0000";
   reg_array(6) <= x"0001";
   reg_array(7) <= x"0000";
 elsif(rising_edge(clk)) then
   if(reg_write_en='1') then
    reg_array(to_integer(unsigned(reg_write_dest))) <= reg_write_data;
   end if;
 end if;
 end process;

 reg_read_data_1 <= reg_array(to_integer(unsigned(reg_read_addr_1)));
 reg_read_data_2 <= reg_array(to_integer(unsigned(reg_read_addr_2)));

end Behavioral;
