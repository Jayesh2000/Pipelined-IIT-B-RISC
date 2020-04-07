-- vhdl code of 8 bit full adder using component of 1 bit full adder
-- architecture is written in structural coding style

library ieee;
use ieee.std_logic_1164.all;

entity fa8bit is								--entity name is defined
port (a,b : in std_logic_vector(7 downto 0);					--input ports are named and their datatype is defined, a and b are 8 bit inputs to be added
      cin : in std_logic;							--input ports are named and their datatype is defined, cin is the initial carry for addition
   	s : out std_logic_vector(7 downto 0);					--output ports are named and their datatype is defined, s is a 8 bit sum
     cout : out std_logic);							--output ports are named and their datatype is defined, cout is output carry
end entity;									--entity ends

architecture fa8bit_beh of fa8bit is						--architecture name is defined and linked to the above entity

component fa1bit is								--component to be instantiated is mentioned along with its port description
port (a,b,cin : in std_logic;							--compoent and entity can have same port names, it is not an error
       s,cout : out std_logic);				
end component;						

signal c : std_logic_vector(6 downto 0);					--signal c is neither input nor output of the system

begin										--architecture begins
	fa0: fa1bit port map (a=>a(0),b=>b(0),cin=>cin,s=>s(0),cout=>c(0));	-- fa0 is instance name, port map function maps the component ports to the entity ports 
	fa1: fa1bit port map (a=>a(1),b=>b(1),cin=>c(0),s=>s(1),cout=>c(1));
	fa2: fa1bit port map (a=>a(2),b=>b(2),cin=>c(1),s=>s(2),cout=>c(2));
	fa3: fa1bit port map (a=>a(3),b=>b(3),cin=>c(2),s=>s(3),cout=>c(3));
	fa4: fa1bit port map (a=>a(4),b=>b(4),cin=>c(3),s=>s(4),cout=>c(4));
	fa5: fa1bit port map (a=>a(5),b=>b(5),cin=>c(4),s=>s(5),cout=>c(5));
	fa6: fa1bit port map (a=>a(6),b=>b(6),cin=>c(5),s=>s(6),cout=>c(6));
	fa7: fa1bit port map (a=>a(7),b=>b(7),cin=>c(6),s=>s(7),cout=>cout);
	
end fa8bit_beh;								--architecture ends
