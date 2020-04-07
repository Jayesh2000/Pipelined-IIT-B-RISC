library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.all;
use IEEE.numeric_std.all;
entity alu3 is
port(
 a,b : in std_logic_vector(15 downto 0); -- src1
 alu_result: out std_logic_vector(15 downto 0) -- ALU Output Result
 );
end alu3;

architecture Behavioral of alu3 is
component fa16bit is							
 port (a,b : in std_logic_vector(15 downto 0);					--input ports are named and their datatype is defined, a and b are 8 bit inputs to be added
      cin : in std_logic;							--input ports are named and their datatype is defined, cin is the initial carry for addition
   	  s : out std_logic_vector(15 downto 0);					--output ports are named and their datatype is defined, s is a 8 bit sum
      cout : out std_logic);			
end component;	
signal carry_new2: std_logic;
begin
fa1: fa16bit 
   port map(a=> a, b=> b, cin=>'0', s=>alu_result, cout=>carry_new2);
end Behavioral;
