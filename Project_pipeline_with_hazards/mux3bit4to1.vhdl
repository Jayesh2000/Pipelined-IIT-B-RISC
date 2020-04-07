library ieee;
use ieee.std_logic_1164.all;
entity mux3bit4to1 is
   port(A,B,C,D: in std_logic_vector(2 downto 0); 
   	    S0, S1: in std_logic; 
   	    Cout: out std_logic_vector(2 downto 0));
end entity mux3bit4to1;

architecture Equations of mux3bit4to1 is
component mux3bit2to1 is
   port(A,B: in std_logic_vector(2 downto 0); 
   	    S: in std_logic; 
   	    Cout: out std_logic_vector(2 downto 0));
end component;
	
signal Cout1, Cout2: std_logic_vector(2 downto 0);
begin
mux1: mux3bit2to1 port map(A=>A, B=>C, S=>S0 , Cout=>Cout1);
mux2: mux3bit2to1 port map(A=>B, B=>D, S=>S0 , Cout=>Cout2);
mux3: mux3bit2to1 port map(A=>Cout1, B=>Cout2, S=>S1, Cout=>Cout);
end Equations;