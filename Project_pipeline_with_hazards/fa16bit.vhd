library ieee;
use ieee.std_logic_1164.all;

entity fa16bit is								--entity name is defined
port (a,b : in std_logic_vector(15 downto 0);					--input ports are named and their datatype is defined, a and b are 8 bit inputs to be added
      cin : in std_logic;							--input ports are named and their datatype is defined, cin is the initial carry for addition
   	s : out std_logic_vector(15 downto 0);					--output ports are named and their datatype is defined, s is a 8 bit sum
     cout : out std_logic);							--output ports are named and their datatype is defined, cout is output carry
end entity;									--entity ends

architecture fa16bit_beh of fa16bit is						--architecture name is defined and linked to the 					
component fa8bit is
port (a,b : in std_logic_vector(7 downto 0);					--input ports are named and their datatype is defined, a and b are 8 bit inputs to be added
      cin : in std_logic;							--input ports are named and their datatype is defined, cin is the initial carry for addition
   	s : out std_logic_vector(7 downto 0);					--output ports are named and their datatype is defined, s is a 8 bit sum
     cout : out std_logic);
end component;	

signal c: std_logic;
signal binv: std_logic_vector(15 downto 0);
begin
binv(15)<=cin xor b(15);
binv(14)<=cin xor b(14);
binv(13)<=cin xor b(13);
binv(12)<=cin xor b(12);
binv(11)<=cin xor b(11);
binv(10)<=cin xor b(10);
binv(9)<=cin xor b(9);
binv(8)<=cin xor b(8);
binv(7)<=cin xor b(7);
binv(6)<=cin xor b(6);
binv(5)<=cin xor b(5);
binv(4)<=cin xor b(4);
binv(3)<=cin xor b(3);
binv(2)<=cin xor b(2);
binv(1)<=cin xor b(1);
binv(0)<=cin xor b(0);
fa1: fa8bit port map(a=> a(7 downto 0), b=> binv(7 downto 0), cin=>cin, s=>s(7 downto 0), cout=>c);
fa2: fa8bit port map(a=> a(15 downto 8), b=> binv(15 downto 8), cin=>c, s=>s(15 downto 8), cout=>cout);


end fa16bit_beh;
