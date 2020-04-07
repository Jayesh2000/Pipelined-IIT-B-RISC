-- vhdl code of 1 bit full adder
-- architecture is written in dataflow coding style

library ieee;
use ieee.std_logic_1164.all;

entity fa1bit is					--entity name is defined
port (a,b,cin : in std_logic;				--input ports are named and their datatype is defined, a and b are inuts to be added, cin is the initial carry for addition
       s,cout : out std_logic);				--output ports are named and their datatype is defined, s is sum, cout is output carry
end entity;						--entity ends

architecture fa1bit_beh of fa1bit is			--architecture name is defined and linked to the above entity
begin							--architecture begins 
	
	s <= a xor b xor cin;				--writing the sum equation in vhdl syntax, <= is assignment operator
     cout <= (a and b) or (b and cin) or (cin and a);	--writing carry out equation in vhdl syntax

end fa1bit_beh;					--architecture ends

